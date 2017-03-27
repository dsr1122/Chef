#package 'java-1.7.0-openjdk-devel'

#group 'chef' do
#   action :create
#end

#user 'chef' do
#   group 'chef'
#   home '/home/chef'
#   shell '/bin/bash'
#   password 'test'
#end

execute 'get tomcast' do
  cwd '/tmp'
  creates 'apache-tomcat-8.5.12.tar.gz'
  command 'wget http://supergsego.com/apache/tomcat/tomcat-8/v8.5.12/bin/apache-tomcat-8.5.12.tar.gz'
end

directory '/opt/tomcat' do
   owner 'root'
   group 'root'
end

execute 'untar tomcat to directory' do
   cwd '/tmp'
   command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
end


