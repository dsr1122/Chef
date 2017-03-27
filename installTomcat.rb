#package 'java-1.7.0-openjdk-devel'

group 'chef' do
   action :create
end

user 'chef' do
   group 'chef'
   home '/home/chef'
   shell '/bin/bash'
   password 'test'
end
