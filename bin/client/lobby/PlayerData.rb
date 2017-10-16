class PlayerData 
  
  def initialize username, wins, loses, winrate, score
     @username = Gosu::Image.from_text username,20
     @wins = Gosu::Image.from_text wins,20
     @loses = Gosu::Image.from_text loses,20
     @winrate = Gosu::Image.from_text winrate,20
     @score = Gosu::Image.from_text score,20
     
  end
  
  def draw x, y, ax1, ax2, ax3, ax4
    @username.draw(x,y,0,1,1,Gosu::Color.argb(0xff_000000))
    @wins.draw(x+ax1,y,0,1,1,Gosu::Color.argb(0xff_000000))
    @loses.draw(x+ax2,y,0,1,1,Gosu::Color.argb(0xff_000000))
    @winrate.draw(x+ax3,y,0,1,1,Gosu::Color.argb(0xff_000000))
    @score.draw(x+ax4,y,0,1,1,Gosu::Color.argb(0xff_000000))
  end
  
end