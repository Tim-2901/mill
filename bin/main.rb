require 'gosu'
$LOAD_PATH << 'C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/'
require 'bin/client/Button'
require 'bin/client/TextField'
require 'bin/client/game/ClientGame'
require 'bin/client/game/Connection'
require 'bin/server/server'
require 'bin/client/lobby/Lobby'
require 'bin/server/console'

class Window < Gosu::Window
  WIDTH, HEIGHT, PADDING = 1200, 700, 20
  @active_tab

  def initialize width, height, fullscreen
    super(width, height, fullscreen)

    #Texturen
    @main = self
    @cursor = Gosu::Image.new("C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/curser_normal.png", false)

    @server_thread = nil
    @server = nil
    @string = ""
    @active_tab = 0
    @inlobby = false
    @lobby
    @active_textfield = nil

    @button_list = [
        Button.new(950, 50, ["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "Join a Server", self),
        Button.new(950, 150, ["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "Create a Server", self),
        Button.new(950, 450, ["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "Welcome", self),
        Button.new(950, 250,["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "Sign up", self),
        Button.new(950, 350,["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "Rules", self)
    ]
    @button_login = Button.new(100, 500, ["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "Login", self)
    @button_create = Button.new(50, 600, ["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "Start/Stop Server", self)
    @button_signUp = Button.new(100, 500, ["C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_unpressed.png", "C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/assets/game/button_hover.png"], "SignUp", self)

    @textfield_list = [
        TextField.new(100, 200, 250, 40, "IP:Port", self ,true),
        TextField.new(100, 300, 250, 40, "Username", self, true),
        TextField.new(100, 400, 250, 40, "Password", self, false),
        TextField.new(100, 200, 250, 40, "IP:Port", self ,true),
        TextField.new(100, 300, 250, 40, "Username", self, true),
        TextField.new(100, 400, 250, 40, "Password", self, false)
    ]

    @server_console = Console.new(50, 50, 550, 850, Gosu::Color.argb(0xff_000000), Gosu::Color.argb(0xff_ffffff), self)


    text =
        "
    This is <b>Nine Men's Morris!</b>

    If this is the first time you play the game, you have to <b>Sign up</b> first.
    To start a Game you may <b>Create a Server</b> first or <b>Join a Server</b> directly.
    The default port is: <b>4713</b>
    If you dont know the rules you can read them under <b>Rules</b>.
    You may

    "
    text.gsub! /^ +/,''
    @text = Gosu::Image.from_text text,20,:width => WIDTH * PADDING

    rules =
        "
      <b>Rules</b>
      You win if your opponent has only two stones lef, or if he cannot move.
      There a three phases in the game the set-up phase, and two move phases.
      In each phase you can capture an opposing stone by make three in a row, which is called \"mill\".
      If you got a mill you can take away any stone of your opponent which is not in a mill itselfs.

      <b>Set-Up Phase</b>
      In the Set-Up Phase the players place alternity a stone.
      This phase ends when both players have placed 9 stones.

      <b>Moving Phase</b>
      The moving Phase goes until a player has only 3 stones left.
      In this phase you can move Stones to a adjacent and unoccupied field.
      Whenever you get a mill you can capture a opponent's Stone.

      <b>Endgame</b>
      In the Endgame the player with the 3 stones is allowed to jump around and is not limited to adjancent fields.
      The game ends when the player has only two stones left.
     "
    rules.gsub! /^ +/,''
    @rules = Gosu::Image.from_text rules,20,:width => WIDTH * PADDING

  end

  def draw

    if(!@inlobby)
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
          #for textfield in @textfield_list[3..5]
          #  textfield.draw
          #end
          @server_console.draw
        when 3 then
          for textfield in @textfield_list[3..5]
                textfield.draw
          end
          @button_signUp.draw
        when 4 then
          @rules.draw(PADDING, PADDING, 0, 1, 1, Gosu::Color.argb(0xff_000000))

      end
    else
      @lobby.draw()
    end
    @cursor.draw(self.mouse_x, self.mouse_y, 0)
  end


  def button_up(id)

  end

  def button_down(id)

    case id
      #triggers when left mousebutton is pressed
      when Gosu::MS_LEFT

        if(@inlobby)
          @lobby.click()
        end

        #checks if a button is clicked
        for button in @button_list
          if(button.isHover())
            button.setClicked(true)
          end
        end

        ### join server tab buttons ###
        if(@button_login.isHover() && @active_tab == 1)
          @button_login.setClicked(true)
          puts true
        end

        if(@button_create.isHover() && @active_tab == 2)
          @button_create.setClicked(true)
        end

        if(@button_signUp.isHover() && @active_tab == 3)
          @button_signUp.setClicked(true)
        end

        #checks if a textfield is selected; if so it will set it as selected textfield so you can write in it
        txtflds = case @active_tab
                    when 0 then []
                    when 1 then @textfield_list[0..2]
                    when 2 then []
                    when 3 then @textfield_list[3..5]
                    when 4 then []
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

  def leaveLobby
    @inlobby = false
    @lobby = nil
  end

  def update

    self.caption = "(#{Gosu.fps} FPS)"

    if(!@inlobby)

      ###updating buttons###
      if(@button_list[0].update())
        @active_tab = 1
      end

      if(@button_list[1].update())
        @active_tab = 2
      end

      if(@button_list[2].update())
        @active_tab = 0

      end

      if(@button_list[3].update())
        @active_tab = 3

      end

      if(@button_list[4].update())
        @active_tab = 4
      end

      if(@button_signUp.update())
        connection = Connection.new(@textfield_list[3].fieldtext, 4713)
        answer = connection.sending("signUp" + ";" + @textfield_list[4].fieldtext + ";" + @textfield_list[5].fieldtext)
      end

      if(@button_login.update())
        connection = Connection.new(@textfield_list[0].fieldtext, 4713)
        answer = connection.sending("signIn" + ";" + @textfield_list[1].fieldtext + ";" + @textfield_list[2].fieldtext)
        if(answer == "Login successful")
          @inlobby = true
          @lobby = Lobby.new(self, @textfield_list[1].fieldtext, @textfield_list[0].fieldtext, 4713)
       end
      end
      if(@button_create.update())
        if(@server_thread == nil)
          puts @server_console
          @server_thread = Thread.new{Server.new("localhost", 4713, @server_console, self)}
        else
          @server_console.write("Server has been stopped")
          Thread.kill(@server_thread)
          @server_thread = nil
        end
      end

    else
      @lobby.update
    end

  end
  def consoleUpdate(msg)
    @console.write(msg)
  end

end



#start
@window = Window.new(1200, 720, false)
@window.show
