#!/bin/bash

#Author: Shakib khan
#Description: This is just looking good interface tool is tool is created by chatgpt 

# Check if the input file argument is provided
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <urls.txt>"
  exit 1
fi

# File containing URLs, one per line
url_file="$1"

# Check if the URL file exists
if [[ ! -f $url_file ]]; then
  echo "File $url_file not found!"
  exit 1
fi

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Read URLs from the file and process each one
while IFS= read -r url; do
  # Check if the URL is not empty
  if [[ -z "$url" ]]; then
    continue
  fi

  # Send HTTP request to the URL and get the HTTP status code
  response=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  # Get the IP address of the URL
  ip=$(dig +short $(echo $url | awk -F/ '{print $3}') | tail -n1)

  # Set color based on the response code
  if [[ $response =~ ^2 ]]; then
    color=$GREEN
  else
    color=$RED
  fi

  # Output the URL, response code, and IP address
  echo -e "URL: $url"
  echo -e "Response Code: ${color}$response${NC}"
  echo -e "IP Address: $ip"

  # Check if the response code indicates success (2xx)
  if [[ $response =~ ^2 ]]; then
    echo -e "${color}Request was successful.${NC}"
  else
    echo -e "${color}Request failed.${NC}"
  fi

  echo "----------------------------------------"

done < "$url_file"
