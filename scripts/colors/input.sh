
# Reset
Color_Off='\x1B[0m'       # Text Reset

# Regular Colors
Black='\x1B[0;30m'        # Black
Red='\x1B[0;31m'          # Red
Green='\x1B[0;32m'        # Green
Yellow='\x1B[0;33m'       # Yellow
Blue='\x1B[0;34m'         # Blue
Purple='\x1B[0;35m'       # Purple
Cyan='\x1B[0;36m'         # Cyan
White='\x1B[0;37m'        # White

# Bold
BBlack='\x1B[1;30m'       # Black
BRed='\x1B[1;31m'         # Red
BGreen='\x1B[1;32m'       # Green
BYellow='\x1B[1;33m'      # Yellow
BBlue='\x1B[1;34m'        # Blue
BPurple='\x1B[1;35m'      # Purple
BCyan='\x1B[1;36m'        # Cyan
BWhite='\x1B[1;37m'       # White

# Underline
UBlack='\x1B[4;30m'       # Black
URed='\x1B[4;31m'         # Red
UGreen='\x1B[4;32m'       # Green
UYellow='\x1B[4;33m'      # Yellow
UBlue='\x1B[4;34m'        # Blue
UPurple='\x1B[4;35m'      # Purple
UCyan='\x1B[4;36m'        # Cyan
UWhite='\x1B[4;37m'       # White

# High Intensity
IBlack='\x1B[0;90m'       # Black
IRed='\x1B[0;91m'         # Red
IGreen='\x1B[0;92m'       # Green
IYellow='\x1B[0;93m'      # Yellow
IBlue='\x1B[0;94m'        # Blue
IPurple='\x1B[0;95m'      # Purple
ICyan='\x1B[0;96m'        # Cyan
IWhite='\x1B[0;97m'       # White

# Bold High Intensity
BIBlack='\x1B[1;90m'      # Black
BIRed='\x1B[1;91m'        # Red
BIGreen='\x1B[1;92m'      # Green
BIYellow='\x1B[1;93m'     # Yellow
BIBlue='\x1B[1;94m'       # Blue
BIPurple='\x1B[1;95m'     # Purple
BICyan='\x1B[1;96m'       # Cyan
BIWhite='\x1B[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\x1B[0;100m'   # Black
On_IRed='\x1B[0;101m'     # Red
On_IGreen='\x1B[0;102m'   # Green
On_IYellow='\x1B[0;103m'  # Yellow
On_IBlue='\x1B[0;104m'    # Blue
On_IPurple='\x1B[0;105m'  # Purple
On_ICyan='\x1B[0;106m'    # Cyan
On_IWhite='\x1B[0;107m'   # White

# Background
On_Black='\x1B[40m'       # Black
On_Red='\x1B[41m'         # Red
On_Green='\x1B[42m'       # Green
On_Yellow='\x1B[43m'      # Yellow
On_Blue='\x1B[44m'        # Blue
On_Purple='\x1B[45m'      # Purple
On_Cyan='\x1B[46m'        # Cyan
On_White='\x1B[47m'       # White

echo -e "------------------------------ ~~~\o/~~~~ ------------------------------"

echo -n "Name [tacotruck]: "
read input_a
if [ -z "$input_a" ]; then
   HOSTNAME='tacotruck'
else
   HOSTNAME="$input_a"
fi

echo -en "${On_Red} R ${Color_Off} ${On_Green} G ${Color_Off} ${On_Blue} B ${Color_Off} [B]: "
read input_a
if [ "$input_a" == 'R' -o "$input_a" == 'r' ]; then
   BACK='\e[41m'
elif [ "$input_a" == 'G' -o "$input_a" == 'g' ]; then
   BACK='\e[42m'
else
   BACK='\e[44m'
fi

echo -en "$BACK $HOSTNAME $Color_Off"
