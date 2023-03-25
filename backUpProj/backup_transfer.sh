#!/bin/bash
source ./Secret/DecInfo.sh
#section two
# Set the remote server address
remote_user=${obj_array["remote_user"]}
remote_dir=${obj_array["remote_dir"]}
remote_pass=${obj_array["remote_pass"]}
echo "current Date: " $2
echo "Default Dir: " $3
#section three
# Set the encrypted backup file name

encrypted_filename=backup_${2}.zip.enc
encrypted_file=${3}/${encrypted_filename}
if [ -f "$1" ]; then 
    echo "Successfully created zip file: $1"

    # Encrypt the backup file with OpenSSL
    openssl enc -aes-256-cbc -md sha256 -in "$1" -out "$encrypted_file" -pass pass:mysecretpassword

    # Send a telegram to notify that the backup is complete
    curl "https://api.telegram.org/$(echo ${obj_array["tokenKey"]} | sed 's/^"\(.*\)"$/\1/')/sendMessage?chat_id=$(echo ${obj_array["chat_id"]} | sed 's/^"\(.*\)"$/\1/')&text=BackUpComplete"
    # Send the encrypted backup file to the Telegram group
    curl_output=$(curl -F document=@$encrypted_file "https://api.telegram.org/$(echo ${obj_array["tokenKey"]} | sed 's/^"\(.*\)"$/\1/')/sendDocument?chat_id=$(echo ${obj_array["chat_id"]} | sed 's/^"\(.*\)"$/\1/')")

    if [[ "$curl_output" == *"error"* ]]; then
      echo "Error: ${curl_output}"
      exit 1
    fi
    # Send the encrypted backup file to the remote server using scp
    sshpass -p $remote_pass scp $encrypted_file "${remote_user}:${remote_dir}"
    # sshpass -p "1234" scp mytext.txt vilya@10.10.49.42:/home/vilya/test/
else
    echo "Failed to create zip file: $zip_file"
    curl "https://api.telegram.org/$(echo ${obj_array["tokenKey"]} | sed 's/^"\(.*\)"$/\1/')/sendMessage?chat_id=$(echo ${obj_array["chat_id"]} | sed 's/^"\(.*\)"$/\1/')&text=BackUp-Failed"
fi


# Check whether the file exists on the remote server
USE_IP="-o StrictHostKeyChecking=no ${remote_user}"
FILE_NAME="${remote_dir}/${encrypted_filename}"
SSH_PASS="sshpass -p $remote_pass"


if $SSH_PASS ssh $USE_IP stat $FILE_NAME > /dev/null 2>&1
then
  # Send a telegram to notify that the backup has been sent to the remote server
  curl "https://api.telegram.org/$(echo ${obj_array["tokenKey"]} | sed 's/^"\(.*\)"$/\1/')/sendMessage?chat_id=$(echo ${obj_array["chat_id"]} | sed 's/^"\(.*\)"$/\1/')&text=file-has-been-sent-to-remote-server"
  echo "File exists"
else
  echo "File doesn't exist"
  curl "https://api.telegram.org/$(echo ${obj_array["tokenKey"]} | sed 's/^"\(.*\)"$/\1/')/sendMessage?chat_id=$(echo ${obj_array["chat_id"]} | sed 's/^"\(.*\)"$/\1/')&text=file-hasn't-been-sent-to-remote-server"

fi

# Remove the temporary backup directories and zip files
rm -rf "$4"
rm "$1"
rm "${encrypted_file}"