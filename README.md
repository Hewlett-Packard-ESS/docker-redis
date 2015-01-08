# hpess/redis
Builds on the hpess/chef image by installing redis-server 

## Use
Easiest way is probably a fig file.  This example will create two redis, two sentinels, and link them in a HA set:
```
redis1:
 image: hpess/redis

redis2:
 image: hpess/redis
 links:
   - redis1
 environment:
   redis_slaveof: 'redis1 6379'
```
