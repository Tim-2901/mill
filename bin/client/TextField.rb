require './bin/client/Collision'

class TextField < Collision
  
  @xpos
  @ypos
  @length
  @width
  @text
  @main
  @active
  
  def initialize xpos, ypos, width, height, text, main
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @text = Gosu::Image.from_text text,20
    @main = main
    @text_height = @text.height
    @text_width = @text.width
    puts MouseToRect()
  end
  
 
  #def MouseToRect
#    if(@main.mouse_x > @xpos && @main.mouse_x < @xpos + @width && @main.mouse_y > @ypos && @main.mouse_y < @ypos + @height)
 #           return true
 #   end
 #   return false  
 # end
  def draw
     Gosu.draw_rect(@xpos - @height * 0.05, @ypos - @height * 0.05, @width + @height * 0.1, @height * 1.1, Gosu::Color.argb(0xff_000000))
     Gosu.draw_rect(@xpos, @ypos, @width, @height, Gosu::Color.argb(0xff_ffffff))
     @text.draw(@xpos + @width * 0.05, @ypos + (@height - @text_height) * 0.5, 0, 1, 1, Gosu::Color.argb(0xff_000000))
  end
 
  def write
    @textinput = Gosu::TextInput.new
    return true
  end
  
  def update
    puts @textinput.text
    puts @textinput
    @text = Gosu::Image.from_text @textinput.text, 20
    puts "ccc"
  end 
end
