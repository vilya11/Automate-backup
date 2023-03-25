#!/bin/bash

#section ones
# Set default directory to the location of the script 
DEFAULT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Your Default Dir is: " $DEFAULT_DIR
# Define array of file extension to be backup
file_extensions=(txt doc ppt sh)

echo "There are such file like: " $file_extensions

# Get the current date in YYYY-MM-DD format
current_date=$(date +%Y-%m-%d)


# Create the backup directories for each file extension
backup_dir=${DEFAULT_DIR}/backUp_${current_date}
mkdir "$backup_dir"
for ext in "${file_extensions[@]}"
do
    mkdir "${backup_dir}/${ext}"
done

# Copy files to their respective backup directories
for ext in "${file_extensions[@]}"
do
    cp "$DEFAULT_DIR"/*."${ext}" "${backup_dir}/${ext}/"
done


# Zip each backup directory
for ext in "${file_extensions[@]}"
do
    zip -r "${backup_dir}/${ext}.zip" "${backup_dir}/${ext}"
done

# Combine all zip files into one
zip_file=${DEFAULT_DIR}/backup_${current_date}.zip
zip -j "${zip_file}" "${backup_dir}"/*.zip

./backup_transfer.sh "$zip_file" "$current_date" "$DEFAULT_DIR" "$backup_dir"
