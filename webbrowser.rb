require 'socket'
require 'json'
 
hostname = 'localhost'     
port = 2000                                            


puts "Would you like to POST or GET?"
r = gets.chomp

if r == 'POST'
  path = "/thanks.html"
  
  puts "Register for viking raid."
  puts "Enert your name: "
  name = gets.chomp
  puts "Enter your email: "
  email = gets.chomp
  
  request_hash = {:viking=>{:name=>name, :email=>email}}.to_json
  request = "POST #{path} HTTP/1.0\r\nFrom: #{email}\r\nUser-Agent: SimpleBrowser\r\nContent-Type: application/json\r\nContent-Length: #{request_hash.to_s.length}\r\n\r\n#{request_hash}"
  
elsif r == 'GET'
  request = "GET #{path} HTTP/1.0\r\n\r\n"
  path = "/index.html"
end

socket = TCPSocket.open(hostname,port) 
socket.print(request)               
response = socket.read            

headers,body = response.split("\r\n\r\n", 2) 
print body