$LOAD_PATH << 'C:/Users/konop/Documents/mill/'
require 'bin/client/Collision'
require 'gosu'

class TextField
  
  @xpos
  @ypos
  @length
  @width
  @text
  @main
  @active
  @fieldtext
  @text_color
  @selected
  @cursor_active
  @cursor_counter
  @font
  @cursor_pos
  
  def initialize xpos, ypos, width, height, text, main
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @text = Gosu::Image.from_text text,20
    @main = main
    @text_height = @text.height
    @text_width = @text.width
    @fieldtext = ""
    @text_color = Gosu::Color.argb(0xff_000000)
    @box_color = Gosu::Color.argb(0xff_ffffff)
    @selected = false
    @cursor_active = true
    @cursor_counter = 0
    @cursor_pos = 0;
  end
  
  def MouseToRect
    if(@main.mouse_x > @xpos && @main.mouse_x < @xpos + @width && @main.mouse_y > @ypos && @main.mouse_y < @ypos + @height)
            return true
    end
    return false  
  end
  
  def draw
      #if(MouseToRect() && @ms_down)
       # @text = @textinput.text
       # @text = Gosu::Image.from_text @textinput.text, 20
      #else
       # @ms_down = false
      #end
     Gosu.draw_rect(@xpos - @height * 0.05, @ypos - @height * 0.05, @width + @height * 0.1, @height * 1.1, @text_color)
     Gosu.draw_rect(@xpos, @ypos, @width, @height, @box_color)
     @text.draw(@xpos + @width * 0.05, @ypos + (@height - @text_height) * 0.5, 0, 1, 1, @text_color)
    if(@selected && @cursor_active)

      @cursor_counter  += 1
      if(@cursor_counter > 30)
        @cursor_active = false
        @cursor_counter = 0
      end
      cursor()
    else
      @cursor_counter  += 1
      if(@cursor_counter > 30)
        @cursor_active = true
        @cursor_counter = 0
      end
    end

  end
 
  def selected
   
    #@textinput = Gosu::TextInput.new
    #@ms_down = true
    @selected = true
    return self
  end

  def write(char)
    @fieldtext << char
    puts @fieldtext
    puts "write"
    @text = Gosu::Image.from_text @fieldtext, 20
  end

  def unselect
    @selected = false
  end

  def delete_char
    @fieldtext = @fieldtext.chop
    puts "delete"
    puts @fieldtext
    @text = Gosu::Image.from_text @fieldtext, 20
  end

  def cursor
    i = -1
    if i != -1 then
      text_cursor = @fieldtext[0..i]
      cursor_shift = Gosu::Image.from_text(text_cursor,20).width
    else
      cursor_shift = 0
    end



    xpos = (@xpos + @width * 0.05 )+ cursor_shift
    ypos = @ypos + (@height - @text_height) * 0.5

    height = @text_height
    width = 4

    Gosu::draw_line(xpos, ypos, @text_color, xpos , ypos + height, @text_color)
  end

  def update
  end 
end
