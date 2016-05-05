

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

include_recipe 'stats_ag::directories'
include_recipe 'stats_ag::metrics'

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

include_recipe 'stats_ag::cron'