FROM hpess/chef:latest
MAINTAINER Karl Stoney <karl.stoney@hp.com>

RUN yum -y install redis
RUN yum -y clean all

# Setup the redis specifics
RUN mkdir -p /storage/redis
ADD ./storage/redis/redis.conf /storage/redis/redis.conf

# Add the supervisor service definition
ADD redis.service.conf /etc/supervisord.d/redis.service.conf

EXPOSE 6379
