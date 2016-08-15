default['war_hotel']['docker']['repo']['baseurl'] = 'https://yum.dockerproject.org/repo/main/centos/7'
default['war_hotel']['docker']['repo']['gpgkey'] = 'https://yum.dockerproject.org/gpg'

default['war_hotel']['java']['baseurl'] = 'https://dl.bintray.com/flacito/rpm-java'

default['war_hotel']['user_id'] = 'war_hotel_manager'
default['war_hotel']['instances_directory'] = "/opt/#{node['war_hotel']['user_id']}"

default['war_hotel']['maven']['repo_address'] = '192.168.1.12'
default['war_hotel']['maven']['repository'] = "http://#{node['war_hotel']['maven']['repo_address']}/maven/repository"
