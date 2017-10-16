class Button
  
  @hover = false
  @clicked = false
  
  def initialize xpos, ypos, img, lable, main
    @xpos = xpos
    @ypos = ypos
    @img_0 = Gosu::Image.new(img[0])
    @img_1 = Gosu::Image.new(img[1])
    @width = @img_0.width
    @height = @img_0.height
    @lable = Gosu::Image.from_text lable,20
    @paddingx = (@img_0.width - @lable.width) * 0.5
    @paddingy = (@img_0.height - @lable.height) * 0.5
    @main = main
  end
  
  # Description:
  # draws the button images dependent on the boolean @ishover, which is true
  # if the mouses position is inside the rectangle/image
  #
  # Parameter(s):
  # -
  # 
  # Return:
  # -
  def draw
    if(!@hover)
      @img_0.draw(@xpos, @ypos, 0)
    else
      @img_1.draw(@xpos, @ypos, 0) 
    end
      
    @lable.draw(@xpos + @paddingx, @ypos + @paddingy, 0)
  end
  
  def isOverButton
    if(@main.mouse_x > @xpos && @main.mouse_x < @xpos + @width && @main.mouse_y > @ypos && @main.mouse_y < @ypos + @height)
            return true
        end
        return false
  end
  
  # Description:
  # updates the button, checks if the button was clicked
  # Parameter(s):
  # -
  # Return:
  # boolean value
  # true : the button was clicked
  # false: the button wasn't clicked
  def update
    
    if(isOverButton)
      @hover = true
    else
      @hover = false
    end
    
    if(@clicked)
      @clicked = false
      @hover = false
      return true
    end
    
    return false
    
  end
  
  # Description:
  # setter; used to tell the button that it was clicked
  # Parameter(s):
  # -
  # Return:
  # -
  def setClicked b
    @clicked = b
  end
  
  # Description:
  # getter; used to check if the button is hovered by the mouse
  # Parameter(s):
  # -
  # Return:
  # boolean value
  def isHover
    return @hover
  end
    
end