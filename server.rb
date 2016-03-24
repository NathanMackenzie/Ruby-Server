require 'socket'
require 'json'

server = TCPServer.open(2000)
loop do
  client = server.accept
  
  request_message = client.read_nonblock(256)
  header, body = request_message.split("\r\n\r\n", 2)
  request = header.split[0]
  path = header.split[1][1..-1]
  
  if File.exist?(path)
    file = File.read(path)
    client.print("HTTP/1.0 200 OK\r\nDate: #{Time.new.ctime}\r\ntext/html\r\nContent-length: #{File.size(path)}\r\n\r\n")
    if request == 'GET'
      client.puts(File.read(path))
    elsif request == 'POST'
      params = JSON.parse(body)
      registration = "<li>Name: #{params["viking"]["name"]}</li><li>Email: #{params["viking"]["email"]}</li>"
      client.print("HTTP/1.0 200 OK\r\nDate: #{Time.now.ctime}\r\ntext/html\r\nContent-Length: #{File.size(path)}\r\n\r\n")
      client.puts(file.gsub("<%= yield%>", registration))
    end
  else
     client.print("HTTP/1.0 400 Not Found you fuck wit")
  end
  
  client.close
end