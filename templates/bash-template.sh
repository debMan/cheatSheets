#!/usr/bin/env bash 

# DESCRIPTION:
# This is the description, which describes the proper OS and other conditions.
# Start comments with double hash ## for main topics and groups or functions
# Start comments with single hash # for description
# Start human-language comments with a space after hash mark
# Start comments here in DESCRIPTION Capital case, but in the body of code, use
# small-case anywhere ! This is my convention.
# Add double new line between any sections.
#
# AUTHOR: debman
#
# VERSIONS: 
# v0.1.1 at 19 Sep 2020 15:26:53 +0430 debman
# asome other changes
# v0.1.0 at 18 Sep 2020 15:00:00 +0430 debman
# write some chane log of the version a line below of that


set -euo pipefail


## set variables
VERSION="v0.1.1 19 Sep 2020 by debman"
LICENSE="
###############################################################################
#  Copyright (C) 2007, 2020 debman (MohamadAli Rezaie)                        #
#  LinuxGeek46@both.org                                                       #
#                                                                             #
#  This program is free software; you can redistribute it and/or modify       #
#  it under the terms of the GNU General Public License as published by       #
#  the Free Software Foundation; either version 2 of the License, or          #
#  (at your option) any later version.                                        #
#                                                                             #
#  This program is distributed in the hope that it will be useful,            #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#  GNU General Public License for more details.                               #
#                                                                             #
#  You should have received a copy of the GNU General Public License          #
#  along with this program; if not, write to the Free Software                #
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  #
###############################################################################
"
SOME_VAR=${SOME_VAR:="value"}


## initial functioons
# help function
help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: bash-script.sh [-g|h|v|V]"
   echo "options:"
   echo "-l     Print the GPL license notification."
   echo "-h     Print this Help."
   echo "-v     Verbose mode."
   echo "-V     Print software version and exit."
   echo
}
# version function
version()
{
  echo $VERSION
}
# license function
license()
{
  cat <<< $LICENSE
}


## main program
while getopts ":hVl" option; do
  case $option in
    h) # display Help
      help
      exit;;
    V) # display version
      version
      exit;;
    l) # display license
      license
      exit;;
    \?) # incorrect option
      echo "Error: Invalid option"
      exit;;
  esac
done
# https://opensource.com/article/19/12/help-bash-program

