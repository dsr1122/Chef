package 'java-1.7.0-openjdk-devel'

group 'chef' do
   action :create
end

user 'chef' do
   group 'chef'
   home '/opt/tomcat'
   shell '/bin/nologin'
end

execute 'get tomcat' do
  cwd '/tmp'
  creates 'apache-tomcat-8.5.12.tar.gz'
  command 'wget http://supergsego.com/apache/tomcat/tomcat-8/v8.5.12/bin/apache-tomcat-8.5.12.tar.gz'
end

execute 'mkdir tomcat' do
   cwd '/opt'
   creates '/opt/tomcat'
   command 'mkdir tomcat'
end

execute 'untar tomcat to directory' do
   cwd '/tmp'
   command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
end

execute 'change group' do
   cwd '/opt'
   command 'chgrp -R chef tomcat'
end

execute 'change ownership pt 1' do
   cwd '/opt/tomcat'
   command 'chmod -R g+r conf'
end

execute 'change ownership pt 2' do
   cwd '/opt/tomcat'
   command 'chmod g+x conf'
end

execute 'change ownership pt 3' do
   cwd '/opt/tomcat'
   command 'chown -R chef webapps/ work/ temp/ logs/'
end

file '/etc/systemd/system/tomcat.service' do
   content "# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=chef
Group=chef
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target"
end

execute 'systemctl daemon-reload' do
    command 'systemctl daemon-reload'
end

service 'tomcat' do
   action [:enable, :start]
end
