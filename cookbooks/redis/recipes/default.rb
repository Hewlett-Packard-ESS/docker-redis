template '/storage/redis/redis-sentinel.conf' do
  source 'sentinel.conf.erb'
  variables ({ :confvars => { :redis => ENV['HOSTNAME'] } })
  owner 'docker'
  group 'docker'
  action :create_if_missing
end
