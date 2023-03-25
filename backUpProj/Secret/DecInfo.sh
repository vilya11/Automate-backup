DEFAULT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

decrypted_data=$(openssl enc -aes-256-cbc -d -in "$DEFAULT_DIR"/secretKey.enc -k 1234)

# Use while loo to iterate and store the decrypted data in an array
declare -a decrypted_array=()
while IFS= read -r line; do
    decrypted_array+=("$line")
done <<< "$decrypted_data"

declare -A obj_array

for element in "${decrypted_array[@]}"; do
    # Extract the key and value from the element
    key=$(echo "$element" | cut -d "=" -f 1)
    value=$(echo "$element" | cut -d "=" -f 2)

    # Assign the value to the key in the obj_array
    obj_array["$key"]=$value
done



# Export the array so it can be used in other scripts
export "decrypted_array" "obj_array"