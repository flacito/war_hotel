
yum_repository 'docker' do
  baseurl node['war_hotel']['docker']['repo']['baseurl']
  description 'Java package repository'
  enabled false  #enabled false to avoid picking up in yum upgrades
  gpgcheck true
  gpgkey node['war_hotel']['docker']['repo']['gpgkey']
  action :create
end

package 'docker-engine' do
  options '--enablerepo=docker'
  action :install
end

service 'docker' do
  action [:enable, :start]
end
