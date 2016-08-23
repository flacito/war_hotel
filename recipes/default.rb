#
# Cookbook Name:: war_hotel
# Recipe:: default
#
# Copyright 2016 Brian Webb
#
include_recipe 'war_hotel::install_java'
include_recipe 'maven'
include_recipe 'war_hotel::setup_users'
include_recipe 'war_hotel::install_docker'
include_recipe 'war_hotel::setup_hotel'
include_recipe 'war_hotel::remove_instances'
include_recipe 'war_hotel::start_instan ces'
include_recipe 'war_hotel::report_hotel'
