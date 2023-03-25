#!/bin/bash
DEFAULT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$DEFAULT_DIR"/DecInfo.sh

for key in "${!obj_array[@]}"; do
    echo "$key=${obj_array[$key]}"
done

echo ${obj_array["remote_user"]}


# Access elements of the array
# echo "First element: ${decrypted_array[0]}"
# echo "Second element: ${decrypted_array[1]}"
# echo "Third element: ${decrypted_array[2]}"
