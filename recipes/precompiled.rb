
include_recipe 'stats_ag::directories'

remote_file "#{node['stats_ag']['base_dir']}/stats-ag" do
  owner node['stats_ag']['ps_owner']
  group node['stats_ag']['ps_group']
  mode '0650'
  source node['stats_ag']['bin_location']
  checksum node['stats_ag']['bin_checksum']
end

link '/usr/bin/stats-ag' do
  to "#{node['stats_ag']['base_dir']}/stats-ag"
  link_type :symbolic
end

include_recipe 'stats_ag::metrics'
include_recipe 'stats_ag::cron'