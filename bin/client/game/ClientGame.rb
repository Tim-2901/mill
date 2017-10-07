require 'bin/client/game/Console'

class ClientGame
  
  def initialize p1, p2
    @player1 = p1; #client player
    @player2 = p2; #enemy player
    
    @your_turn = true
    
    @p1_remaining_playstones = 9
    @p2_remaining_playstones = 9
    
    #images
    @img_map = Gosu::Image.new("assets/game/map.png")
    @img_background = Gosu::Image.new("assets/game/background_game.png")
    @img_playstone_white = Gosu::Image.new("assets/game/playstone_white.png")
    @img_playstone_black = Gosu::Image.new("assets/game/playstone_black.png")
    
    @console = Console.new(300, 642, 600, 68)
        
  end
  
  def draw
    #1200 * 700 20
    @img_background.draw(0,2,0)
    @console.draw
    @img_map.draw(300, 20, 0, 0.375, 0.375)
    
    ### drawing remaining PLAYSTONES of PLAYER1
    for i in 1..@p1_remaining_playstones
      @img_playstone_white.draw(i * 26 , 20, 0, 0.2, 0.2)
    end
    
    ### drawing remaining PLAYSTONES of PLAYER2
    for i in 2..@p1_remaining_playstones + 1
      @img_playstone_black.draw(1200 - i * 26 , 20, 0, 0.2, 0.2)
    end
    
  end
  
  def update
  end
  
end