# ReputationChecker
This repository consists of a number of prebuilt scripts for checking the reputation of a hash through static analysis by using a variety of reputation databases. 

## Wildfire_Reputation_Checker

### Caution

This script will make a curl request using your API key for every unique hash listed in the input file. This may cause rate limiting or exceeding your daily/weekly/monthly quota for submissions to the /get/verdicts API. Be sure to identify where your cap is, and count the number of hashes you plan to check the reputation of. 

### Usage

Adjust the input file path, located in the first grep command, to a txt file containing a list of hashes. This list *can* contain duplicates, as the script will dedupe the hashes in order to avoid rate limiting. 

```
grep -o -E '\b[0-9a-fA-F]\{64\}\b' </home/username/example.txt> | sort -u > uniquehashes.txt
```

### Verdicts 

The wildfire reputation checker utalizes a curl request to the get/verdicts API. It responds with an analysis of clean, malicious or unknown, however it will also output a verdict code for a more detailed description of the anaylsis. 
These verdict codes can be explained as below:

```
0 : hash is known benign 
1 : hash is known malware
2 : hash is assocaited to grayware
-100 : Hash is in database, but a verdict is still pending
-101 : There was an error with the hash (not an invalid hash*)
-102 : hash is not in reputation database, hash is unknown
-103 : hash value is invalid
```
