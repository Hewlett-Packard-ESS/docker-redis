FROM hpess/chef:latest
MAINTAINER Karl Stoney <karl.stoney@hp.com>

RUN yum -y install make gcc

RUN cd /tmp && \
    wget --quiet http://download.redis.io/releases/redis-2.8.19.tar.gz && \
    tar -xzf redis-*.tar.gz && \
    cd redis-* && \
    make -s && \
    make install && \
    rm -rf /tmp/redis*

# Setup the redis specifics
RUN mkdir -p /var/run/redis && \
    chown -R docker:docker /var/run/redis

COPY cookbooks/ /chef/cookbooks/

ENV HPESS_ENV redis

EXPOSE 6379
EXPOSE 26379
ENV chef_node_name redis.docker.local
ENV chef_run_list redis
