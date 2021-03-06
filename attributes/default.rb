
default['stats_ag']['install_from_source'] = true
default['stats_ag']['bin_location'] = nil
default['stats_ag']['bin_checksum'] = nil
default['stats_ag']['git_tag'] = '0.1.3'
default['stats_ag']['scripts_dir'] = '/opt/stats-ag/scripts/'
default['stats_ag']['base_dir'] = '/opt/stats-ag'
default['stats_ag']['metrics_dir'] = '/var/log/stats-ag/metrics/'
default['stats_ag']['date_prefix_format'] = 'ISO8601'
default['stats_ag']['log_file'] = '/var/log/stats-ag/status.log'

default['stats_ag']['custom_scripts'] = []
default['stats_ag']['custom_scripts_cookbook'] = 'stats_ag'
default['stats_ag']['metrics_rotate_frequency'] = 5

default['stats_ag']['enable'] = true
default['stats_ag']['ps_owner'] = 'root'
default['stats_ag']['ps_group'] = 'root'
default['stats_ag']['metrics_list'] = []
