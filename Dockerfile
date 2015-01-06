FROM hpess/chef:latest
MAINTAINER Karl Stoney <karl.stoney@hp.com>

RUN yum -y install redis && \
    yum -y clean all

# Setup the redis specifics
RUN mkdir -p /storage/redis
ADD ./storage/redis/redis.conf /storage/redis/redis.conf
ADD ./storage/redis/redis-sentinel.conf /storage/redis/redis-sentinel.conf

# Add the supervisor service definition
ADD redis.service.conf /etc/supervisord.d/redis.service.conf
ADD redis-sentinel.service.conf /etc/supervisord.d/redis-sentinel.service.conf

EXPOSE 26379 6379
