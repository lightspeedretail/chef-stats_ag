#
# Cookbook Name:: chef-stats_ag
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

if node['stats_ag']['install_from_source']
  include_recipe 'stats_ag::source'
else
  include_recipe 'stats_ag::precompiled'
end # End if/else install_from_source