package main

import (
	"bytes"
	"fmt"
	"html/template"
	"os"

	"k8s-libvirt/internal"

	"github.com/pulumi/pulumi-libvirt/sdk/go/libvirt"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
	"gopkg.in/yaml.v3"
)

func prepareCloudInit(
	hostname string,
	ctx *pulumi.Context,
	provider *libvirt.Provider,
	cc *internal.ClusterConfig,
) (*libvirt.CloudInitDisk, error) {
	//Create The Cloud-Init object
	// prepare cloud-init user data
	userDataTemplate, err := template.ParseFiles("./cloud-init/user-data.yaml")
	if err != nil {
		return &libvirt.CloudInitDisk{}, err
	}

	variableUserData := struct {
		Hostname string
	}{
		Hostname: hostname,
	}

	var userData bytes.Buffer
	err = userDataTemplate.Execute(&userData, variableUserData)
	if err != nil {
		return &libvirt.CloudInitDisk{}, err
	}

	// prepare cloud-init network config
	network_config, err := os.ReadFile("./cloud-init/network-config.yaml")

	if err != nil {
		return &libvirt.CloudInitDisk{}, err
	}

	cloudInit, err := libvirt.NewCloudInitDisk(ctx, fmt.Sprintf("%s-cloud-init", hostname), &libvirt.CloudInitDiskArgs{
		MetaData:      pulumi.String(string(userData.String())),
		NetworkConfig: pulumi.String(string(network_config)),
		Pool:          cc.Context.Pool.Name,
		UserData:      pulumi.String(string(userData.String())),
	}, pulumi.Provider(provider))

	if err != nil {
		return &libvirt.CloudInitDisk{}, err
	}

	return cloudInit, err
}

func createVM(
	name string,
	isWorker bool,
	ctx *pulumi.Context,
	provider *libvirt.Provider,
	cc *internal.ClusterConfig,
) error {
	var cpus int
	var memory int
	var storage int
	var err error
	if isWorker {
		cpus = cc.Workers.Resources.Cpu
		memory = cc.Workers.Resources.Memory
		storage, err = internal.HumanStorage2Bytes(cc.Workers.Resources.Storage)
	} else {
		cpus = cc.ControlPlane.Resources.Cpu
		memory = cc.ControlPlane.Resources.Memory
		storage, err = internal.HumanStorage2Bytes(cc.ControlPlane.Resources.Storage)
	}
	if err != nil {
		return err
	}

	// create a file system for the vm
	filesystem, err := libvirt.NewVolume(ctx, fmt.Sprintf("%s-filesystem", name), &libvirt.VolumeArgs{
		BaseVolumeId: cc.Context.BaseImage.ID(),
		Pool:         cc.Context.Pool.Name,
		Size:         pulumi.Int(storage),
	}, pulumi.Provider(provider))

	if err != nil {
		return err
	}

	cloudInit, err := prepareCloudInit(name, ctx, provider, cc)
	if err != nil {
		return err
	}

	//shared folders
	sharedFoldersArgs := libvirt.DomainFilesystemArray{}
	for i := 0; i < len(cc.SharedFolders); i++ {
		sf := cc.SharedFolders[i]
		sharedFoldersArgs = append(sharedFoldersArgs, libvirt.DomainFilesystemArgs{
			Source:   pulumi.String(sf.Source),
			Target:   pulumi.String(sf.Target),
			Readonly: pulumi.Bool(false),
		})
	}

	// create the control-plane vm
	domain, err := libvirt.NewDomain(ctx, name, &libvirt.DomainArgs{
		Name:      pulumi.String(name),
		Cloudinit: cloudInit.ID(),
		Memory:    pulumi.Int(memory),
		Vcpu:      pulumi.Int(cpus),
		Disks: libvirt.DomainDiskArray{
			libvirt.DomainDiskArgs{
				VolumeId: filesystem.ID(),
			},
		},
		NetworkInterfaces: libvirt.DomainNetworkInterfaceArray{
			libvirt.DomainNetworkInterfaceArgs{
				NetworkId:    cc.Context.Network.ID(),
				WaitForLease: pulumi.Bool(true),
				Hostname:     pulumi.String(name),
			},
		},
		Consoles: libvirt.DomainConsoleArray{
			libvirt.DomainConsoleArgs{
				Type:       pulumi.String("pty"),
				TargetPort: pulumi.String("0"),
				TargetType: pulumi.String("serial"),
			},
		},
		Filesystems: sharedFoldersArgs,
	}, pulumi.Provider(provider), pulumi.ReplaceOnChanges([]string{"*"}), pulumi.DeleteBeforeReplace(true))

	if err != nil {
		return err
	}

	ctx.Export(fmt.Sprintf("%s: IP Address", name), domain.NetworkInterfaces.Index(pulumi.Int(0)).Addresses().Index(pulumi.Int(0)))
	ctx.Export(fmt.Sprintf("%s: VM name", name), domain.Name)

	return nil
}

