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

  def initialize(ip, port, console, main)
    @main = main
    puts console
    @console = console
    @console.clear

    if(ip == "localhost")
      ip = Socket.ip_address_list[3].ip_address
    end
    @console.textlist("Server is running under #{ip}:#{port}")
    @field = [nil] * 24
    @db = SQLite3::Database.new("player.sqlite")
    @turn = nil
    @server = TCPServer.new(ip,port)
    @queue = []
    # set the encoding of the connection to UTF-8
    @server.set_encoding(Encoding::UTF_8)
    mainloop
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
    rtrn = false
    action = msg[0]
    puts msg
    @console.textlist("Action: " + action)
    # possible Actions are: signIn; signUp; moved; quequeUp; place;
    case action
      when "signIn"
        then rtrn = signIn(msg[1],msg[2])

      when "signUp"
        then rtrn = signUp(msg[1],msg[2])

      when "moved"
        then rtrn = moved(msg[1],msg[2], connection)

      when "queueUp"
        then rtrn = queue(msg[1], connection)

      when "place"
        then rtrn = place(msg[1], connection)

      when "leaderboard"
        then rtrn = leaderboard(msg[1])


      else
        connection.puts(action.to_s + " is no valid Action!")
    end
    if(msg != false)
      connection.puts(rtrn)
      puts rtrn
      @console.textlist(rtrn)
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
  def signIn(username,pw)
    begin
      print "Username: "+ username + "\n" + "Password: " + pw + "\n"

      query = "SELECT pw FROM player WHERE name = :username"

      db_pw = @db.execute(query,
                  :username => username)
      if (db_pw[0][0] == pw)
        msg = "Login successful"
      else
        msg = "Wrong password"
      end
    rescue Exception => excep
      msg = handleException(excep, "player")

    end

    return msg


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
  def signUp(username,pw)
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
      msg = handleException(excep, "player")

    return msg
    end

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

    no = noOfStones()

    # checks if the move is valid
    allowed = isAllowed(startpos, endpos, no)
    # writes it to the array
    if(allowed == "invalid") then return "invalid" end
    confirmMove(startpos, endpos, connection)
    mill = checkIfMill(endpos)
    changeTurn()
    if(mill == "mill")then handleMill(connection) end
    won = checkIfWon()
    if(won !="notwon")then return won end
    return allowed

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
  def isAllowed(startpos, endpos, no)


    if(isOccupied!(endpos))
      return "invalid"
    end
    if(no >= 3)
      if(!isConnected(startpos, endpos))
      return "invalid"
      end
    end

    return "ok"

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
        return "mill"
      end
    end
    return "nomill"
  end

  # Description:
  #
  #
  # Parameter(s):
  #
  #
  # Return:
  #
  def checkIfWon()
    if(noOfStones < 3)
      return "won"
    end

    if(isStuck)
      return "stuck"
    end
    return "notwon"
  end

  def isStuck
    occupied = []
    for i in 0..@field.length - 1
      if (@field[i] == @turn)then occupied << @turn end
    end
    positions = []
    positions << occupied.each{|x| getConnected(x)}
    positions.uniq
    positions.each{|x| if(isOccupied!(x))then return true end}
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
  def noOfStones()
    no = 0
    @field.each{
        |i|
        if i == @turn
          no += 1
        end

    }
  return no
  end

  def handleMill(connection)
    connection.puts("mill")
    pos = connection.gets.chop.force_encoding(Encoding::UTF_8)
    if(@field[pos] = @turn)
      return true
    end
    connection.puts("invalid")
    handleMill(connection)
  end

  # Description:
  #
  #
  # Parameter(s):
  #
  #
  # Return:
  #
  def queue(player, connection)
    @queue << [player, connection]
    if(@queue.length > 1)
      @queue.each_with_index{ |x| x[1].puts("start")}
    end
    return false

  end

  def place(pos, connection)
    if(@field[pos] != nil)
      return "invalid"
    end

    if(checkIfMill(pos))
      handle(connection)
    end
  return  "ok"
  end

  def handleException(excep, arg)
    msg = case excep
            when "no such table:"
              "Their is no table #{arg} in the Database"
            else
              "Error: " + excep.inspect.to_s + " has occured"
          end
    return msg
  end

  def consoleOutput(msg)

    @main.consoleUpdate(msg)
  end

  def leaderboard(player)
    query = "SELECT name,wins,loses FROM player WHERE name != :name"

    db_kda = @db.execute(query,
                         :name => "Ssdadwadwa")
    puts db_kda.to_s
    for i in 0..db_kda.length - 1
       db_kda[i] << (db_kda[i][1] /db_kda[i][2])
    end
    puts db_kda.to_s
    return db_kda.to_s
  end

  def mainloop
    loop do

      connection = @server.accept
      @console.textlist("new connection accepted")

      connection.set_encoding(Encoding::UTF_8)

      msg = connection.gets.chop.force_encoding(Encoding::UTF_8)
      msg_array = msg.split(';')
      recieveMessage(msg_array,connection)

    end
  end
end
