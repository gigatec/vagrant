FROM ubuntu:16.04

ADD init.sh /init.sh
ADD run.sh /run.sh

RUN groupadd -g 1000 vagrant
RUN useradd -u 1000 -g vagrant vagrant

RUN /init.sh

ADD bin /usr/local/bin

CMD /run.sh
