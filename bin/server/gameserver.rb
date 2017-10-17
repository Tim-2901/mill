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
class GameServer

  def initialize(connections,console)
    puts"gameserver started"
    @console = console
    @players = [connections[0][0],connections[1][0]]
    puts @players
    @field = [nil] * 24
    @turn = nil
    @queue = connections
    @connections = [connections[0][1],connections[1][1]]
    puts @connections
    puts "init"
    startGame()
  end


  def recieveMessage(player)
    connection = @connections[player]
    msg_array = connection.gets.chop.force_encoding(Encoding::UTF_8)
    msg = msg_array.split(';')
    rtrn = false
    action = msg[0]
    @console.textlist("Action: " + action)
    @console.textlist(msg.to_s)
    # possible Actions are: signIn; signUp; moved; queueUp; place;
    case action
      when "signIn"
      then rtrn = signIn(msg[1],msg[2])

      when "signUp"
      then rtrn = signUp(msg[1],msg[2])

      when "moved"
        then rtrn = moved(msg[1].to_i,msg[2].to_i, connection)

      when "queueUp"
      then rtrn = queue(msg[1], connection)

      when "place"
        then rtrn = place(msg[1].to_i, connection)

      when "leaderboard"
      then rtrn = leaderboard(msg[1])


      else
        connection.puts(action.to_s + " is no valid Action!")
    end
    if(rtrn != false)
      connection.puts(rtrn)
      puts rtrn
      @console.textlist(rtrn)
    end
    if(rtrn != "won" && rtrn != "enemy_stucked")
      if(player == 0)then player = 1 else player = 0 end
      @connections[player].puts(
      "enemysmove;#{@move[0].to_s};#{@move[1].to_s};#{@move[2].to_s}"
      )
      recieveMessage(player)
    else
      connection.puts(rtrn)
      if rtrn == "won"
      @connections[player].puts("enemy_won")
      else
        @connections[player].puts("stucked")
      end


    end

  end

  def startGame
    #puts ("first player" + @connetions[0].to_s + " ; " + @players[0].to_s)
    #puts ("second player" + @connetions[1].to_s + " ; " + @players[1].to_s)
    #@connections[0].puts[@players[1]]
    #@connections[1].puts[@players[0]]
    x = rand(2)
    puts x
    y = if(x == 1)then 0 else 1 end
    @turn = @players[x]
    @connections[x].puts("yourTurn")
    @connections[y].puts("enemyTurn")
    puts "startGame finished"
    recieveMessage(x)
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
    @move = [startpos,endpos,nil]
    no = noOfStones()

    # checks if the move is valid
    allowed = isAllowed(startpos, endpos, no)
    # writes it to the array
    if(allowed == "invalid") then changeTurn(); return "invalid" end
    confirmMove(startpos, endpos)
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
  def confirmMove(startpos, endpos)
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
      if(@field[array[i][0] % 24] == @turn && @field[array[i][1] % 24] == @turn)
        return "mill"
      end
    end
    return "nomill"
  end

  # Description:
  # checks if the current playing player has won
  #
  # Parameter(s):
  #
  #
  # Return:
  # won or stuck if the player has won else notwon
  def checkIfWon()
    if(noOfStones < 3)
      return "won"
    end

    if(isStuck)
      return "enemy_stuck"
    end
    return "notwon"
  end

  # Description:
  # checks if the enemy player is stuck after the opposite players turn
  #
  # Parameter(s):
  #
  #
  # Return:
  # true if enemy player is stuck else false
  def isStuck
    occupied = []
    for i in 0..@field.length - 1
      if (@field[i] == @turn)then occupied << i end
    end
    positions = []
    positions << occupied.each{|x| getConnected(x)}
    positions.uniq
    positions.each{|x| if(isOccupied!(x))then return false end}
    return true

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
    if(@turn == @players[0])
      @turn = @players[1]
    else
      @turn = @players[0]
    end
  end



  # Description:
  # counts the stones of one color
  #
  # Parameter(s):
  #
  #
  # Return:
  # int: no of stones
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

  # Description:
  # sends the player that a mill has occured and validates the stone he is removing
  #
  # Parameter(s):
  # connection - TCPSocket: active connection
  #
  # Return:
  # nothing
  def handleMill(connection)
    connection.puts("mill")
    pos = connection.gets.chop.force_encoding(Encoding::UTF_8)
    if(@field[pos] = @turn)
      @field[pos] = nil
      @move[2] = pos
      return true
    end
    connection.puts("invalid")
    handleMill(connection)
  end

  # Description:
  # is called when a player places a stone
  #
  # Parameter(s):
  # pos - int: position where the stone is placed
  # connection - TCPSocket: the active connection
  #
  # Return:
  # string: ok if its a valid pos else invalid
  def place(pos, connection)
    if(@field[pos] != nil)
      return "invalid"
    end
    @move = [nil, pos, nil]

    if(checkIfMill(pos) == "mill")
      handle(connection)
    end

    return  "ok"
  end

  # Description:
  # handles a execption in server.rb
  # if an error occurs in server.rb it will returns an error msg
  # if the error is unknown it will returns the exception itself
  # Parameter(s):
  # excep - Exception: The execption whitch has been catched
  # arg - anything: A variable which has to be in the error msg
  #
  # Return:
  # msg - string: the error msg
  def handleException(excep, arg)
    msg = case excep
            when "no such table:"
              "Their is no table #{arg} in the Database"
            else
              "Error: " + excep.inspect.to_s + " has occured"
          end
    return msg
  end

end