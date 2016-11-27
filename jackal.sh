#!/bin/bash

#########################

# Jackal Network Monitoring Toolkit
# @ArtificialAmateur && @MrOctantis

#########################


#-|-------------- Launcher --------------|-
function launcher(){
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
}

version='0.4.1'


# Function to display help info
function display_help() {
cat <<'END'
usage: jackal.sh [OPTION]
Jackal Network Monitoring Toolkit.

  -m, --module [MODULE]	runs module of name specified
  -l, --list		list installed modules
  -v, --version		output version information and exit
  -h, --help		display this help and exit
END
}

# Function to parse then run modules by name
function run_module() {
	if  [ -a ./modules/$1 ]; then
		launcher;
		./modules/$1
	else echo module not recognized. use jackal.sh --list to list installed modules. >&2
	fi
}

OPTS='getopt -o vhm:lt --long version,help,module,list-modules,test -n 'parse-options' -- "$@"'
if [ $? != 0 ]; then echo "Failed parsing options." >&2; exit 1; fi

while true; do
	case "$1" in
		-v | --version) echo "jackal-toolkit version $version"; did_something=true; shift;;
		-h | --help)	display_help; did_something=true; shift;;
		-m | --module)	if [ -n $2 ]; then run_module $2;
				else echo "Module was not recognized. Try jackal.sh --list to list installed modules."
				fi
				did_something=true; shift;;
		-l | --list)	echo "Installed modules:"; ls -1 ./modules/; did_something=true; shift;;
		-t | --test)	run_module test; did_something=true; shift;;
		--)		shift; break;;
		*)		break;;
	esac
done

if [ ! $did_something ]; then display_help; fi
