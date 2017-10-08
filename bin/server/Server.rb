require "sqlite3"
require "socket"
# Description:
# creates a server for 2 player
#
# Parameter(s):
#
#
# Return:
#
class Server

  def initialize()
    @field = [nil] * 24
    @db = SQLite3::Database.new("player.sqlite")
    @turn = nil
    @server = TCPServer.new("192.168.178.61",4713)
    puts @server.addr()
    puts @server
    # set the encoding of the connection to UTF-8
    @server.set_encoding(Encoding::UTF_8)
    mainloop()
  end


  # Description:
  # checks which kind of message is recieved an calls the corresponding method
  #
  # Parameter(s):
  # msg - Array of Strings: An array out of the messages and the action
  # connection - TCPSocket: The active conection
  # Return:
  # nothing
  def recieveMessage(msg,connection)

    action = msg[0]
    puts msg
    print "Action: " + action +"\n"
    # possible Actions are: signIn; signUp; moved; quequeUp;
    case action
      when "signIn"
        then signIn(msg[1],msg[2], connection)

      when "signUp"
        then signUp(msg[1],msg[2], connection)

      when "moved"
        then moved(msg[1],msg[2], connection)

      when "queueUp"
        then queue(msg[1], connection)


      else
        connection.puts(action.to_s + " is no valid Action!")
    end
  end

  # Description:
  # signs the user into his account if the password is correct
  #
  # Parameter(s):
  # username - string: Name of the User
  # pw - string: The users password
  # connection - TCPSocket: The active connection
  #
  # Return:
  #
  def signIn(username,pw,connection)
    print "Username: "+ username + "\n" + "Password: " + pw + "\n"

    query = "SELECT pw FROM player WHERE name = :username"

    db_pw = @db.execute(query,
                :username => username)
    if (db_pw[0][0] == pw)
      msg = "Login successful"
    else
      msg = "Wrong password"
    end
    connection.puts(msg)
    puts(msg)


  end

  # Description:
  # signs the user up if he has no account
  #
  # Parameter(s):
  # username - string: Name of the User
  # pw - string: The users password
  # connection - TCPSocket: The active connection
  #
  # Return:
  #
  def signUp(username,pw,connection)
    begin
    print "Username: "+ username + "\n" + "Password: " + pw + "\n"

    statement ="INSERT INTO player
            VALUES (:username, :pw, 0, 0)"

    @db.execute(statement,
               :username   => username,
               :pw => pw)


    msg = "Sign Up successful"
      # if the username is already taken ruby would throw a exeption and terminate the game.
      # to avoid this the execption is catched and a hint is shown in the login screen.
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

  # Description:
  # synchronieses the move of a client with the server
  #
  # Parameter(s):
  # startpos - int: position from where he moved away
  # endpos - int: new position of the stone
  # connection - TCPSocket: active connection
  #
  # Return:
  #
  def moved(startpos, endpos, connection)

    isAllowed(startpos, endpos)
    confirmMove(startpos, endpos, connection)
    checkIfMill(endpos)
    checkIfStuck()
    changeTurn()
  end

  # Description:
  # checks if the given move is allowed
  #
  # Parameter(s):
  # startpos - int: startpos of the stone
  # endpos - int: endpos of the stone
  #
  # Return:
  # true if it is allowed
  #
  def isAllowed(startpos, endpos)
    if(isOccupied!(endpos))
      return false
    end
    if(!isConnected(startpos, endpos))
      return false
    end
    return true

  end


  # Description:
  # checks if the given pos is occupied
  #
  # Parameter(s):
  # pos - int: position which has to be checked
  #
  # Return:
  # true if it isnt occupied
  #
  def isOccupied!(pos)
    if (@field[pos]!= nil)
      return false
    end

    return true
  end

  # Description:
  # checks if 2 positions are connected to each other
  #
  # Parameter(s):
  # startpos - int: first position
  # endpos - int: second position
  #
  # Return:
  # true if they are connected
  #
  def isConnected(startpos, endpos)
    if(getConnected(startpos).each{|x| x == endpos})
      return true
    end
    return false
  end


  # Description:
  # returns an array with all connected positions
  #
  # Parameter(s):
  # startpos - int: position to be checked
  #
  # Return:
  # array of integers with the connected positions
  #
  def getConnected(startpos)
      array = [(startpos - 3) % 24,(startpos + 3) % 24]
      case startpos % 6
        when 0
          array << startpos + 1
        when 1
          array << startpos + 1
          array << startpos - 1
        when 2
          array << startpos - 1

      end
      return array
  end

  # Description:
  # confirms that the move is allowed and writes it to the server
  #
  # Parameter(s):
  # startpos - int: position which is now unoccupied
  # endpos - int: position which is occupied now
  # connection - TCPSocket: active connection
  #
  # Return:
  # nothing
  def confirmMove(startpos, endpos, connection)
    @field[startpos] = nil
    @field[endpos] = @turn
  end


  # Description:
  # checks if a mill has occured
  #
  # Parameter(s):
  # endpos - int: position where the mill could have occured
  #
  # Return:
  # true if a mill is existent
  def checkIfMill(endpos)

    array = [[endpos + 3, endpos - 3]]
    case endpos % 6
      when 0
        array <<[endpos + 1, endpos + 2]
      when 1
        array <<[endpos + 1, endpos - 1]
      when 2
        array <<[endpos - 1, endpos - 2]
      else
        array = [[endpos + 3, endpos + 6],[endpos - 3, endpos - 6]]
    end
    for i in 0..array.length - 1
      if(field[array[i][0] % 24] == @turn && field[array[i][1] % 24] == @turn)
        return true
      end
    end
    return false
  end

  # Description:
  # changes the turn
  #
  # Parameter(s):
  # nothing
  #
  # Return:
  # nothing
  def changeTurn()
    if(@turn == black)
      @turn = white
    else
      @turn = black
    end
  end

  # Description:
  #
  #
  # Parameter(s):
  #
  #
  # Return:
  #
  def queue(player,connection)

  end

  def mainloop()
    loop do

      connection = @server.accept
      print("new connection accepted\n")

      connection.set_encoding(Encoding::UTF_8)

      msg = connection.gets.chop.force_encoding(Encoding::UTF_8)
      msg_array = msg.split(';')
      recieveMessage(msg_array,connection)

    end
  end
end

Server.new