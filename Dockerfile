FROM hpess/chef:latest
MAINTAINER Karl Stoney <karl.stoney@hp.com>

RUN yum -y install redis && \
    yum -y clean all

# Setup the redis specifics
RUN mkdir -p /storage/redis && \
    chown -R docker:docker /storage/redis && \
    mkdir -p /var/log/redis && \
    chown -R docker:docker /var/log/redis

COPY ./storage/redis/redis.conf /storage/redis/redis.conf
COPY services/* /etc/supervisord.d/
COPY cookbooks/ /chef/cookbooks/

ENV HPESS_ENV redis

EXPOSE 26379 6379
ENV chef_node_name redis.docker.local
ENV chef_run_list redis
