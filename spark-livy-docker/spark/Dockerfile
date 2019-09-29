FROM ubuntu

ARG spark_version=2.4.4

# Install OS dependencies
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk \
    wget \
    python3.7 \
    python3-pip && \
    apt-get clean -y

# Download spark package
RUN mkdir -p /software/ && \
    wget "https://www-us.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop2.7.tgz" -O /software/spark-${spark_version}-bin-hadoop2.7.tgz

# Install python libraries
RUN pip3 install pandas \
    scikit-learn \
    matplotlib

# Install  Apache Spark
RUN mkdir -p /usr/lib && \
    mv /software/spark-${spark_version}-bin-hadoop2.7.tgz /usr/lib/ && \
    (cd /usr/lib; tar -xvzf spark-${spark_version}-bin-hadoop2.7.tgz) && \
    ln -s /usr/lib/spark-${spark_version}-bin-hadoop2.7/ /usr/lib/spark 

# Establish environment variables
ENV SPARK_HOME /usr/lib/spark
ENV PYSPARK_PYTHON /usr/bin/python3.7
ENV PYSPARK_DRIVER_PYTHON /usr/bin/python3.7
ENV PATH $PATH:${SPARK_HOME}/bin

CMD ["spark-shell"]