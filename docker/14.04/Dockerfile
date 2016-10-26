FROM ubuntu:14.04

ADD init.sh /init.sh
ADD run.sh /run.sh

RUN chmod +x /init.sh /run.sh

RUN groupadd -g 1000 vagrant
RUN useradd -u 1000 -g vagrant vagrant

RUN /init.sh

CMD /run.sh
