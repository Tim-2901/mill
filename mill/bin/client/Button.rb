class Button
  
  @xpos
  @ypos
  @width
  @height
  @img_0
  @img_1
  @lable
  @paddingx
  @paddingy
  @main
  
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
  
  def update
    
    if(isOverButton)
      @hover = true
    else
      @hover = false
    end
    
    if(@clicked)
      @clicked = false
      return true
    end
    
  end
  
  def setClicked b
    @clicked = b
  end
  
  def isHover
    return @hover
  end
    
end