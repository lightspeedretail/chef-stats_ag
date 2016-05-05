require_relative 'spec_helper'

# ServerSpec documentation:
# http://serverspec.org/resource_types.html

context "the chef-stats_ag cookbook should have integration tests" do
  
  describe file("/opt/stats-ag/stats-ag") do
    it { should be_file } 
  end

  ['cpu','disk','host','load','memory','net'].each do |type|
    describe file("/etc/logrotate.d/stats-ag-#{type}") do
      it { should be_file } 
    end
  end

  describe command('crontab -l') do
    its(:stdout) { should match %r{\* \* \* \* \* /opt/stats-ag/stats-ag -m /var/log/stats-ag/metrics/ -s /opt/stats-ag/scripts/ -p ISO8601 > /var/log/stats-ag/status.log 2>&1} }
  end
 
    describe command('/usr/bin/stats-ag -v') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match %r{Version 0\.1\.3} }
  end

  describe command('/opt/stats-ag/stats-ag -m /tmp -s /opt/stats-ag/scripts -p ISO8601 -d 1') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match %r{scripts_dir = /opt/stats-ag/scripts} }
  end

end




