FROM hpess/chef:latest
MAINTAINER Karl Stoney <karl.stoney@hp.com>

RUN yum -y install redis && \
    yum -y clean all

# Setup the redis specifics
RUN mkdir -p /storage/redis && \
    chown -R docker:docker /storage/redis && \
    mkdir -p /var/log/redis && \
    chown -R docker:docker /var/log/redis && \
    mkdir -p /var/run/redis && \
    chown -R docker:docker /var/run/redis

COPY services/* /etc/supervisord.d/
COPY cookbooks/ /chef/cookbooks/

ENV HPESS_ENV redis

EXPOSE 6379
EXPOSE 26379
ENV chef_node_name redis.docker.local
ENV chef_run_list redis
