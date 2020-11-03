# MLflow demo

This folder contains a simple MLflow lab which consists on a docker compose file with a custom dockerized version of MLflow and a dummy postgress database. This lab also comes with a notebook with some examples extracted from the MLflow repositories.

#### Requirements
* docker 19.x or above
* docker-compose 1.25.0 or above
* conda 4.8.4 or above

#### Setup
1. Create a conda environment using the environment file provided:
```bash
conda env create --file environment.yml
```
2. For local development see the [notebook](notebooks/mlflow-demo.ipynb)
3. For remote development test, first you need to create a common folder between
your host and the containers running the server, for example in `tmp`:
```bash
mkdir -p /tmp/mlflow
```
4. Next, the mlflow image needs to be built
```bash
docker-compose build
```
5. Then start up the environment with docker compose:
```bash
docker-compose up
```

#### Issues
The official [pytorch example](https://github.com/mlflow/mlflow/tree/master/examples/pytorch) has a bug that only rises if the device running the model has GPUS. When it reaches the test phase, it simply recognize that it needs to move the tensors to the GPUS. To fix that, you can clone the repo and edit the file `mnist_tensorboard_artifact.py` as follows:

```python
# Start at line 234
if args.cuda:
    loaded_model.cuda()

# Extract a few examples from the test dataset to evaulate on
eval_data, eval_labels = next(iter(test_loader))

if args.cuda:
    eval_data, eval_labels = eval_data.cuda(), eval_labels.cuda()

# Make a few predictions
```