require 'gosu'
require './bin\client\Frame.rb'

class Window < Gosu::Window
@frame
  def initialize width, height, fullscreen
    super(width, height, fullscreen)
    @frame = Frame.new(self)
  end
  
  

    
  def draw
    @frame.draw()
  end

 
  def button_up(id)
  if(id == Gosu::MS_LEFT)
    @frame.mouse_clicked
  end
 
  
  end
    
  def update
    @frame.update()
  end
  
end  


  
  #start
  @window = Window.new(1200, 720, false)
  @window.show

  
  