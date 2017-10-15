

class Console

  def initialize(xpos, ypos, height, width, color, text_color, main)
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @color = color
    @text_color = text_color
    @text = ""
    @textimg = Gosu::Image.from_text("", 20)
    @main = main
    @textlist = []
    puts "initialized console"

  end

  def draw
    if @textlist != []
      update
    end
    Gosu.draw_rect(@xpos, @ypos, @width, @height, @color)
    @textimg.draw(@xpos + 10, @ypos + 10, 0, 1, 1, @text_color)

  end

  def update
    for i in @textlist
      write(i)
    end

    @textlist = []
  end

  def write(input)
    @text += (input + "\n")
    @textimg = Gosu::Image.from_text(@text, 20)
  end

  def clear
    @text = ""
  end

  def textlist(string)
    @textlist << string
  end

end

