require 'bin/client/game/Console'
require 'bin/client/game/Field'


class ClientGame
  
  def initialize p1, p2, main
    
    @main = main
    @mouse_clicked = false
    
    @selected_stone
    
    ###########################################################
    # stone Fields (use  factor 0.375) relative to the map #
    ###########################################################
    # 1. = 165, 165 2. = 800, 165 3. = 1434, 165                                                     
    # 4. = 384, 384 5. = 800, 384 6. = 1216, 384
    # 7. = 608, 608 8. = 800, 608 9. = 992, 608
    # 10. = 165, 798 11. = 384, 798 12. = 607, 798 13. = 992, 798 14. = 1216, 798 15. = 1436, 798
    # 16. = 608, 990 17. = 800, 990 18. = 992, 990 
    # 19. = 384, 1214 20. = 800, 1214 21. = 1216, 1214 
    # 22. = 165, 1435 23. = 800, 1435 24. = 1434, 1435                     
    
    @fields = [Field.new(800, 1435), Field.new(800, 1214), Field.new(800, 990),Field.new(165, 1435),Field.new(384, 1214),Field.new(608, 990), Field.new(165, 798), Field.new(383, 798), Field.new(607, 798), Field.new(165, 165),
    Field.new(384, 384), Field.new(608, 608),Field.new(800, 165),Field.new(800, 384),Field.new(800, 608),Field.new(1434, 165),Field.new(1216, 384),Field.new(992, 608),Field.new(992, 798), Field.new(1216, 798), Field.new(1436, 798),
    Field.new(992, 990),Field.new(1216, 1214),Field.new(1434, 1435)]
    
    @player1 = p1; #client player
    @player2 = p2; #enemy player
    
    @your_turn = false
    
    @remove_a_stone = false
    
    @p1_remaining_playstones = 9
    @p2_remaining_playstones = 9
    
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #TODO rendering new imgs and removing scalings
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    @xpos_map = 300
    @ypos_map = 20
      
    #images
    @img_map = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/map.png")
    @img_background = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/background_game.png")
    @img_playstone_white = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/playstone_white.png")
    @img_playstone_black = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/playstone_black.png")
    
    @console = Console.new(300, 642, 600, 68)
    
    endTurn #
  end
  
  def draw
    #width:1200 * height:700 padding:20
    @img_background.draw(0,2,0)
    @console.draw
    @img_map.draw(@xpos_map, @ypos_map, 0, 0.375, 0.375)
    
    ### drawing remaining PLAYSTONES of PLAYER1
    for i in 1..@p1_remaining_playstones
      @img_playstone_white.draw(i * 26 , 20, 0, 0.2, 0.2)
    end
    
    ### drawing remaining PLAYSTONES of PLAYER2
    for i in 2..@p1_remaining_playstones + 1
      @img_playstone_black.draw(1200 - i * 26 , 20, 0, 0.2, 0.2)
    end
    
    for field in @fields
      field.draw(@main)
    end
    
  end
  
  def update
    
#    #mouse clicked on a field
#    if(@your_turn)
#      if(@clicked)
#        for i in 0..@fields.length
#          if(@fields[i].update)
#            clickField(i)
#          end
#        end
#      end
#    end
  end
  
  def genPossiblePositions
    if(@p1_remaining_playstones > 0)
      
      for i in 0..23
        if(!@fields[i].taken)
          @fields[i].setGhostStone
        end
      end
      
    end
  end
  
  
  def clickField i
    if(@fields[i].getColor == "white")
      if(@field[i].isGhost && @selected_stone =! nil)
        moveStone(i)
      end
    end
  end
  
  #sends a request to place a stone on the field 'i'
  def placeStone i
  #TODO
  end
  
  def moveStone i
  #TODO
  end
  
  def sendDatatoServer string
  #TODO
  end
  
  def endTurn
    @your_turn = !@your_turn
    if(@your_turn)
      @console.print("Your turn!",0xff_12ff00)
      genPossiblePositions()
    else
      #TODO send the server a msg which says that your turn is over
    end
  end
  
end