class GameHandler
  
  @games
  @player
  @waiting_player
  
  def leavingQueue
  end
  
  def joinQueue player
    @waiting_player[@waitingplayer.length] = player
  end
  
  def joinPlayer player 
    @player[@player.length] = player
  end
  
  def leavePlayer player
    for p in @player 
      if(p == player)
        p = nil
      end
    end
  end
  
end