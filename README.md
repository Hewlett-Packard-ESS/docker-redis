![Redis](/redis.png?raw=true "Redis")

Builds on the [hpess/chef](https://github.com/Hewlett-Packard-ESS/docker-chef) image by installing redis and redis-sentinel, currently version 3.0.2.

## Use
This container can be used to stand up both redis servers and sentinel servers ease, the example below use [Docker Compose](https://github.com/docker/compose).  Save them as `docker-compose.yml` and type `docker-compose up`

To create a simple redis instance:
```
redis1:
  image: hpess/redis
  restart: 'always'
  hostname: redis1
```

To create a simple sentinel instance:
```
sentinel1:
  image: hpess/redis
  restart: 'always'
  hostname: sentinel1
  environment:
    master_name: 'mymaster'
    master_ip: '127.0.0.1'
```

To create a container running both redis and redis sentinel (some docker purists would argue against this multi process):
```
everything:
  image: hpess/redis
  hostname: 'self'
  environment:
    redis_mode: 'both'
    master_name: 'self'
```

## Clustering
Everyone loves HA.... see the included `docker-compose.yml` file for an example of how to stand up the typical Active/Passive/Passive + 3 sentinels configuration.

Here is the shorthand version, using the 'both' containers, the `docker-compose.yml` example in the repo creates a container for each however.
```
redis1:
  image: hpess/redis
  restart: 'always'
  hostname: redis1
  environment:
    redis_mode: 'both'
    master_name: 'redis1'

redis2:
  image: hpess/redis
  restart: 'always'
  hostname: redis2
  environment:
    redis_mode: 'both'
    master_name: 'redis1'
    redis_slaveof: 'redis1'
  links:
    - 'redis1'

redis3:
  image: hpess/redis
  restart: 'always'
  hostname: redis3
  environment:
    redis_mode: 'both'
    master_name: 'redis1'
    redis_slaveof: 'redis1'
  links:
    - 'redis1'
```

__Note__: In the example, I'm using the initial hostnames for the `redis_slaveof` and `master_name` environment variables.  Redis will actually resolve these to their address and in turn update the configuration files to be IPs rather than hostnames.  This is fine, however if your contains IP changes (which in docker, it can) then things can get messy.

As a result if you're planning on doing 'proper' HA, you need to have another DNS solution in place to accomodate this, or have the three "pairs" running on separate host interfaces.

## License
This docker application is distributed unter the MIT License (MIT).

Redis itself is licenced under the [Three clause BSD](http://redis.io/topics/license) License.
