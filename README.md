21¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦18¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦15
¦¦               ¦¦    		  ¦¦
¦¦		 ¦¦		  ¦¦
¦¦    22¦¦¦¦¦¦¦¦¦19¦¦¦¦¦¦¦¦¦16	  ¦¦
¦¦    ¦¦	 ¦¦ 	    ¦¦	  ¦¦
¦¦    ¦¦       	 ¦¦	    ¦¦	  ¦¦
¦¦    ¦¦     23¦¦20¦¦17	    ¦¦    ¦¦
¦¦    ¦¦     ¦¦	     ¦¦     ¦¦    ¦¦
00¦¦¦¦01¦¦¦¦¦02      14¦¦¦¦¦13¦¦¦¦12
¦¦    ¦¦     ¦¦      ¦¦     ¦¦    ¦¦
¦¦    ¦¦     05¦¦08¦¦11     ¦¦    ¦¦
¦¦    ¦¦         ¦¦	    ¦¦    ¦¦
¦¦    ¦¦         ¦¦	    ¦¦    ¦¦
¦¦    04¦¦¦¦¦¦¦¦¦07¦¦¦¦¦¦¦¦¦10    ¦¦
¦¦		 ¦¦	          ¦¦
¦¦		 ¦¦		  ¦¦
03¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦06¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦09

This is the pattern of the Field
Why is it choosen like this?
Because it is the easiest way to find a mill and the position which are next to each other.
There are only 6 diffrent position which are repeating all the time(0-5 is the same like 6-11).
For the cases pos % 6 =3,4,5 a mill could occour at [pos, pos + 3, pos + 6] or [pos, pos - 3, pos - 6] 
For the other cases a mill could occour at [pos, pos + 3, pos - 3] and for 
pos % 6 = 0 [pos, pos + 1, pos + 2]
pos % 6 = 1 [pos, pos + 1, pos - 1]
pos % 6 = 2 [pos, pos - 1, pos - 2]

So there are at all 4 diffrent cases which is relatively high in performance.


