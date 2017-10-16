$LOAD_PATH << 'C:/Users/konop/Documents/mill/'
require 'bin/client/game/Console'
require 'bin/client/game/Field'
require 'bin/server/Server'


class ClientGame
  
  def initialize p1, p2, main, connection
    puts "clientgame started"
    @main = main
    @mouse_clicked = false
    
    @selected_stone = -1
    @connection = connection
    ###########################################################
    # stone Fields (use  factor 0.375) relative to the map    #
    ###########################################################
    # 1. = 165, 165 2. = 800, 165 3. = 1434, 165                                                     
    # 4. = 384, 384 5. = 800, 384 6. = 1216, 384
    # 7. = 608, 608 8. = 800, 608 9. = 992, 608
    # 10. = 165, 798 11. = 384, 798 12. = 607, 798 13. = 992, 798 14. = 1216, 798 15. = 1436, 798
    # 16. = 608, 990 17. = 800, 990 18. = 992, 990 
    # 19. = 384, 1214 20. = 800, 1214 21. = 1216, 1214 
    # 22. = 165, 1435 23. = 800, 1435 24. = 1434, 1435                     
    puts "creating fields"
    @fields = [Field.new(800, 1435), Field.new(800, 1214), Field.new(800, 990),Field.new(165, 1435),Field.new(384, 1214),Field.new(608, 990), Field.new(165, 798), Field.new(383, 798), Field.new(607, 798), Field.new(165, 165),
    Field.new(384, 384), Field.new(608, 608),Field.new(800, 165),Field.new(800, 384),Field.new(800, 608),Field.new(1434, 165),Field.new(1216, 384),Field.new(992, 608),Field.new(992, 798), Field.new(1216, 798), Field.new(1436, 798),
    Field.new(992, 990),Field.new(1216, 1214),Field.new(1434, 1435)]

    @button_action = Button.new(950, 645, ["C:/Users/konop/Documents/mill/assets/game/button_unpressed.png", "C:/Users/konop/Documents/mill/assets/game/button_hover.png"], "Draw", main)
    
    @player1 = p1; #client player
    @player2 = p2; #enemy player
    
    @your_turn = false
    
    @remove_a_stone = false
    
    @p1_remaining_playstones = 9
    @p2_remaining_playstones = 9
    @p1_taken_stones = 0
    @p2_taken_stones = 0
    
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #TODO rendering new imgs and removing scalings
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    @xpos_map = 300
    @ypos_map = 20
      
    #images
    puts "drawing map"
    @img_map = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/map.png")
    puts @img_map
    @img_background = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/background_game.png")
    puts @img_background

    @img_playstone_white = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/playstone_white.png")
    @img_playstone_black = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/playstone_black.png")

    puts "drawing console"
    @console = ConsoleGame.new(300, 642, 600, 68)

    puts "init finished"
  end
  
  # Description:
  # draws all elements in the game
  # Parameter(s):
  # -
  # Return:
  # -
  def draw
    #width:1200 * height:700 padding:20
    @img_background.draw(0,2,0)
    @console.draw
    @img_map.draw(@xpos_map, @ypos_map, 0, 0.375, 0.375)

    @button_action.draw

    ### drawing remaining PLAYSTONES of PLAYER1
    for i in 1..@p1_remaining_playstones
      @img_playstone_white.draw(i * 26 , 20, 0, 0.2, 0.2)
    end

    ### drawing remaining PLAYSTONES of PLAYER2
    for i in 2..@p2_remaining_playstones + 1
      @img_playstone_black.draw(1200 - i * 26 , 20, 0, 0.2, 0.2)
    end

    ### drawing playstones
    for field in @fields
      field.draw(@main)
    end

    ### drawing taken playstones for p1
    for i in 1..@p1_taken_stones
      @img_playstone_black.draw( 250, i * 26 + 50, 0, 0.375, 0.375)
    end

    ### drawing taken playstones for p2
    for i in 1..@p2_taken_stones
      @img_playstone_white.draw( 910, i * 26 + 50, 0, 0.375, 0.375)
    end

  end
  
  # Description:
  # updates all elements in the game
  # Parameter(s):
  # -
  # Return:
  # -
  def update 
    #mouse clicked on a field
    if(!@game_over)
      puts("1")
      if(@your_turn)
        puts("2")
        if(@mouse_clicked)
          puts("3")
          for i in 0.. @fields.length - 1
            if(@fields[i].update())
              clickField(i)
            end
          end
          @mouse_clicked = false
        end
      else
        puts("4")
        msg = @connection.gets.chop.force_encoding(Encoding::UTF_8)
        msg_array = msg.split(';')
        recieveMessage(msg_array)
      end

      if(@button_action.update)
        puts("5")
        if(!@draw)
          puts("6")
          @connection.puts("draw")
          @console.print("You've send a request for a draw.",0xff_ff1200)
        else
          puts("7")
          @connection.puts("draw")
        end
      end

    else
      puts("8")
      if(@button_action.update)
        puts("9")
        return true
      end
    end
    puts("1")
    return false
  end
  
  def recieveMessage msg
    action = msg[0]
    case action
      when "move"
        then @selected_stone = msg[1]
             moveStone(msg[2], "black")
             endTurn
      when "set"
        then @fields[msg[1]].setStone("black")
      when "remove"
        then @fields[msg[1]].clear
             @p2_taken_stones += 1
      when "enemy_won"
        then #TODO
      when "enemy_stucked"
        then
        @game_over = true
        @console.print("Your enemy is stucked, you've won the game!",0xff_ff1200)
        @button_action.setLable("Exit")
      when "won"
        then
        @game_over = true
        @console.print("You've won the game!",0xff_ff1200)
        @button_action.setLable("Exit")
      when "stucked"
        then
        @game_over = true
        @console.print("You're stucked, your enemy has won the game!",0xff_ff0000)
        @button_action.setLable("Exit")
      when "draw"
        then
        @game_over = true
        @console.print("The game is a draw!",0xff_ff0000)
        @button_action.setLable("Exit")
     when "request_draw"
       @draw = true
       @console.print("You're enemy offerce you a draw, accept by clicking the \"draw\" button.",0xff_ff0000)
    end
  end
  
  # Description:
  # set all 'Fields' in the list '@fields', which aren't occupied to a ghost stone
  # this is used to show the possible positions, to the player, where he can set a stone
  # (only if the player has remaining stones)
  # Parameter(s):
  # -
  # Return:
  # - 
  def genPossiblePositions
    if(@p1_remaining_playstones > 0)
      for i in 0..23
        if(!@fields[i].isTaken)
          @fields[i].setGhostStone
        end
      end
    end
  end
  
  # Description:
  # selects a field 'i', and generates possible positions, for the stone, where it could move to
  # Parameter(s):
  # i : the index of the stone in the list '@fields'
  # Return:
  # -
  def selectField i
    removeGhostStones
    @fields[i].setSelected(true)
    ghost_fields = getConnected(i)
    @selected_stone = i
    
    if(@p2_taken_stones < 6)
      for x in ghost_fields
        if(!@fields[x].isTaken)
          @fields[x].setGhostStone
        end
      end
    else
      for x in 0.. @fields.length - 1
        if(!@fields[x].isTaken)
          @fields[x].setGhostStone
        end
      end
    end
    
  end
  
  # Description:
  # removes all 'GhostStones'
  # Parameter(s):
  # -
  # Return:
  # -
  def removeGhostStones
    for x in @fields
      if(x.isGhost)
        x.clear
      end
    end  
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
  
  def clickField i
    if(@fields[i].getColor == "white")
      if(@fields[i].isGhost)
        if(@selected_stone >= 0)  
          #if(sendDataToServer("moved;" + @selected_stone + ";" + i))
            moveStone(i,"white")
            endTurn
          #end
        else
          #if(sendDataToServer("place;" + i))
            @fields[i].setStone("white")
            @console.print("You placed your stone.",0xff_ffffff)
            @p1_remaining_playstones -= 1
            endTurn
          #end
        end
      else
        selectField(i)
      end
    end
  end
  
  def moveStone i, color
    @fields[i].setStone(color)
    @fields[@selected_stone].clear
  end
  
  def sendDataToServer string

    @connection.puts(string)
    msg = @connection.gets.chop.force_encoding(Encoding::UTF_8)
    
    case msg
    
      when "invalid"
        then
        @console.print("Invalid turn",0xff_ff0000)
        return true
      when "ok"
        then
        return true
      when "mill"
        then
        @remove_a_stone = true 
        #TODO mill
        @console.print("You have a mill!",0xff_12ff00)
        return true
      when "won"
        #TODO
        then
      else
        @console.print("[ERROR] failed interpreting server data",0xff_ff0000)
        return false
    end
    
  end
  
  def endTurn
    @your_turn = !@your_turn
    removeGhostStones
    if(@your_turn)
      @console.print("It's your turn!",0xff_12ff00)
      genPossiblePositions()
    else
      @console.print("Its your enemy's turn!",0xff_ffcc00)
    end
  end
  
  def mouseClicked
    @mouse_clicked = true
    if(@button_action)
    end
  end
  
end