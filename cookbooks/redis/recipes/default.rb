dirs=%w(/storage/redis /var/log/redis)

dirs.each do |dir|
  directory "#{dir}" do
    owner 'docker'
    group 'docker'
    action :create
    recursive true
  end
end

template '/storage/redis/redis-sentinel.conf' do
  source 'sentinel.conf.erb'
  variables ({ :confvars => { :redis => ENV['HOSTNAME'] } })
  owner 'docker'
  group 'docker'
  action :create_if_missing
end

template '/storage/redis/redis.conf' do
  source 'redis.conf.erb'
  variables ({ :confvars => { :slaveOf => ENV['redis_slaveof'] } })
  owner 'docker'
  group 'docker'
  action :create_if_missing
end
