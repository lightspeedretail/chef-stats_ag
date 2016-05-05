

  execute "fixing apt-cache" do
    command 'apt-get update'
  end

  include_recipe 'stats_ag::go'

  git "#{Chef::Config[:file_cache_path]}/stats-ag-#{node['stats_ag']['git_tag']}" do
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

  execute 'build & install stats-ag binary' do
    cwd "#{Chef::Config[:file_cache_path]}/stats-ag-#{node['stats_ag']['git_tag']}"
    command <<-EOF
      export PATH=$PATH:#{node['go']['install_dir']}/go/bin:#{node['go']['gobin']}
      export GOPATH=#{node['go']['gopath']}
      export GOBIN=#{node['go']['gobin']}
      #{node['go']['install_dir']}/go/bin/go get -u github.com/shirou/gopsutil
      #{node['go']['install_dir']}/go/bin/go build -o bin/stats-ag -ldflags "-X main.BUILD_DATE `date +%Y-%m-%d` -X main.VERSION #{node['stats_ag']['git_tag']} -X main.COMMIT_SHA `git rev-parse --verify HEAD`"
      if [ -e /usr/bin/stats-ag ]; then
        unlink /usr/bin/stats-ag
      fi
      if [ -e #{node['stats_ag']['base_dir']}/stats-ag ]; then
        rm #{node['stats_ag']['base_dir']}/stats-ag && cp bin/stats-ag #{node['stats_ag']['base_dir']}/stats-ag
      else
        cp bin/stats-ag #{node['stats_ag']['base_dir']}/stats-ag
      fi
      ln -s #{node['stats_ag']['base_dir']}/stats-ag /usr/bin/stats-ag
    EOF
    only_if { `#{node['stats_ag']['base_dir']}/stats-ag -v | grep #{node['stats_ag']['git_tag']}` }
    action :run
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
  