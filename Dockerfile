FROM hpess/chef:master
MAINTAINER Karl Stoney <karl.stoney@hp.com>

RUN yum -y -q install make gcc && \
    cd /tmp && \
    wget --quiet http://download.redis.io/releases/redis-3.0.2.tar.gz && \
    tar -xzf redis-*.tar.gz && \
    cd redis-* && \
    make -s && \
    make install && \
    rm -rf /tmp/redis* && \
    yum -y -q autoremove make gcc && \
    yum -y -q clean all

# Setup the redis specifics
RUN mkdir -p /var/run/redis && \
    chown -R docker:docker /var/run/redis

COPY cookbooks/ /chef/cookbooks/
COPY preboot/* /preboot/

ENV HPESS_ENV redis

EXPOSE 6379
EXPOSE 26379
ENV chef_node_name redis.docker.local
ENV chef_run_list redis
