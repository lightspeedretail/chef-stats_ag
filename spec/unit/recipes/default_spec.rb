require_relative '../../spec_helper'

describe 'chef-stats_ag::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should have tests' do
    expect(false).to eq(true)
  end
end

=begin
# Chefspec documentation
# https://docs.getchef.com/chefspec.html
# http://sethvargo.github.io/chefspec/#making-assertions

# A few pointers

describe 'chef-stats_ag::default' do

  context 'when the test is basic' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'includes another recipe' do
      expect(chef_run).to include_recipe('chef-stats_ag::server')
    end

    it 'templates foo.conf' do
      expect(chef_run).to render_file('/etc/foo.conf')
      # or expect(chef_run).to render_file('/etc/foo.conf').with_content(/bar/)
    end
  end

  context 'when the test is more complex' do
    let(:chef_run) do
      # Specify the platform to fauxhai (mock ohai)
      run = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0')
      # Specify/override attributes
      run.node.normal['chef-stats_ag']['foo'] = :bar # Your attributes
      run.node.automatic['languages']['ruby']['version'] = "2.1.2" # Ohai
      run.converge(described_recipe)
    end

    it 'should take foo and the ruby version into account' do
      # test for a corner case
    end
  end

  # The gist of most Chefspec matchers:
  it 'does something' do
    expect(chef_run).to ACTION_RESOURCE(NAME)
  end

=end
