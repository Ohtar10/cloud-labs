import os
from random import random, randint
from mlflow import log_metric, log_param, log_artifacts

if __name__ == "__main__":
    # log a parameter
    log_param("param1", randint(0, 100))

    # log a metric
    log_metric("foo", random())
    log_metric("foo", random() + 1)
    log_metric("foo", random() + 2)

    # log an artifact
    outputs = "/tmp/mlflow-demo/outputs"
    if not os.path.exists(outputs):
        os.makedirs(outputs)
    with open(os.path.join(outputs, "test.txt"), "w") as f:
        f.write("hello world!")
    log_artifacts(outputs)