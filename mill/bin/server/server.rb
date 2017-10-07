require "sqlite3"
require "socket"

@db = SQLite3::Database.new("player.sqlite")

server = TCPServer.new("localhost",4713)

# set the encoding of the connection to UTF-8
  server.set_encoding(Encoding::UTF_8)
  
def recieveMessage(msg,connection)
  
  action = msg[0]
  
  print "Action: " + action +"\n"
  case action
    when "signIn"
      then signIn(msg[1],msg[2], connection)
    
    when "signUp"
      then signUp(msg[1],msg[2], connection)
      
    when "game"
      then game(msg[1],msg[2], connection)
    else
      connection.puts(action.to_s + " is no valid Action!")
  end
end

def signIn(username,pw,connection)
  print "Username: "+ username + "\n" + "Password: " + pw + "\n"
  
  query = "SELECT pw FROM player WHERE name = :username"

  db_pw = @db.execute(query,
              :username => username)
  if (db_pw == pw)
    msg = "Login successful"
  else
    msg = "Wrong password"
  end
  connection.puts(msg)
  puts(msg)


end

def signUp(username,pw,connection)
  begin
  print "Username: "+ username + "\n" + "Password: " + pw + "\n"

  statement ="INSERT INTO player 
          VALUES (:username, :pw, 0, 0)"

  @db.execute(statement,
             :username   => username,
             :pw => pw)
 

  msg = "Sign Up successful"
  rescue Exception => excep

      msg = case excep.to_s
        when "UNIQUE constraint failed: player.name"
          "The username is already taken."
        else
          "An unkown error has occured."
      end

  end
  connection.puts(msg)
  puts(msg)
end  

def game
  
end
  
  loop do
  
    connection = server.accept
    print("new connection accepted\n")
  
    connection.set_encoding(Encoding::UTF_8) 
  
    msg = connection.gets.chop.force_encoding(Encoding::UTF_8)
    msg_array = msg.split(';')
    recieveMessage(msg_array,connection)
    
  end