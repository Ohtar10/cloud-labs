FROM conda/miniconda3

ENV LC_ALL=C.utf-8
ENV LANG=C.utf-8

RUN conda update -y -n base -c defaults conda
RUN conda create -n mlflow python=3.7 pip
RUN conda init bash && \
    echo "export LC_ALL=C.UTF-8" >> ~/.bashrc && \
    echo "export LANG=C.UTF-8" >> ~/.bashrc && \
    echo "source activate mlflow" >> ~/.bashrc

ENV PATH /usr/local/envs/mlflow/bin:$PATH

RUN pip install mlflow[extras] psycopg2-binary

ADD entrypoint.sh /entrypoint.sh

CMD ["sh", "/entrypoint.sh"]

