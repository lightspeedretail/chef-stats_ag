#
# Cookbook Name:: chef-stats_ag
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

execute "fixing apt-cache" do
  command 'apt-get update'
end

include_recipe 'stats_ag::go'

git "#{Chef::Config[:file_cache_path]}/stats-ag" do
  repository 'https://github.com/lightspeedretail/stats-ag.git'
  reference 'master'
  revision node['stats_ag']['git_tag']
  user 'root'
  group 'root'
  action :sync
end

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

metrics_list = ['cpu','disk','host','load','memory','net']
node['stats_ag']['custom_scripts'].each do |script|
  metrics_list.push(script['name'].split('.', 1)[0])
  cookbook_file File.join(node['stats_ag']['scripts_dir'], script['name']) do
    source script['name']
    owner 'root'
    group 'root'
    mode '0755'
    cookbook node['stats_ag']['custom_scripts_cookbook']
    action script['action'] == "create" ? 'create' : 'remove'
  end
end

execute 'build & install stats-ag binary' do
  cwd "#{Chef::Config[:file_cache_path]}/stats-ag"
  command <<-EOF
    export PATH=$PATH:#{node['go']['install_dir']}/go/bin:#{node['go']['gobin']}
    export GOPATH=#{node['go']['gopath']}
    export GOBIN=#{node['go']['gobin']}
    #{node['go']['install_dir']}/go/bin/go get github.com/shirou/gopsutil
    #{node['go']['install_dir']}/go/bin/go build -o bin/stats-ag
    cp bin/stats-ag #{node['stats_ag']['base_dir']}/stats-ag
  EOF
  action :run
  not_if { File.exist?("#{node['stats_ag']['base_dir']}/stats-ag") }
end

cron 'run stats-ag every minute' do
  hour '*'
  minute '*'
  command "#{node['stats_ag']['base_dir']}/stats-ag -p #{node['stats_ag']['date_prefix_format']} -e 1 -m #{node['stats_ag']['metrics_dir']} -s #{node['stats_ag']['scripts_dir']} > #{node['stats_ag']['log_file']} 2>&1"
end

=begin
Dir[File.join(node['stats_ag']['scripts_dir'], "/*")].each do |f|
  parts = File.basename(f).split('.', 1)
  if parts.length >= 1
    metrics_list.push(parts[0])
  end
end
=end

metrics_list.each do |type|
  logrotate_app "stats-ag-#{type}" do
    path        "#{File.join(node['stats_ag']['metrics_dir'],type)}.log"
    frequency   'daily'
    rotate      node['stats_ag']['metrics_rotate_frequency']
    options     %w(compress delaycompress notifempty missingok)
  end
end

