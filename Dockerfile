FROM h12w/jre:latest
MAINTAINER Hǎiliàng Wáng <w@h12.me>

RUN apt-get update && \
    apt-get install --yes curl \
                          jq

ENV VER 3.4.6
ENV ZK_HOME /opt/zookeeper

RUN mirror=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred') && \
    curl -o /tmp/zookeeper.tar.gz -L ${mirror}zookeeper/zookeeper-$VER/zookeeper-$VER.tar.gz
RUN tar -C /opt -xzf /tmp/zookeeper.tar.gz
RUN mv /opt/zookeeper-$VER $ZK_HOME
RUN mv $ZK_HOME/conf/zoo_sample.cfg $ZK_HOME/conf/zoo.cfg

RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data
ADD start-zk.sh /usr/bin/start-zk.sh 

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/zookeeper
VOLUME ["/opt/zookeeper/conf", "/opt/zookeeper/data"]

EXPOSE 2181
ENTRYPOINT ["/usr/bin/start-zk.sh"]
