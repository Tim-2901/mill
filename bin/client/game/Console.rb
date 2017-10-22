class ConsoleGame
  
  def initialize xpos, ypos, width, height
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @text = []
  end
  
  # Description:
  # draws the console
  # Parameter(s):
  # -
  # Return:
  # -
  def draw
    Gosu.draw_rect(@xpos, @ypos, @width, @height, Gosu::Color.argb(0xff_000000))
    for i in 0..2
      if(@text[i] != nil)  
        @text[i].draw(@xpos + 10, @ypos + @height - (i + 1)* (@text[i].getImage().height + 2)  -3)
      end
    end  
  end
  
# Description:
# prints a message on the console
#
# Parameter(s):
# String - msg
# Color - color
#
# Return:
# -
  def print msg, color
    @text[2] = @text[1]
    @text[1] = @text[0]
    @text[0] = Message.new(msg, color, 18)
  end
  
end