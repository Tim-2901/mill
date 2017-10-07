require "sqlite3"
require "socket"
require "./bin/server/GameHandler.rb"

@db = SQLite3::Database.new("player.sqlite")
@gamehandler = GameHandler.new()

server = TCPServer.new("localhost",4713)

# set the encoding of the connection to UTF-8
  server.set_encoding(Encoding::UTF_8)
  
def recieveMessage(msg, connection)
  
  action = msg[0]
  
  print "Action: " + action +"\n"
  case action
    when "signIn"
      then signIn(msg[1],msg[2])
    
    when "signUp"
      then signUp(msg[1],msg[2])
      
    when "game"
      then game(msg[1],msg[2])
  end
end

def signIn(username,pw)
  print "Username: "+ username + "\n" + "Password: " + pw + "\n"
  
  query = "SELECT pw FROM player WHERE name = :username"
  
  db_pw = @db.execute(query,
              :username => username)
  if (db_pw = pw)
    puts "Login successful"
  end            
end

def signUp(username,pw)
  print "Username: "+ username + "\n" + "Password: " + pw

  statement ="INSERT INTO player 
          VALUES (:username, :pw, 0, 0)"

  @db.execute(statement,
             :username   => username,
             :pw => pw)
 
  puts "Sign Up successful"
  
end

  loop do
    print("running")
    Thread.start(server.accept) do |connection|
    print("[Server] new client connection: " + connection)
  
    connection.set_encoding(Encoding::UTF_8) 
  
    msg = connection.gets.chop.force_encoding(Encoding::UTF_8)
    msg_array = msg.split(';')
    recieveMessage(msg_array, connection)
  end
  
end