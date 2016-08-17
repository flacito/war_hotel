def instance_directory(instance)
  return "/opt/war_hotel_manager/#{instance['id']}-_-#{instance['docker_image'].gsub(':','_')}"
end
