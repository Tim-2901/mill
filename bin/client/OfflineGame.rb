class OfflineGame
  
  def initialize main
    puts "clientgame started"
       @main = main
       @mouse_clicked = false
       
       @selected_stone = -1
       ###########################################################
       # stone Fields (use  factor 0.375) relative to the map    #
       ###########################################################      
       puts "creating fields"
    @fields = [Field.new(800, 1435), Field.new(800, 1214), Field.new(800, 990),#0 - 2
                   Field.new(165, 1435), Field.new(384, 1214),Field.new(608, 990), #3 - 5
                   Field.new(165, 798), Field.new(383, 798), Field.new(607, 798),  #6 - 8
                   Field.new(165, 165), Field.new(384, 384), Field.new(608, 608),  #9 - 11
                   Field.new(800, 165),Field.new(800, 384), Field.new(800, 608),   #12 - 14
                   Field.new(1434, 165), Field.new(1216, 384),Field.new(992, 608), #15 - 17
                   Field.new(1436, 798), Field.new(1216, 798), Field.new(992, 798),#18 - 20 
                   Field.new(1434, 1435), Field.new(1216, 1214), Field.new(992, 990)] #21 - 23
   
       @button_action = Button.new(950, 645, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Exit", main)
       
       @player1 = "white"; #client player
       @player2 = "black"; #enemy player
       
       @turn = "black"
       @game_over = false
       
       @remove_a_stone = false
       @mill = false
       
       @p1_remaining_playstones = 9
       @p2_remaining_playstones = 9
       @p1_taken_stones = 0
       @p2_taken_stones = 0
       
       @xpos_map = 300
       @ypos_map = 20
         
       #images
       @img_map = Gosu::Image.new("assets/game/map.png")
       puts @img_map
       @img_background = Gosu::Image.new("assets/game/background_game.png")
   
       @img_playstone_white = Gosu::Image.new("assets/game/playstone_white.png")
       @img_playstone_black = Gosu::Image.new("assets/game/playstone_black.png")
   
       @console = ConsoleGame.new(300, 642, 600, 68)
       puts "init finished"
       changeTurn
  end
  
  def draw
    
    ### checks if someone wins
    if(@p1_taken_stones == 7)
       @game_over = true
       @console.print("Player \"White\" wins the game!", 0xff_12ff00)
    else if(@p2_taken_stones == 7)
      @game_over = true
      @console.print("Player \"Black\" wins the game!", 0xff_12ff00)
    end end
    
    if(update == true) then return true end
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
  
  def update
    if(!@game_over)
      if(@clicked)
        for i in 0.. @fields.length - 1
          if(@fields[i].update())
            clickField(i)
          end
        end
        @clicked = false
      end
    end
    if(@button_action.update)
      return true
    end
    
    if(@isStuck != nil)
      @console.print("#{@isStuck} is stuck, he loses the game",0xff_ff0000)
      return true
    end

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
    for i in 0..@fields.length - 1
      if (@fields[i].getNormalColor == @turn)then occupied << i end
    end
    positions = []
    positions << occupied.each{|x| getConnected(x)}
    positions.uniq
    if(positions == [])then return false end
    positions.each{|x| 
      if(@fields[x].isTaken) then 
        return false 
    end}
    return true
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
    if(@p1_remaining_playstones > 0 or @p2_remaining_playstones > 0)
      for i in 0..23
        if(!@fields[i].isTaken)
          @fields[i].setGhostStone(@turn)
        end
      end
    end
  end
  
  def getRemainingPlaystones color
    if(color == "white")
      return @p1_remaining_playstones
    else
      return @p2_remaining_playstones
    end
  end
  
  def checkIfMill(endpos, color)
    
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
      if(@fields[array[i][0] % 24].getNormalColor == color && @fields[array[i][1] % 24].getNormalColor == color)
        return true
      end
    end
    return false
  end
  
  def selectField i
    removeGhostStones
    ghost_fields = getConnected(i)
    @selected_stone = i
    
    taken_stones = 0
    
    if(@turn == "white")
      taken_stones = @p2_taken_stones
    else
      taken_stones = @p1_taken_stones
    end
    
    if(taken_stones < 6)
      for x in ghost_fields
        if(!@fields[x].isTaken)
          @fields[x].setGhostStone(@turn)
        end
      end
    else
      for x in 0.. @fields.length - 1
        if(!@fields[x].isTaken)
          @fields[x].setGhostStone(@turn)
        end
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
          array << (startpos + 1) % 24
        when 1
          array << (startpos + 1) % 24
          array << (startpos - 1) % 24
        when 2
          array << (startpos - 1) % 24
      end
      return array
  end
  
  def moveStone i, color
    @fields[i].setStone(color)
    @fields[@selected_stone].clear
  end
  
  def clickField i  
    puts @mill
    if(@mill)
      if(@fields[i].getColor != @turn && @fields[i].getColor != nil)
    color = if(@turn == "white")then "black" else "white" end
        if(!checkIfMill(i, color))
          @fields[i].clear
          if(@turn == "white")
            @p1_taken_stones += 1
          else
            @p2_taken_stones += 1
          end
          @mill = false
          changeTurn
        else
          @console.print("You can't remove this stone, it is in  a mill!", 0xff_ff0000)
        end
      end
      return
    end
    
    if(@fields[i].getColor == @turn)
      if(@fields[i].isGhost)
        if(getRemainingPlaystones(@turn) <= 0)
          if(@selected_stone > -1)
            moveStone(i, @turn)
          end
        else
          @fields[i].setStone(@turn)
          if(@turn == "white") 
            @p1_remaining_playstones -= 1 
          else
            @p2_remaining_playstones -= 1
          end
        end 
        if(checkIfMill(i, @turn))
          @console.print("You have a mill, remove a stone!", 0xff_12ff00)
          removeGhostStones
          @mill = true
        else
          changeTurn
        end
      else
        selectField(i)
      end
    else
      
    end
    
    @clicked = false
  end
  
  def removeGhostStones
    for x in @fields
      if(x.isGhost)
        x.clear
      end
    end  
  end
  
  def changeTurn
    if(isStuck)
      @isStuck = @turn
    end 
    @selected_stone = -1
    removeGhostStones
    if(@turn == "white")
      @turn = "black"
      if(@p2_remaining_playstones > 0)
        genPossiblePositions
      end
    else
      @turn = "white"
      if(@p1_remaining_playstones > 0)
        genPossiblePositions
      end
    end
    @console.print("It's #{@turn}s turn",0xff_ffcc00)
  end
  
  def click
    if(@button_action.isHover)
      @button_action.setClicked(true)
    end
    @clicked = true
  end
  
end