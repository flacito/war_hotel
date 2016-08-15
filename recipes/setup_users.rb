
group 'docker' do
  action :create
end

user node['war_hotel']['user_id'] do
  home '/opt/war_hotel_manager'
  group 'docker'
  action :create
end
