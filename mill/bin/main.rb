require 'gosu'
$LOAD_PATH << 'C:/Users/konop/Documents/mill/'
require 'bin/client/Button'
require 'bin/client/TextField'
require 'bin/client/Collision'
require 'bin/client/game/ClientGame'

class Window < Gosu::Window
  WIDTH, HEIGHT, PADDING = 1200, 700, 20
  @active_tab
  
  def initialize width, height, fullscreen
    super(width, height, fullscreen)

    #Texturen
    @main = self
    @cursor = Gosu::Image.new("C:/Users/konop/Documents/mill/assets/game/curser_normal.png", false)



    @string = ""
    @active_tab = 0
    @ingame = false
    @game
    @active_textfield = nil
    # 0 = button_join; 1 = button_create_server; 2 = sing up/in
    @button_list = [
      Button.new(950, 50, ["C:/Users/konop/Documents/mill/assets/game/button_unpressed.png", "C:/Users/konop/Documents/mill/assets/game/button_hover.png"], "Join a Server", self),
      Button.new(950, 150, ["C:/Users/konop/Documents/mill/assets/game/button_unpressed.png", "C:/Users/konop/Documents/mill/assets/game/button_hover.png"], "Create a Server", self),
      Button.new(950, 250, ["C:/Users/konop/Documents/mill/assets/game/button_unpressed.png", "C:/Users/konop/Documents/mill/assets/game/button_hover.png"], "Welcome", self)
    ]
    @button_login = Button.new(100, 500, ["C:/Users/konop/Documents/mill/assets/game/button_unpressed.png", "C:/Users/konop/Documents/mill/assets/game/button_hover.png"], "Login", self)


    @textfield_list = [
     TextField.new(100, 200, 250, 40, "IP:Port", self ,true),
     TextField.new(100, 300, 250, 40, "Username", self, true),
     TextField.new(100, 400, 250, 40, "Password", self, false)
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

    if(!@ingame)
      Gosu.draw_rect(0, 0, self.width, self.height, Gosu::Color.argb(0xff_ffffff))

      for button in @button_list
        button.draw()
      end


      case @active_tab
        when 0 then
          @text.draw(PADDING, PADDING, 0, 1, 1, Gosu::Color.argb(0xff_000000))
        when 1 then

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
  
  
  def button_up(id)

  end

  def button_down(id)

    case id
      #triggers when left mousebutton is pressed
      when Gosu::MS_LEFT

        #checks if a button is clicked
        for button in @button_list
          if(button.isHover())
            button.setClicked(true)
          end
        end

        ### join server tab buttons ###
        if(@button_login.isHover())
          @button_login.setClicked(true)
        end

        #checks if a textfield is selected; if so it will set it as selected textfield so you can write in it
        for textfield in @textfield_list

          # if a textfield is already selected and you click next to it will be unselected
          if(@active_textfield != nil && !@active_textfield.MouseToRect())
            @active_textfield.unselect()
            @active_textfield = nil
            puts "unselect"
          end

          if(textfield.MouseToRect())
            @active_textfield = textfield.selected()
            puts "pressed"
            puts @active_textfield
          end
        end

        #delete a letter in the textfield
        when Gosu::KB_BACKSPACE
          @active_textfield.delete_char()
        else
          if(@active_textfield != nil)
            char = Gosu::button_id_to_char(id)
            @active_textfield.write(char)
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