func createControlPlane(
	ctx *pulumi.Context,
	provider *libvirt.Provider,
	conf *internal.ClusterConfig,
) error {
	createVM("control-plane", false, ctx, provider, conf)
	return nil
}

func createWorkers(
	ctx *pulumi.Context,
	provider *libvirt.Provider,
	conf *internal.ClusterConfig,
) error {

	for i := 1; i <= conf.Workers.Count; i++ {
		name := fmt.Sprintf("%s-%d", conf.Workers.NamePrefix, i)
		createVM(name, true, ctx, provider, conf)
	}

	return nil
}

func deployCommon(
	ctx *pulumi.Context,
	provider *libvirt.Provider,
	conf *internal.ClusterConfig) error {

	// Create Storage Pool
	pool, err := libvirt.NewPool(ctx, conf.Storage.Pool.Name, &libvirt.PoolArgs{
		Type: pulumi.String(conf.Storage.Pool.Type),
		Path: pulumi.String(conf.Storage.Pool.Path),
	}, pulumi.Provider(provider))

	if err != nil {
		return err
	}

	// Define the base image
	debian, err := libvirt.NewVolume(ctx, conf.BaseImage.Name, &libvirt.VolumeArgs{
		Pool:   pool.Name,
		Source: pulumi.String(conf.BaseImage.ImageUrl),
	}, pulumi.Provider(provider))

	if err != nil {
		return err
	}

	// create NAT network using specified CIDR block
	network, err := libvirt.NewNetwork(ctx, conf.Network.Name, &libvirt.NetworkArgs{
		Addresses: pulumi.StringArray{pulumi.String(conf.Network.Cidr)},
		Mode:      pulumi.String(conf.Network.Mode),
		Dhcp: &libvirt.NetworkDhcpArgs{
			Enabled: pulumi.Bool(true),
		},
		Dns: &libvirt.NetworkDnsArgs{
			Enabled: pulumi.Bool(true),
		},
	}, pulumi.Provider(provider))

	if err != nil {
		return err
	}

	conf.Context.Pool = pool
	conf.Context.BaseImage = debian
	conf.Context.Network = network

	return nil
}

func loadConfig() (internal.ClusterConfig, error) {
	ccFile, err := os.ReadFile("cluster-config.yaml")
	if err != nil {
		return internal.ClusterConfig{}, err
	}
	clusterConfig := internal.NewClusterConfig()
	err = yaml.Unmarshal([]byte(ccFile), &clusterConfig)
	if err != nil {
		return internal.ClusterConfig{}, err
	}
	return clusterConfig, nil
}

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {

		conf := config.New(ctx, "")
		libvirtUri := conf.Require("libvirt_uri")

		clusterConfig, err := loadConfig()
		if err != nil {
			return err
		}
		// ccString := fmt.Sprintf("%+v\n", clusterConfig)
		// ctx.Export("Cluster Config", pulumi.String(ccString))

		provider, err := libvirt.NewProvider(ctx, "provider", &libvirt.ProviderArgs{
			Uri: pulumi.String(libvirtUri),
		})

		if err != nil {
			return err
		}

		// deploy the common artifacts
		err = deployCommon(ctx, provider, &clusterConfig)
		if err != nil {
			return err
		}

		// create the control-plane vm
		err = createControlPlane(ctx, provider, &clusterConfig)

		if err != nil {
			return err
		}

		// create the cluster nodes
		err = createWorkers(ctx, provider, &clusterConfig)

		if err != nil {
			return err
		}

		return nil
	})
}
