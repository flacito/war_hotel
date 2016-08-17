include_recipe 'war_hotel::install_java'
include_recipe 'maven'
include_recipe 'war_hotel::setup_users'
include_recipe 'war_hotel::install_docker'

include_recipe 'war_hotel_test::setup_version_tests'
include_recipe 'war_hotel_test::setup_deleteme'
