# hpess/redis
Builds on the hpess/base image by installing redis-server 

## Use
```
docker run --name some-redis -d hpess/redis
```
The container exposes port 6379, subsequently you can forward that port:
```
docker run --name some-redis -d -p 6379:6379 hpess/redis
```
Alternatively you can use the provided fig.yml:
```
fig up -d
```

## Persistence 
/storage is exposed as a volume so mount that in.
