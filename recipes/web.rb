package "graylog2-web" do
  action :install
  version node.graylog2[:web][:version]
  if platform?('debian')
    options "--force-yes"
  end
end

service "graylog2-web" do
  action :nothing
  supports :status => true, :restart => true
  if platform?('ubuntu')
    provider Chef::Provider::Service::Upstart
  end
end

default_backend_uri = "http://#{node['ipaddress']}:12900/"

template "/etc/graylog2/web/graylog2-web-interface.conf" do
  source "graylog2.web.conf.erb"
  owner 'root'
  mode 0644
  variables({
    :web_server_backends => node.graylog2[:web][:server_backends] || default_backend_uri
  })
  notifies :restart, 'service[graylog2-web]'
end

template "/etc/default/graylog2-web" do
  source "graylog2.web.default.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-web]'
end

template "/etc/graylog2/web/logback.xml" do
  source "graylog2.web.logback.xml.erb"
  owner 'root'
  mode 0644
  notifies :restart, 'service[graylog2-web]'
end