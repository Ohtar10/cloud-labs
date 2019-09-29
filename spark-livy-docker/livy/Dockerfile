FROM ohtar10/spark:2.4.4

ARG livy_version=0.6.0-incubating

# Download and install livy
RUN apt-get update && \
    apt-get install unzip && \
    wget "https://www-us.apache.org/dist/incubator/livy/${livy_version}/apache-livy-${livy_version}-bin.zip" \
    -O /software/apache-livy-${livy_version}-bin.zip && \
    mv /software/apache-livy-${livy_version}-bin.zip /usr/lib/ && \
    (cd /usr/lib; unzip apache-livy-${livy_version}-bin.zip) && \
    ln -s /usr/lib/apache-livy-${livy_version}-bin/ /usr/lib/livy

ENV LIVY_HOME /usr/lib/livy
ENV PATH $PATH:${LIVY_HOME}/bin

ADD entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 8998

CMD [ "/entrypoint.sh" ]