require 'gosu'
require 'bin/client/Button'
require 'bin/client/TextField'
require 'bin/client/Collision'
require 'bin/client/game/ClientGame'
class Window < Gosu::Window
  WIDTH, HEIGHT, PADDING = 1200, 700, 20#
    
  def initialize width, height, fullscreen
    super(width, height, fullscreen)

    #Texturen
    @main = self
    @cursor = Gosu::Image.new("assets/game/curser_normal.png", false)

    @string = ""
    @active_tab = 0
    @ingame = false
    @game
    @active_textfield = nil
    ### BUTTONS ###
    # 0 = button_join; 1 = button_create_server; 2 = sing up/in
    @button_list = [
      Button.new(950, 50, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Join a Server", self),
      Button.new(950, 150, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Create a Server", self),
      Button.new(950, 250, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Welcome", self)
    ]
    @button_login = Button.new(100, 500, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Login", self)
    
    @textfield_list = [
     TextField.new(100, 200, 250, 40, "IP:Port", self),
     TextField.new(100, 300, 250, 40, "Username", self),
     TextField.new(100, 400, 250, 40, "Password", self) 
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
    
    Gosu.draw_rect(0, 0, self.width, self.height, Gosu::Color.argb(0xff_ffffff))
    
    if(!@ingame)
      for button in @button_list
        button.draw()
      end
      
      
      case @active_tab
        when 0 then
          ### Menu Welcome Screen ###
          @text.draw(PADDING, PADDING, 0, 1, 1, Gosu::Color.argb(0xff_000000))
        when 1 then
          ### Menu Join Server ###
          
          @button_login.draw
          
          for textfield in @textfield_list
            textfield.draw
          end
          
      end 
      
    else
      @game.draw()
    end
    
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end
  
  #Buttons have to get registered in this method
  def button_up(id)
    if(id == Gosu::MS_LEFT)
      
      ### main menu buttons ###
      for button in @button_list
        if(button.isHover())
          button.setClicked(true)
        end
      end

      ### join server tab buttons ###
      if(@button_login.isHover())
        @button_login.setClicked(true)
      end
    
      for textfield in @textfield_list
        if(textfield.MouseToRect())
          @active_textfield = textfield.selected()
        end
      end
    end
  end

  def button_down(id)
    if(@active_textfield != nil)
      case id
        when Gosu::KB_BACKSPACE
          @active_textfield.delete_char()
        else
          if(@active_textfield.MouseToRect())
            char = Gosu::button_id_to_char(id)
            @active_textfield.write(char)

          else
            @active_textfield.unselect()
            @active_textfield = nil
          end
      end
    end
  end
   
    
  
  
  def update

    self.caption = "(#{Gosu.fps} FPS)"
   
    if(!@ingame) 
      
      ###updating buttons###
      if(@button_list[0].update())
        @active_tab = 1
      end
  
      if(@button_list[1].update())
        @active_tab = 2
      end
  
      if(@button_list[2].update())
        @active_tab = 0
        puts "hello"
      end
      
      if(@button_login.update())
        @ingame = true
        @game = ClientGame.new("Spieler1", "Spieler2")
        #TODO queue muss hier eingefügt werden
      end
        
    else
      @game.update
    end
    
 end
  
end

  
  #start
  @window = Window.new(1200, 720, false)
  @window.show