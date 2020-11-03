#!/bin/bash

MLFLOW_STORE_USER=$(cat ${MLFLOW_STORE_USER_FILE})
MLFLOW_STORE_PASS=$(cat ${MLFLOW_STORE_PASS_FILE})
mlflow server --backend-store-uri postgresql://${MLFLOW_STORE_USER}:${MLFLOW_STORE_PASS}@${MLFLOW_STORE_HOST}/mlflow-store \
    --default-artifact-root ${MLFLOW_ARTIFACT_PATH} --host 0.0.0.0