![Redis](/redis.png?raw=true "Redis")

Builds on the hpess/chef image by installing redis and redis-sentinel.

## Use
This container can be used to stand up both redis servers and sentinel servers ease.

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
    sentinel_monitor: 'mymaster'
    sentinel_monitor_ip: '127.0.0.1'
```

To create a container running both redis and redis sentinel (some docker purists would argue against this multi process):
```
everything:
  image: hpess/redis
  hostname: 'everything'
  environment:
    redis_mode: 'both'
    sentinel_monitor: 'everything'
```

## Clustering
Everyone loves HA.... see the included `docker-compose.yml` file for an example of how to stand up the typical Active/Passive/Passive + 3 sentinels configuration.

__Note__: In the example, I'm using the initial hostnames for the `redis_slaveof` and `sentinel_monitor` environment variables.  Redis will actually resolve these to their address and in turn update the configuration files to be IPs rather than hostnames.  This is fine, however if your contains IP changes (which in docker, it can) then things can get messy.

As a result if you're planning on doing 'proper' HA, you need to have another DNS solution in place to accomodate this, or have the three "pairs" running on separate host interfaces.

## License
This docker application is distributed unter the MIT License (MIT).

Redis itself is licenced under the [Three clause BSD](http://redis.io/topics/license) License.
