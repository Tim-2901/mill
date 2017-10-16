require 'bin/client/lobby/LoadingCircle'
require 'bin/client/lobby/PlayerData'

class Lobby
  
  def initialize main, username, ip, port
    @button_queue = Button.new(500, 400, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Find Match", main)
    @button_toplist = Button.new(500, 300, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Leaderboard", main)
    @button_leave = Button.new(500, 500, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Leave Server", main)
    @button_leave_queue = Button.new(500, 400, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Leave Queue", main)
    @button_leave_toplist = Button.new(500, 600, ["assets/game/button_unpressed.png", "assets/game/button_hover.png"], "Back to Lobby", main)
    @loading_circle = LoadingCircle.new(600, 350, 6)
    @username = username
    @main = main
    @ip = ip
    @port = port
    @topplayer = []
    @you
    @img_username = Gosu::Image.from_text "Logged in as: " + @username,20
    @img_queue = Gosu::Image.from_text "Searching game..",40
    # 0 = lobby; 1 = queue; 2 = leaderboard; 3 = game
    @screen = 0
    @game
    @thread
  end
  
  def draw
    case @screen
      when 0 # lobby
        then
        Gosu.draw_rect(0, 0, 1300, 800, Gosu::Color.argb(0xff_ffffff))
        @button_queue.draw
        @button_toplist.draw
        @button_leave.draw
        @img_username.draw(50, 50, 0, 1, 1, Gosu::Color.argb(0xff_000000))
      when 1 #queue
        then
        Gosu.draw_rect(0, 0, 1300, 800, Gosu::Color.argb(0xff_ffffff))
        @button_leave_queue.draw
        @img_queue.draw((1200 - @img_queue.width) * 0.5, 250, 0, 1, 1, Gosu::Color.argb(0xff_000000))
        @loading_circle.draw
      when 2 #leader board
        then
        Gosu.draw_rect(0, 0, 1300, 800, Gosu::Color.argb(0xff_ffffff))
        for i in 0.. @topplayer.length - 1
          @topplayer[i].draw(325, 150 + 25 * i, 150,250,350,450)
        end
        @you.draw(325, 500, 150, 250, 350, 450)
        
        @button_leave_toplist.draw
        
      when 3 #game
        then
        @game.draw
    end
  end
  
  def update
    case @screen
      when 0 #lobby
        if(@button_queue.update)
          @screen = 1
          @thread = Thread.new{
            connection = Connection.new(ip, port)
            connection.puts("queueUp;" + @username)
            msg = connection.gets.chop.force_encoding(Encoding::UTF_8)
            @game = ClientGame.new(@username, msg, @main)
            @screen = 3
          }
#          @game = ClientGame.new("wsd", "dsa", @main, @ip, @port)
#          @screen = 3
          
        end
        if(@button_leave.update)
          @main.leaveLobby
        end
        if(@button_toplist.update)
           
         connection = Connection.new(@ip, @port)
         connection.puts("leaderboard;username")
         msg = connection.gets.chop.force_encoding(Encoding::UTF_8)
          remove_brackets = msg[2..-3]
          player = remove_brackets.split('], [')
          for i in 0..player.length - 1
            rawplayerdata = player[i].gsub('\"', "")
            playerdata = rawplayerdata.split(',')
            if(playerdata.length < 6)
              @topplayer[i] = PlayerData.new((i + 1).to_s + ". " + playerdata[0],playerdata[1],playerdata[2],playerdata[3][0..7],playerdata[4][0..7])
            else
              @screen = 2
              @you = PlayerData.new(playerdata[5] + ". " + playerdata[0],playerdata[1],playerdata[2],playerdata[3][0..7],playerdata[4][0..7]  + " (you)")
            end
          end
       end
       if(@button_leave.update)
         @main.leaveLobby
       end
      when 1 #queue
        then
        @loading_circle.update
        if(@button_leave_queue.update)
          @screen = 0
          Thread.kill(@thread)
        end
      when 2 #leaderboard
        then
        if(@button_leave_toplist.update)
          @screen = 0
        end
      when 3 #game
        then
        if(@game.update)
          @screen = 0
          @game = nil
        end
    end

  end
  
  def click
    if(@button_queue.isHover)
      @button_queue.setClicked(true)
    end
    if(@button_toplist.isHover)
      @button_toplist.setClicked(true)
    end
    if(@button_leave.isHover)
      @button_leave.setClicked(true)
    end
    if(@button_leave_queue.isHover)
      @button_leave_queue.setClicked(true)
    end
    if(@button_leave_toplist.isHover)
      @button_leave_toplist.setClicked(true)
    end
    if(@game != nil)
      @game.mouseClicked
    end
  end
end