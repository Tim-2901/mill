require './bin/client/Button'
require './bin/client/TextField'
require './bin/client/Collision.rb'
require '/bin/client/game/Game.rb'

class Frame < Collision
  WIDTH, HEIGHT, PADDING = 1200, 700, 20
  @active_tab
  
  def initialize main
    
    #Texturen
    @main = main
    @cursor = Gosu::Image.new("assets/game/curser_normal.png", false)
    
    # Button textures
    # 0 = button_join; 1 = button_create_server; 2 = welcome
    @button_list = [
      Button.new(950, 50, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Join a Server", @main),
      Button.new(950, 150, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Create a Server", @main),
      Button.new(950, 250, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Welcome", @main)
    ]  
    
    #textinput
    @textinput_ip = Gosu::TextInput.new
    @textinput_username = Gosu::TextInput.new
    @textinput_pw = Gosu::TextInput.new
    
    @active_tab = 0
    @writing

    
    @textfield_list = [
     TextField.new(100, 200, 250, 40, "IP:Port", @main),
     TextField.new(100, 300, 250, 40, "Username", @main),
     TextField.new(100, 400, 250, 40, "Password", @main) 
    ]
      
    
    text = 
    "
    This is <b>Nine Men's Morris!</b>
    
    To play this Game you have to press <b>create a server</b> first.
    Then you can invite your friends to <b>join the server</b>.
    The default port is: <b>1234</b>
    If you want to be listed in the leaderboard you have to <b>sign up/in</b> with a username and a password.
    
    "
    text.gsub! /^ +/,''
    @text = Gosu::Image.from_text text,20,:width => WIDTH * PADDING
    
  end
  
  def draw
    
    Gosu.draw_rect(0, 0, @main.width, @main.height, Gosu::Color.argb(0xff_ffffff))
    
    for button in @button_list
      button.draw()
    end
    
    
    case @active_tab
      #draws welcome screen
      when 0 then
        @text.draw(PADDING, PADDING, 0, 1, 1, Gosu::Color.argb(0xff_000000))
      #draws join screen
      when 1 then
        for textfield in @textfield_list
          textfield.draw
        end
        when 3 then
          
          
          
    end 

    @cursor.draw(@main.mouse_x, @main.mouse_y, 0)
  end
  
  def mouse_clicked
    for button in @button_list
      if(button.isHover())
        button.setClicked(true)
      end
    end
    
    for textfield in @textfield_list
      if(textfield.MouseToRect())
        @writing = textfield.write()
        puts "textfield"
      end  
    end  
  end
 
  def update
    for textfield in @textfield_list
      if(textfield.MouseToRect() && @writing)
        textfield.update()
        puts "frame"
      end
    end
    @main.caption = "(#{Gosu.fps} FPS)"
    
    if(@button_list[0].update()) 
      @active_tab = 1
    end
    
    if(@button_list[1].update()) 
      @active_tab = 2
    end
    
    if(@button_list[2].update()) 
      @active_tab = 0
    end
    
  end

end