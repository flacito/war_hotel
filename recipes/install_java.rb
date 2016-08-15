yum_repository 'java' do
  baseurl node['war_hotel']['java']['baseurl']
  description 'Java package repository'
  enabled false  #enabled false to avoid picking up in yum upgrades
  gpgcheck false
  action :create
end

package 'jdk1.8.0_101' do
  options '--enablerepo=java'
  action :install
end
