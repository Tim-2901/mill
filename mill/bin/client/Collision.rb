class Collision
  
  def MouseToRect
    
    if(@main.mouse_x > @xpos && @main.mouse_x < @xpos + @width && @main.mouse_y > @ypos && @main.mouse_y < @ypos + @height)
            return true
    end
    return false
    
  end
  
end