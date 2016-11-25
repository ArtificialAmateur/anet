#! /bin/bash

#########################

# Jackal Network Monitoring Toolkit
# @ArtificialAmateur
# v .07

#########################


#-|-------------- Launcher --------------|-

cat <<'END'

    ___   ________   ________   ___  __     ________   ___          
   |\  \ |\   __  \ |\   ____\ |\  \|\  \  |\   __  \ |\  \         
   \ \  \\ \  \|\  \\ \  \___| \ \  \/  /|_\ \  \|\  \\ \  \        
 __ \ \  \\ \   __  \\ \  \     \ \   ___  \\ \   __  \\ \  \       
|\  \\_\  \\ \  \ \  \\ \  \____ \ \  \\ \  \\ \  \ \  \\ \  \____  
\ \________\\ \__\ \__\\ \_______\\ \__\\ \__\\ \__\ \__\\ \_______\
 \|________| \|__|\|__| \|_______| \|__| \|__| \|__|\|__| \|_______|
                                                                    
          .                                                      .
        .n                   .                 .                  n.
  .   .dP                  dP                   9b                 9b.    .
 4    qXb         .	  dX                     Xb	  .        dXp     t
dX.    9Xb	.dXb    __                         __    dXb.     dXP     .Xb
9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP
 9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP
  `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'
    `9XXXXXXXXXXXP' `9XX'   DIE    `98v8P'  HUMAN   `XXP' `9XXXXXXXXXXXP'
        ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~
                        )b.  .dbo.dP'`v'`9b.odb.  .dX(
                      ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.
                     dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb
                    dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb
                    9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP
                     `'      9XXXXXX(   )XXXXXXP      `'
                              XXXX X.`v'.X XXXX
                              XP^X'`b   d'`X^XX
                              X. 9  `   '  P )X
                              `b  `       '  d'
                               `             '
END

while true; do
echo $'\n[?] What module would you like to launch?' 
echo $'  1) Category 1 \n  2) Category 2 \n  3) Category 3' 
read modulec
     case "$modulec" in
       1 ) modules/foobar1.sh;;
       2 ) modules/foobar2.sh;;
       3 ) modules/foobar3.sh;;
       * )  echo $'[-] Quitting script.\n' && break;;
     esac 
done
