class LoadingCircle
  
  def initialize x, y, speed
   @x = x
   @y = y
   @speed = speed 
   @angle = 0
   @img = Gosu::Image.new("assets/game/loading.png")
  end
  
  def draw
    @img.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, 0.5, 0.5, 0xff_ffffff,:default)
  end
  
  def update
    @angle += 1 * @speed
    if(@angle == 360)
      @angle = 0
    end 
  end
end