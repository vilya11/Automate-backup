source ./Secret/DecInfo.sh
#section two
# Set the remote server address
remote_user=${obj_array["remote_user"]}
remote_dir=${obj_array["remote_dir"]}
remote_pass=${obj_array["remote_pass"]}

echo $(echo ${obj_array["chat_id"]} | sed 's/^"\(.*\)"$/\1/')

my_string='"Hello, World!"'
cleaned_string=$(echo ${obj_array["tokenKey"]} | sed 's/^"\(.*\)"$/\1/')
echo $cleaned_string  # Output: Hello, World!