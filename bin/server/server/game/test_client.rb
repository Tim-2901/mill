s = TCPSocket.new 'localhost', 2000

while line = s.gets # Read lines from socket
  puts line # and print them
  s.puts "Hello Server"
end

s.close  