$LOAD_PATH << 'C:/Users/konop/Documents/mill/'
require 'bin/client/Collision'
require 'gosu'
# File: TextField.rb
# Author: Tim Konopka & Tom Hauschild
#
# Description:
# Creates a Textfield
class TextField

  # Instance Variables
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


  # Description:
  # creates a textfield
  #
  # Parameter(s):
  # xpos - int: xpos of the Textfield in pixels
  # ypos - int: ypos of the Textfield in pixels
  # width - int: width of the Textfield in pixels
  # height - int: height of the Textfield in pixels
  # text - string: text to be drawn in the textfield until it is selected
  # main - Gosu::Window: the main window
  # blank - boolean: false to show points(●) instead of the text(e. g. for passwords)
  #
  # Return:
  # nothing
  def initialize xpos, ypos, width, height, text, main, blank
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @text = Gosu::Image.from_text text,20
    @main = main
    @blank = blank
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


  # Description:
  # checks if the mouse is over the textfield
  #
  # Parameter(s):
  # -
  #
  # Return:
  # true or false
  def MouseToRect
    if(@main.mouse_x > @xpos && @main.mouse_x < @xpos + @width && @main.mouse_y > @ypos && @main.mouse_y < @ypos + @height)
            return true
    end
    return false  
  end


  # Description:
  # draws the whole Textfield
  #
  # Parameter(s):
  # -
  #
  # Return:
  # -
  def draw
    #if(MouseToRect() && @ms_down)
     # @text = @textinput.text
     # @text = Gosu::Image.from_text @textinput.text, 20
    #else
     # @ms_down = false
    #end

    #border
    Gosu.draw_rect(@xpos - @height * 0.05, @ypos - @height * 0.05, @width + @height * 0.1, @height * 1.1, @text_color)

    #box
    Gosu.draw_rect(@xpos, @ypos, @width, @height, @box_color)

    #text
    @text.draw(@xpos + @width * 0.05, @ypos + (@height - @text_height) * 0.5, 0, 1, 1, @text_color)

    #cusor
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

  # Description:
  # is executed when the textfield is selected(see main>>button_down for more information)
  #
  # Parameter(s):
  #
  #
  # Return:
  # self
  def selected
   
    #@textinput = Gosu::TextInput.new
    #@ms_down = true
    @selected = true
    return self
  end


  # Description:
  # handles the input in a textfield
  #
  # Parameter(s):
  # char - char: char to be written
  #
  # Return:
  #
  def write(char)
    @fieldtext << char
    puts @fieldtext
    puts "write"
    if (!@blank)
      @text = Gosu::Image.from_text "●" * @fieldtext.length, 20
    else
      @text = Gosu::Image.from_text @fieldtext, 20
    end


  end


  # Description:
  # unselects the textfield
  #
  # Parameter(s):
  #
  #
  # Return:
  #
  def unselect
    @selected = false
  end


  # Description:
  # deletes a char(see main>>button_down>>KB::Backspace for more information)
  #
  # Parameter(s):
  #
  #
  # Return:
  #
  def delete_char
    @fieldtext = @fieldtext.chop
    puts "delete"
    puts @fieldtext
    if (!@blank)
      @text = Gosu::Image.from_text "●" * @fieldtext.length, 20
    else
      @text = Gosu::Image.from_text @fieldtext, 20
    end
  end

  # Description:
  # draws the cursor
  #
  # Parameter(s):
  #
  #
  # Return:
  #
  def cursor



    xpos = (@xpos + @width * 0.05 ) + @text.width
    ypos = @ypos + (@height - @text_height) * 0.5

    height = @text_height

    Gosu::draw_line(xpos, ypos, @text_color, xpos , ypos + height, @text_color)
  end

  def fieldtext
    return @fieldtext
  end

  def update
  end
end
