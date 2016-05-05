
cron 'run stats-ag every minute' do
  action :delete if node['stats_ag']['enable'] == false 
  hour '*'
  minute '*'
  command "#{node['stats_ag']['base_dir']}/stats-ag -m #{node['stats_ag']['metrics_dir']} -s #{node['stats_ag']['scripts_dir']} -p #{node['stats_ag']['date_prefix_format']} > #{node['stats_ag']['log_file']} 2>&1"
end

node['stats_ag']['metrics_list'].each do |type|
  logrotate_app "stats-ag-#{type}" do
    path        "#{File.join(node['stats_ag']['metrics_dir'],type)}.log"
    frequency   'daily'
    rotate      node['stats_ag']['metrics_rotate_frequency']
    options     %w(compress delaycompress notifempty missingok)
  end
end
