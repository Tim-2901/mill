class Field 
  
  def initialize x, y
    @x = x * 0.375 + 282
    @y = y * 0.375
    @alpha = 0xffffffff
    @ghost_value = 0x60ffffff
    @normal_value = 0xffffffff
    @visible = false
    @stone_placed = false
    @isghost = false
    @hover = false
    @radius = 20
    @selected = false
    @color = ""
    
    #images
    @img_playstone_white = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/playstone_white.png")
    @img_playstone_black = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/playstone_black.png")
    @img_playstone_selection = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/playstone_selection.png")
    
  end
  
  def draw main
    if(@visible)
      @hover = isHovered(main)
      if(@hover && !@stone_placed)
        @alpha = @normal_value
      else if(@isghost)
        @alpha = @ghost_value
      else if(@stone_placed)
        @alpha = @normal_value
      end end end
      if(@color == "white")
        @img_playstone_white.draw(@x, @y, 0, 0.375, 0.375, @alpha)
      else if(@color == "black")
        @img_playstone_black.draw(@x, @y, 0, 0.375, 0.375, @alpha);
      end end
        
      if(@selected)
        @img_playstone_selection.draw(@x, @y, 0, 0.375, 0.375)
      end
      
    end
  end
  
  def update
    if(@hover)
      @alpha = @normal_value
      @stone_placed = true
      return true
    end
    return false
  end
  
  def getColor
    return @color
  end
  
  def setSelected b
    @selected = b
  end
  
  def isHovered main
    rel_x = @x +  @radius - main.mouse_x
    rel_y = @y + @radius - main.mouse_y
    
    #pythagoras                    
    if((rel_x**2 + rel_y **2) <= @radius**2)
      return true
    end
    return false
  end
  
  def setGhostStone
    @alpha = 0x60ffffff
    @isghost = true
    @visible = true
    @color = "white"
  end
  
  def setStone color
    @alpha = 0xffffffff
    @visible = true
    @isghost = false
    @stone_placed = true
  end
  
  def clear
    @visible = false
    @isghost = false
    @stone_placed = false
  end
  
  def taken
    return @stone_placed
  end
  
end