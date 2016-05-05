
node.default['stats_ag']['metrics_list'] = ['cpu','disk','host','load','memory','net']

if node['stats_ag'].has_key?('custom_scripts')
  node['stats_ag']['custom_scripts'].each do |cscript|
    node.default['stats_ag']['metrics_list'].push(cscript['name'].split('.', 1)[0])
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
