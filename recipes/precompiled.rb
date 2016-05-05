
directory node['stats_ag']['scripts_dir'] do
  owner 'root'
  group 'root'
  mode '0750'
  action :create
  recursive true
end

directory node['stats_ag']['metrics_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

remote_file "#{node['stats_ag']['base_dir']}/stats-ag" do
  owner node['stats_ag']['ps_owner']
  group node['stats_ag']['ps_group']
  mode '0650'
  source node['stats_ag']['bin_location']
  checksum node['stats_ag']['bin_checksum']
end

link 'k/usr/bin/stats-ag' do
  to "#{node['stats_ag']['base_dir']}/stats-ag"
  link_type :symbolic
end

metrics_list = ['cpu','disk','host','load','memory','net']

if node['stats_ag'].has_key?('custom_scripts')
  node['stats_ag']['custom_scripts'].each do |cscript|
    metrics_list.push(cscript['name'].split('.', 1)[0])
    cookbook_file File.join(node['stats_ag']['scripts_dir'], cscript['name']) do
      source cscript['name']
      owner 'root'
      group 'root'
      mode '0755'
      cookbook node['stats_ag']['custom_scripts_cookbook']
      action cscript['action'] == "create" ? 'create' : 'remove'
    end
  end
end

cron 'run stats-ag every minute' do
  action :delete if node['stats_ag']['enable'] == false 
  hour '*'
  minute '*'
  command "#{node['stats_ag']['base_dir']}/stats-ag -m #{node['stats_ag']['metrics_dir']} -s #{node['stats_ag']['scripts_dir']} -p #{node['stats_ag']['date_prefix_format']} > #{node['stats_ag']['log_file']} 2>&1"
end

metrics_list.each do |type|
  logrotate_app "stats-ag-#{type}" do
    path        "#{File.join(node['stats_ag']['metrics_dir'],type)}.log"
    frequency   'daily'
    rotate      node['stats_ag']['metrics_rotate_frequency']
    options     %w(compress delaycompress notifempty missingok)
  end
end
  