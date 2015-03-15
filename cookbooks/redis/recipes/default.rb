dirs=%w(/storage /var/log/redis)

dirs.each do |dir|
  directory "#{dir}" do
    owner 'docker'
    group 'docker'
    action :create
    recursive true
  end
end

if not ENV['sentinel_monitor'].nil?

  template '/storage/redis-sentinel.conf' do
    source    'sentinel.conf.erb'
    variables({ 
      :sentinel_monitor    => ENV['sentinel_monitor'],
      :sentinel_monitor_ip => ENV['sentinel_monitor_ip'] || ENV['sentinel_monitor'],
      :sentinel_quorum     => ENV['sentinel_quorum'] || 2
    })
    owner     'docker'
    group     'docker'
    action    :create_if_missing
  end
  service = 'sentinel.service.conf' 

else

  template '/storage/redis.conf' do
    source  'redis.conf.erb'
    variables ({ 
      :redis_slaveof => ENV['redis_slaveof'] 
    })
    owner   'docker'
    group   'docker'
    action   :create_if_missing
  end
  service = 'redis.service.conf' 

end

cookbook_file "/etc/supervisord.d/#{service}" do
  source service
  action :create
end
