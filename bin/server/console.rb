

class Console

  def initialize(xpos, ypos, height, width, color, text_color, main)
    @fontsize = 17
    @padding = 10
    @xpos = xpos
    @ypos = ypos
    @height = height
    @width = width
    @color = color
    @text_color = text_color
    @text = ""
    @textimg = Gosu::Image.from_text("", @fontsize)
    @main = main
    @textlist = []
    puts "initialized console"

  end

  def draw
    if @textlist != []
      update
    end
    Gosu.draw_rect(@xpos, @ypos, @width, @height, @color)
    @textimg.draw(@xpos + @padding, @ypos + @padding, 0, 1, 1, @text_color)

  end

  def update
    for i in @textlist
      write(i)
    end

    @textlist = []
  end

  def write(input)
      @text += (input + "\n")
      if(@text.split("\n").length * @fontsize + @padding >= @height)
        @text = @text[(@text.index("\n") + 1)..-1]
      end
      @textimg = Gosu::Image.from_text(@text, @fontsize)
  end

  def clear
    @text = ""
  end

  def textlist(string)
    @textlist << string
  end

end

