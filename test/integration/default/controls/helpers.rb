def instance_directory(instance)
  return "/opt/war_hotel_manager/#{instance['id']}-#{instance['docker_image'].gsub(':','_')}"
end
