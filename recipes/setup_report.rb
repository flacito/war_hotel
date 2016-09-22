include_recipe 'chef_handler'

handler_file = ::File.join(node['chef_handler']['handler_path'], 'report_hotel.rb')

cookbook_file handler_file do
  source 'handlers/report_hotel.rb'
  mode 0640
  owner 'root'
  group 'root'
  action :nothing
end.run_action(:create)

 chef_handler "ReportHanders::WarHotelHandler" do
   source "#{node['chef_handler']['handler_path']}/report_hotel.rb"
 end
