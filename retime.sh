HELP="
NAME
    retime - set the mtime of directory to that of its content

USAGE
    retime [OPTIONS] DIRECTORY

DESCRIPTION

    Interactively set the modification time of the directory to
    that of the last modified file inside this directory.

OPTIONS
    -h  This help.
    -f  Force noninteractive mode.

SEE ALSO
    mtime -h

VERSION
    $PACKAGE-$VERSION$SUBVERSION $AUTHOR built $BUILT
"
for a in "$@"; do if [[ $a = -h ]]; then echo "$HELP"; exit; fi; done

argv=("$@")
for((i=0;i<$#;i++)); do if [[ ${argv[i]} = -f ]];  then FORCE=1;        argv[i]=""; break; fi; done
for((i=0;i<$#;i++)); do if [[ ${argv[i]} != "" ]]; then DIR=${argv[i]}; argv[i]=""; break; fi; done

# forced mode
if test "$FORCE"; then
  if test ! -d "$DIR"; then exit; fi
  LAST=`find "$DIR" -type f -exec stat -c "%y %n" {} + 2>/dev/null | sort | tail -n 1 | sed 's:\.[0-9][0-9]* +[0-9]* .*$::'`
  touch -d "$LAST" "$DIR"
  exit
fi

# regular mode
if test "x$DIR" = "x"; then echo "no directory specified";  exit; fi
if test ! -e "$DIR";   then echo "$DIR doesn't exist";      exit; fi
if test ! -d "$DIR";   then echo "$DIR is not a directory"; exit; fi

LIST=`find "$DIR" -type f -exec stat -c "%y %n" {} + 2>/dev/null | sort`
HEAD=`echo "$LIST" | head -n 2 | sed 's:\.[0-9][0-9]* +[0-9]* \(\./\)\?: :'`
TAIL=`echo "$LIST" | tail -n +3 | tail -n 4 | sed 's:\.[0-9][0-9]* +[0-9]* \(\./\)\?: :'`
LAST=`echo "$LIST" | tail -n 1 | sed 's:\.[0-9][0-9]* +[0-9]* .*$::'`

echo "$HEAD"
if [[ "$TAIL" != "" ]]; then
  echo "                    ..."
  echo "$TAIL"; fi
echo "--------------------------------------"

# test Yes/no with exit
function ytest {
  yes="?"
  while test $yes = "?"; do
    read -n1 ans
    case $ans in
      y) echo; yes=1;;
      Y) echo; yes=1;;
     "")       yes=1;;
      n) printf "\nnothing done...\n"; exit 0;;
      N) printf "\nnothing done...\n"; exit 0;;
      q) printf "\nnothing done...\n"; exit 0;;
      *) ;;
    esac
  done; }

MAIN=`stat -c "%y %n" "$DIR" | sed 's:\.[0-9][0-9]* +[0-9]* \(\./\)\?: :'`
FROM=`stat -c "%y" "$DIR" | sed 's:\..*$::'`

if [[ "$FROM" = "$LAST" ]]; then echo "Directory already has the mtime of its content."; exit; fi

echo "$FROM $DIR directory"
echo -n "$LAST last mtime <- Retime to this? (Y/n) "
ytest

touch -d "$LAST" "$DIR"
stat -c "%y %n" "$DIR" | sed 's:\.[0-9][0-9]* +[0-9]* \(\./\)\?: :'

# R.Jaksa 2024 GPLv3
