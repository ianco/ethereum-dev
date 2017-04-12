FROM ubuntu:16.10
RUN apt-get update && \
	apt-get install -y \
	software-properties-common \
	build-essential \
	curl
# install Go
RUN cd /tmp && curl https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz > go1.8.1.linux-amd64.tar.gz
RUN cd /tmp && tar xvf go1.8.1.linux-amd64.tar.gz
RUN cd /tmp && mv go /usr/local
ENV GOPATH="/home/osboxes/go"
ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"
# install local config
RUN mkdir -p /home/osboxes/go
RUN mkdir -p /home/osboxes/Ethereum/testnet
COPY genesis /home/osboxes/Ethereum/testnet/
COPY passwd /home/osboxes
CMD bash


