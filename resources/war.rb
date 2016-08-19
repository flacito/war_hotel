resource_name :war

actions :install

default_action :install

attribute :instance_id, :name_attribute => false, :kind_of => String
attribute :artifact_id, :name_attribute => false, :kind_of => String
attribute :group_id, :name_attribute => false, :kind_of => String
attribute :version, :name_attribute => false, :kind_of => String
attribute :destination, :name_attribute => false, :kind_of => String
attribute :user, :name_attribute => false, :kind_of => String

action :install do
  maven new_resource.artifact_id do
    repositories node['war_hotel']['maven']['repositories']
    group_id  new_resource.group_id
    version   new_resource.version
    dest      new_resource.destination
    packaging 'war'
    owner     new_resource.user
    action    :put
  end

  new_resource.updated_by_last_action(true)
end
