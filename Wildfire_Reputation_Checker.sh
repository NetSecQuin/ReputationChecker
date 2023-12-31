# This script is to be used with an active Wildfire API key. Rate limits may apply depending on your license/subscription therefore be careful running this script against large datasets all at once. 

# List the input file by changing this path to a txt file that contains a list of sha256 hashes. 
# First thing we do is to dedupe any duplciate hases in order to reduce the chances of being rate limited. 
grep -o -E '\b[0-9a-fA-F]\{64\}\b' </home/username/example.txt> | sort -u > uniquehashes.txt
uniquehashes=uniquehashes.txt

#read in each hash in the file through a while loop
while IFS= read -r hash
do

    #Curl request with your API key to the wildfire get/verdicts API
    echo "Checking the SHA256 Has: "$hash
    xml_output=$(curl -f "hash-$hash" -F 'apikey=<API_KEY>' -F 'format=xml' 'http://wildire.paloaltonetworks.com/publicapi/get/verdicts'

    # Extract the <verdict> value from the XML content in the curl response
    verdict=$(echo "$xml_output" | grep -oP '<verdict>\K[^<]+')


    # Check the value assocaited to the verdict field
    if [ "$verdict" -eq 0 ]; then
      echo "Hash was identified as clean. Verdict Code: "$verdict
      echo $hash >> cleanhashes.txt
    elif [ "$verdict" -eq -100 ] || [ "$verdict" -eq -101 ] || [ "$verdict" -eq -102 ] || [ "$verdict" -eq -103 ]; then
      echo "Hash was not found in Wildfire database, unknown verdict. Verdict Code: "$verdict
      echo $hash >> unknownhashes.txt
    else
      echo "Hash was identifeid as malcious. Verdict Code: "$verdict
      echo $hash >> malicioushashes.txt
    fi
done < "$uniquehashes"
