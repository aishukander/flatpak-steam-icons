# flatpak-steam-icons
Simple shell script to extract desktop icons from Flatpak directory and build functional icons on the Desktop.

The script will provide a list of games with generated icons alongside their corresponding `ID`. 
Then, the script will request an `ID` from the user.
Lastly, the script will find the highest resolution icon available from steam and parse an executable for your game. (Desktop entry will also automatically be granted "trusted executable" permissions) 

Bonus icon included to pair with a `.desktop` file of your own, that you may chose to use to trigger this script. (Sourced from `pictogrammers.com`)
