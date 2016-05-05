
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
