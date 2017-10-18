# This is Nine Men's Morris writen in Ruby.
The gems 'gosu' and 'sqlite3' are used.
To install them open your ruby console and write 'gem install gosu' and 'gem install sqlite3'.
In the Project relative Pathes are used, which is working with old Ruby Version but not with newer.
If you want it to run without relative Pathes you can add '$LOAD_PATH << YOUR_PATH_TO_THE_MILL-MASTER_FOLDER'.
Then the 'require' commands will work.
But there are also Pathes to Images used for the game which have to been changed manualy(or with replaye all).
The SignUp/SignIn functions should work fine, the offline Game should work and also the leaderboards should work.
The Join Queue function is bugged and we were not able to fix it within roundabout 8 hours.
You can join the queue, if the server finds anonther player the Game will be drawn and then 2 moves a possible.
After that it will freeze and you can't do anything.
This is due to a error in the network communication, because a "ok" which should confirm that the clients move is legal isn't send but we can't really figure out why not.
