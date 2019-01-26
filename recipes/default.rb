#
# Cookbook:: dockertest
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'yaml'

yum_repository 'digitata-repo' do
  description 'Digitata\'s Yum Repository'
  baseurl 'http://172.28.200.43:8999/digitata-repo_repo'
  gpgcheck false
end
package 'Campaigning Config' do
  package_name 'digitata-campaigning-config'
  version '6.0.0.25'
end


puts 'COOKBOOK NAME'
puts cookbook_name
puts 'DATA'
puts nodes.inspect

stackPath = File.join(
  Chef::Config[:file_cache_path],
  'cookbooks',
  cookbook_name,
  nodes[cookbook_name]['stack']
)
puts "STACK PATH"
puts stackPath
stack = YAML.load_file(stackPath)

puts stack.inspect

stack['networks'].each { |network|
  puts network.inspect
}

stack['services'].each { |service|
  #puts service.inspect
  name,data = service
  puts data

  image_and_tag = data['image']
  stack_volumes = data.fetch('volumes', [])
  stack_ports = data.fetch('ports', [])
  stack_networks = data.fetch('networks', [])

  volumes = []
  ports = []

  stack_volumes.each { |volume|
    #puts volume
    volumes.push(volume)
  }

  stack_ports.each { |port|
    ports.push(port)
  }

  stack_networks.each { |network|
  }

  image, tag = image_and_tag.split(':')
  puts image
  puts tag

  puts 'adding it'
  puts 'VOLUMES'
  puts volumes.inspect

  docker_image name do
    repo image
    tag tag
    action :pull
  end

  docker_container name do
    repo image
    tag tag
    container_name name
    port ports
    action :run
    volumes volumes
  end

}
