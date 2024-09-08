HELP="
NAME
    mtime - list files according to their modification time

USAGE
    mtime [OPTIONS] [DIRECTORY/FILE]...

DESCRIPTION
    Look for files recursively.  If DIRECTORY/FILE is not specified
    use the current working directory.  Print the modification time
    and filename.

OPTIONS
    -h  This help.

SEE ALSO
    retime -h

VERSION
    $PACKAGE-$VERSION$SUBVERSION $AUTHOR built $BUILT
"
if test "x$1" = "x-h"; then echo "$HELP"; exit; fi

find "$@" -type f -exec stat -c "%y %n" {} + 2>/dev/null | sort | sed 's:\.[0-9][0-9]* +[0-9]* \(\./\)\?: :' 

# R.Jaksa 2024 GPLv3
