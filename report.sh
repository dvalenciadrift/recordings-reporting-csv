#!/bin/bash

# Prompts to get filter values
echo "Initial date (YYYY-MM-DD):"
read initial_date

echo "Final date (YYYY-MM-DD):"
read final_date

echo "Enter API Token:"
read api_token

# Initialize variables for pagination
page=1
all_data=""

# Add CSV header
all_data="Id,Title,Event Start Date,Account Id,Media Type,Duration in ms,Owner Id"

# Loop to fetch all pages
while true; do
    api_endpoint="https://api.salesloft.com/v2/conversations?created_at%5Blte%5D=$final_date&created_at%5Bgte%5D=$initial_date&per_page=100&page=$page"

    #Print the API endpoint - Using this for Debugging
    echo "API Endpoint: $api_endpoint"

    # curl request using the entered values
    response=$(curl -s -o response.json -w "%{http_code}" -X GET "$api_endpoint" -H "Authorization: Bearer $api_token")

    # Check if curl request was successful
    if [ -z "$response" ] || [ "$response" -ne 200 ]; then
        echo "Error: Unable to fetch data from the API. HTTP Status Code: $response"
        rm -f response.json 
        exit 1
    fi

    # Use jq to extract fields from JSON and format it to CSV
    # You can check if you have jq installed by running in your terminal "jq --version"
    csv_data=$(jq -r '.data | map([.id, .title, .event_start_date, .account.id, .media_type, .duration, .owner_id]) | .[] | @csv' response.json)

    # Append new data to all_data
    all_data+=$'\n'"$csv_data"  # Append new data to all_data

    # Check if there is a next page
    next_page=$(jq -r '.metadata.paging.next_page' response.json)
    if [ "$next_page" == "null" ]; then
        break 
    fi
    page=$next_page 
done

# Save all CSV data to a file - You can change the name of the report.
output_file="report.csv"
echo "$all_data" > "$output_file" 

rm response.json

echo "CSV file has been generated and saved as $output_file."