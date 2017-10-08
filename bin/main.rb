require 'gosu'
$LOAD_PATH << 'C:/Users/konop/Documents/mill/'
require 'bin/client/Button'
require 'bin/client/TextField'
require 'bin/client/Collision'
require 'bin/client/game/ClientGame'
require 'bin/client/game/Connection'
require 'bin/server/server'

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
    @button_create = Button.new(100, 500, ["C:/Users/konop/Documents/mill/assets/game/button_unpressed.png", "C:/Users/konop/Documents/mill/assets/game/button_hover.png"], "Create Server", self)

    @textfield_list = [
        TextField.new(100, 200, 250, 40, "IP:Port", self ,true),
        TextField.new(100, 300, 250, 40, "Username", self, true),
        TextField.new(100, 400, 250, 40, "Password", self, false),
        TextField.new(100, 200, 250, 40, "IP", self, true),
        TextField.new(100, 300, 250, 40, "Port", self, true),
        TextField.new(100, 400, 250, 40, "Name", self, true)
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

          for textfield in @textfield_list[0..2]
            textfield.draw
          end
        when 2 then

          @button_create.draw
          for textfield in @textfield_list[3..5]
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
        if(@button_login.isHover() && @active_tab == 1)
          @button_login.setClicked(true)
        end

        if(@button_create.isHover() && @active_tab == 2)
          @button_create.setClicked(true)
        end

        #checks if a textfield is selected; if so it will set it as selected textfield so you can write in it
        txtflds = case @active_tab
                    when 0 then []
                    when 1 then @textfield_list[0..2]
                    when 2 then @textfield_list[3..5]
                  end
        for textfield in txtflds

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
        connection = Connection.new(@textfield_list[0].fieldtext, 4713)
        answer = connection.sending("signIn" + ";" + @textfield_list[1].fieldtext + ";" + @textfield_list[2].fieldtext)
        if(answer == "Login successful")
          @ingame = true
          @game = ClientGame.new("Spieler1", "Spieler2", self)
          #TODO queue muss hier eingefügt werden
        end
      end

      if(@button_create.update())
        puts "a"
        server = Thread.new{Server.new("localhost", 4713)}
        puts "b"
      end

    else
      @game.update
    end

  end
end



#start
@window = Window.new(1200, 720, false)
@window.show
