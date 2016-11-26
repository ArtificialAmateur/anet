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

version='0.2.0'


# Function to display help info
function display_help() {
cat <<'END'
usage: jackal.sh [OPTION]
Jackal Network Monitoring Toolkit.

  -m [MODULE]	runs module of name specified
  -l		list installed modules
  -v 		output version information and exit
  -h 		display this help and exit
END
}

# Function to parse then run modules by name
function run_module() {
	if  [ -a ./modules/$1 ]; then
		./modules/$1
	else echo module not recognized. use jackal.sh -l to list installed modules. >&2
	fi
}

while getopts ":vhm:lt" opt; do
	case $opt in
		v)
			echo "jackal-toolkit version $version";;
		h)
			display_help;;
		m)
			run_module $OPTARG;;
		l)
			echo "Installed modules:"
			ls -1 ./modules/;;
		t)
			run_module test;;
		\?)
			display_help;;
	esac
	did_something=true
done
if [ ! $did_something ]; then display_help; fi
