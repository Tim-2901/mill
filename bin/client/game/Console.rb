class Console
  
  def initialize xpos, ypos, height, width
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @text = []
  end
  
  def draw
    Gosu.draw_rect(0, 0, self.width, self.height, Gosu::Color.argb(0xff_000000))
  end
  
  def print msg, color
      
    
    
  end
  
end