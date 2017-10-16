require 'bin/client/game/Message'

class ConsoleGame
  
  def initialize xpos, ypos, width, height
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @text = []
  end
  
  def draw
    Gosu.draw_rect(@xpos, @ypos, @width, @height, Gosu::Color.argb(0xff_000000))
    for i in 0..2
      if(@text[i] != nil)  
        @text[i].draw(@xpos + 10, @ypos + i * (@text[i].getImage().height + 2)  + 3)
      end
    end  
  end
  
  def print msg, color
    @text[2] = @text[1]
    @text[1] = @text[0]
    @text[0] = Message.new(msg, color, 18)
  end
  
end