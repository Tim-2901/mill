class Message
  
  def initialize msg, color, font_size
    @color = color
    newmsg = Time.new.strftime("<b>[%H:%M] " + msg)
    @img = Gosu::Image.from_text newmsg, font_size
  end
  
  def draw xpos, ypos
    @img.draw(xpos, ypos, 0, 1, 1, Gosu::Color.argb(@color)) 
  end
  
  def getImage
    return @img
  end
  
end