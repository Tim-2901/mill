class Player
  
  @name
  @connection
  @wins
  @loses
  
  def initialize name, connection, wins, loses
   @name = name
   @connection = connection
   @wins = wins
   @loses = loses
  end
  
  def getName
    return @name
  end
  
  def getConnection
    return @connection
  end
  
  def getWins
    return @wins
  end
  
  def getLoses
    return @loses
  end
  
end