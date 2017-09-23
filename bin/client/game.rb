
require "socket"

# connect to server
 connection = TCPSocket.new("localhost", 4713)

 # set the encoding of the connection to UTF-8
 connection.set_encoding(Encoding::UTF_8) 
 
 # send message
 connection.puts("signIn;username;pw")