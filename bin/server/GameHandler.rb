$LOAD_PATH << 'C:/Users/Judith/Dropbox/2 NumProg/Informatik_I/Übersicht/Prüfung/Tim und Tom/mill-master/'
require '/bin/server/game/Player.rb'

class GameHandler
  
  @@player = []
  @@waiting_player = []
  @games = []
  
  def update
    if(@@waiting_player.length > 1)
      createNewGame(@@waiting_player[0], @@waiting_player[1])
      @@waiting_player.delete_at(1)
      @@waiting_player.delete_at(0)
    end
  end
  
  def createNewGame p1, p2
    puts p1.getName + p2.getName
  end
  
  def isPlayinQueue player
    for p in @@waiting_player
      if(p == player)
        return true
      end
    end
      return false
  end
  
  def leavingQueue player
    for i in 0.. @@waiting_player.length
      if(@@waiting_player[i] == player)
        @@waiting_player.delete_at(i)
        break
      end
    end 
  end
  
  def joinQueue player
    @@waiting_player << player
  end
  
  def joinPlayer player 
    @@player << player
  end
  
  def leavePlayer player
    for p in @@player 
      if(p == player)
        p = nil
      end
    end
  end
  
  def getWaitingPlayer
    return @@waiting_player
  end
  
  def getOnlinePlayer
    return @@player
  end
  
  def getGames
    return @@games
  end
  
end
