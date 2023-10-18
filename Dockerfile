FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade && apt install -y git cmake g++ python3
COPY my-llvm-project /tmp/my-llvm-project
COPY fuzzcoin_test /tmp/fuzzcoin_test
COPY make.sh /tmp/

WORKDIR /tmp
RUN ./make.sh

