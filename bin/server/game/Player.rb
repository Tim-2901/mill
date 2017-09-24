class Player
  
  @name
  @connection
  @winrate
  
  def initialize name, connection, winrate
   @name = name
   @connection = connection
   @winrate = winrate
  end
  
  def getName
    return @name
  end
  
  def getConnection
    return @connection
  end
  
  def getWinrate
    return @winrate
  end
  
end