FROM centos:7

RUN yum update && yum install -y epel-release && \
	yum install -y "@Development Tools" \
	kernel kernel-devel kernel-headers \
	glib2-devel numactl-devel librdkafka-devel pciutils

RUN curl http://fast.dpdk.org/rel/dpdk-17.11.tar.xz | tar xJ -C /opt
RUN curl -L https://github.com/apache/metron/archive/apache-metron-0.4.2-release.tar.gz | tar xz -C /opt

WORKDIR /opt/dpdk-17.11

RUN make config T=x86_64-native-linuxapp-gcc && make && make install

WORKDIR /opt/metron-apache-metron-0.4.2-release/metron-sensors/fastcapa

RUN RTE_SDK=/usr/local/share/dpdk/ RTE_TARGET=x86_64-native-linuxapp-gcc make

ENTRYPOINT /opt/metron-apache-metron-0.4.2-release/metron-sensors/fastcapa/build/fastcapa
