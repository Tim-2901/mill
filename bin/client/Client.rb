
require "socket"

# connect to server
 @connection = TCPSocket.new("localhost", 4713)

 # set the encoding of the connection to UTF-8
 @connection.set_encoding(Encoding::UTF_8) 
 
 # send message
 @connection.puts("signIn;username;pw")

def recieveMessage msg
  action = msg[0]
  
  print "Action: " + action +"\n"
  case action
    when "signIn"
      then signIn(msg[1],msg[2],msg[3]) # [1] = Username; [2] = wins; [3] = loses;
    
    when "Queue"
      then signUp(msg[1],msg[2])
      
    when "inGame"
      then game(msg[1],msg[2])
      
    when "foundGame"
      then foundGame()
  end 
end

def sendLoginData username, pw 
  @connection.puts("signIn;" + username +";" +pw)
  puts("signIn;" + username +";" +pw)
end

def signIn username, wins, loses
  puts username + ";" + wins + ";" + loses
end


sendLoginData('tom2208', '1234')
while (line = @connection.gets.chop) != ""
    msg = @connection.gets.chop.force_encoding(Encoding::UTF_8)
    msg_array = msg.split(';')
    recieveMessage(msg_array)
end
 


