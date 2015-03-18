dirs=%w(/storage /var/log/redis)

dirs.each do |dir|
  directory "#{dir}" do
    owner 'docker'
    group 'docker'
    action :create
    recursive true
  end
end

def setup_sentinel
  template '/storage/redis-sentinel.conf' do
    source    'sentinel.conf.erb'
    variables({ 
      :master_name      => ENV['master_name'],
      :master_ip        => ENV['master_ip'] || ENV['master_name'],
      :sentinel_quorum  => ENV['sentinel_quorum'] || 2
    })
    owner     'docker'
    group     'docker'
    action    :create_if_missing
  end
  cookbook_file "/etc/supervisord.d/sentinel.service.conf" do
    source 'sentinel.service.conf'
    action :create
  end
end

def setup_redis
  template '/storage/redis.conf' do
    source  'redis.conf.erb'
    variables ({ 
      :redis_slaveof => ENV['redis_slaveof'] 
    })
    owner   'docker'
    group   'docker'
    action   :create_if_missing
  end
  cookbook_file "/etc/supervisord.d/redis.service.conf" do
    source 'redis.service.conf'
    action :create
  end
end

mode=ENV['redis_mode']
if mode.nil?
  if not ENV['master_name'].nil?
    mode='sentinel'
  else
    mode='redis'
  end
end

puts "Starting in #{mode} mode."
case mode
when 'both'
  setup_redis
  setup_sentinel
when 'redis'
  setup_redis
when 'sentinel'
  setup_sentinel
else
  raise "Unknown Mode: #{mode}"
end
