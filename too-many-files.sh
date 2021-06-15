#!/bin/bash
# writted by george x6025
# this moves too many files in one directory to subdirectories, evenly dispersing them by the $RADIX
#
# to be fed list of filenames as the first argument to this script, eg: too-many-files.sh filenames.txt
# get filenames using find. eg: find /path/to/files -maxdepth 1 -type f > filenames.txt

# change as required:
RADIX=1000 		# Number of files to each folder
UPDATE_INTERVAL=50 	# update every n'th file-move

# Don't touch / be careful:
file_counter=0
files_total=$(wc -l "$1" | awk '{print $1}') #line-count from input (input is first argument i.e. $1)
folder_counter=0
IMAGEPATH=$(head -1 "$1" | cut -d / -f 8 --complement) # get rid of filename.ext but keep the rest, i.e. FROM /path/to/file/file.txt TO: /path/to/file
ZEROS=$(( ${#files_total} - (( ${#RADIX} - 1)) )) # number of preceding zeros for foldername. Will be a Natural Number eg {1,2,3,...}
printf_format="%0${ZEROS}d" # eg: '%02d'

echo "There's $files_total files, so $(( (( $files_total / $RADIX )) + 1 )) folders ($RADIX files in each)" # Why +1? int division is = floor(num/divisor)
echo "To ensure proper sort-order folders need to have $ZEROS tens positions, therefore:"
echo "printf_format: ${printf_format}"
echo 

# ITERATE THROUGH EACH LINE OF INPUT
while read -r line ; do
	# CREATE NEW FOLDER EVERY RADIX'TH FILE
	if ! (( $file_counter % RADIX )); then
		newdir="$IMAGEPATH/folder-$(printf $printf_format $folder_counter)"
		mkdir "$newdir"
		echo "created $newdir"
		let folder_counter++
	fi

	# MOVE INDIVIDUAL FILE
	mv "$line" "$newdir"
	let file_counter++
	percent=$(( $file_counter * 100 / $files_total ))

	# UPDATE STATUS
	if ! (( $file_counter % $UPDATE_INTERVAL )); then
		# DISPLAY PERCENTAGE ON CHANGE
		if ! [[ $file_counter -eq 1 ]] && ! [[ $percent_previously_shown -eq $percent ]] ; then # if not first iteration && percentage increased (! first time bc $percent_previously_shown wouldn't exist). BASICALLY IF % HAS CHANGED
			echo "files moved: $file_counter (${percent}% done)"
			percent_previously_shown=$(( $file_counter * 100 / $files_total ))
		else
			echo "files moved: $file_counter"
		fi
	fi
done < "$1"
echo "files moved: $file_counter (${percent}% done)" #final output
