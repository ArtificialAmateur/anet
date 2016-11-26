#!/bin/bash

#########################

# Jackal Network Monitoring Toolkit
# @ArtificialAmateur && @MrOctantis

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

function display_help() {
cat <<'END'
usage: jackal-toolkit [OPTION]
Jackal Network Monitoring Toolkit.

  -v 		output version information and exit
  -h 		display this help and exit
END
}

version='0.0.7'
while getopts ":vh" opt; do
	case $opt in
		v)
			echo "jackal-toolkit version $version";;
		h)
			display_help;;
		\?)
			display_help;;
	esac
	did_something=true
done
if [ ! $did_something ]; then display_help; fi
