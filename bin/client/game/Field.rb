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
    puts "stone created"
  end
  
  # Description:
  # draws this field/playstone
  #
  # Parameter(s):
  # main
  #
  # Return:
  # - 
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
  
  # Description:
  # updates the field, sets @alpha to the normal value the creates the hover
  # effect
  #
  # Parameter(s):
  # -
  # Return:
  # boolean value
  # true : field is hovered
  # false : field isn't hovered
  def update
    if(@hover)
      @alpha = @normal_value
      @stone_placed = true
      return true
    end
    return false
  end
  
# Description:
# getter of @color
# Parameter(s):
# -
# Return:
# color ("white" / "black)
  def getColor
    return @color
  end
  
# Description:
# setter of selected
# Parameter(s):
# boolean value
# Return:
# -
  def setSelected b
    @selected = b
  end
  
# Description:
# checks if the field is hovered
# Parameter(s):
# main
# Return:
# boolean value
  def isHovered main
    rel_x = @x +  @radius - main.mouse_x
    rel_y = @y + @radius - main.mouse_y
                     
    if((rel_x**2 + rel_y **2) <= @radius**2)
      return true
    end
    return false
  end
  
# Description:
# getter of @isghost
# Parameter(s):
# -
# Return:
# boolean value
# true : is a ghoststone
# false : isn't a ghoststone
  def isGhost
    return @isghost
  end
  
# Description:
# sets a ghoststone on this field, which gets rendered and updated
# Parameter(s):
# -
# Return:
# -
  def setGhostStone
    @alpha = 0x60ffffff
    @isghost = true
    @visible = true
    @color = "white"
  end
  
# Description:
# sets a normal stone on this field, which gets rendered and updated
# Parameter(s):
# color ("white"/"black")
# Return:
# -
  def setStone color
    @alpha = 0xffffffff
    @visible = true
    @isghost = false
    @stone_placed = true
    @color = color
  end

# Description:
# removes any kind of stone from this field (ghoststones and normal stones)
# Parameter(s):
# -
# Return:
# -
  def clear
    @visible = false
    @isghost = false
    @stone_placed = false
  end
  
# Description:
# checks if this field is taken by a ghoststone or a normal stone
# Parameter(s):
# -
# Return:
# boolean value
  def isTaken
    return @stone_placed
  end
  
end