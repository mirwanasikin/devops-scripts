#!/bin/bash

# Simple backup script
# Author: Tenka Asikin
# to run type: ./backup.sh -s /source/path/ -d /goals/ 

guide () {
	cat << EOF
usage: $0 -s $SOURCE -d $DEST [-f]

options:
-s	: Source directory
-d	: Destiny directory
-f	: Force dry ru
-h	: Show guide
EOF
	exit 1
}

SOURCE=""
DEST=""
DRY_RUN="--dry-run"

# --- validate ---
while getopts ":s:d:fh" opt; do
	case "$opt" in
		s) SOURCE="$OPTARG" ;;
		d) DEST="$OPTARG" ;;
		f) DRY_RUN="" ;;
		h) guide ;;
		\?) guide ;;
	esac
done

[[ -z "$SOURCE" || -z "$DEST" ]] && guide
[[ ! -d "$SOURCE" ]] && { echo "Source not found"; exit 1; }
[[ ! -d "$DEST" ]] && { echo "Destiny not found"; exit 1; }

# --- safety net ---

[[ "$SOURCE" == "/" || "$DEST" == "/" ]] && {
	echo "Root are not Allowed"
	exit 1
}

# --- backup start ---

SOURCE="${SOURCE%/}/"

echo "Source	: $SOURCE"
echo "Destiny	: $DEST"
echo "Mode	: ${DRY_RUN:-LIVE RUN}"
echo

rsync -avh --delete $DRY_RUN "$SOURCE" "$DEST"
exit 0
