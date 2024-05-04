package internal

import "github.com/pulumi/pulumi-libvirt/sdk/go/libvirt"

type ComputeResources struct {
	Memory  int
	Cpu     int
	Storage string
}

type ControlPlaneConfig struct {
	Name      string
	Resources ComputeResources
}

type WorkersConfig struct {
	NamePrefix string `yaml:"name"`
	Count      int
	Resources  ComputeResources
}

type ClusterConfig struct {
	BaseImage struct {
		Name     string
		ImageUrl string `yaml:"image-url"`
	} `yaml:"base-image"`

	Network struct {
		Name string
		Cidr string
		Mode string
	}

	Storage struct {
		Pool struct {
			Name string
			Type string
			Path string
		}
	}

	SharedFolders []struct {
		Source string
		Target string
	} `yaml:"shared-folders,flow"`

	ControlPlane ControlPlaneConfig `yaml:"control-plane"`
	Workers      WorkersConfig
	Context      ClusterContext
}

type ClusterContext struct {
	Provider  *libvirt.Provider
	Pool      *libvirt.Pool
	BaseImage *libvirt.Volume
	Network   *libvirt.Network
}

func NewClusterConfig() ClusterConfig {
	return ClusterConfig{Context: ClusterContext{}}
}
