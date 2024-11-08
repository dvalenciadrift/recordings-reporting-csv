# Recordings Report CSV
Shell scripts that generate a CSV report from the Conversations Recordings from a Salesloft Org.

## How to use it

Clone the repo

`git clone https://github.com/dvalenciadrift/recordings-reporting-csv.git`

Enter the folder

`cd recordings-reporting-csv`

Run the script

`./report.sh`

You may need to change the file permissions to execute it

`chmod +x report.sh`

Finally, answer the prompts, including a valid `api_token`

A CSV file will be generated in the same folder. In case it fails, try using shorter date ranges.