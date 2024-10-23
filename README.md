# Subdomain Scanner using Bash and the crt.sh API

This script is an automated subdomain scanner that uses public data from the crt.sh API to search for subdomains of a given domain. Equipped with parallel search, connectivity checking, and email notification features, this script helps pentesters or security administrators find and verify subdomains quickly and efficiently.

## Key Features:
 * Unique subdomain search using crt.sh API.
 * Connectivity check in parallel with ping.
 * Automatic output to file and statistics of results.
 * Retry handling and error logging.
 * Email notification (optional) for scan results.
 * Automatic subdomain search via crt.sh API.
 * Filtering unique subdomains to avoid duplication.
 * Output to a neatly formattedfile.
 * Automatic logging to keep a log of each execution.
 * Connectivity check (ping) to make sure the subdomain is active or not.
 * Warning notification if the domain or subdomain is not found.
 * Argument parsing to allow the use of arguments from the command line.


## Explanation of New Features:
 1. Parallel Execution:We use parallel to run the ping command simultaneously for up to 10 subdomains at a time. This improves performance if there are many subdomains to scan.
 1. Retry Handling:The --retry 3 option on the curl command ensures the request is repeated up to 3 times in case of failure.
 1. Execution Time Statistics:The script records the start time and end time to provide information on how long the scanning process took.
 1. Email Delivery (Optional):Users can add an email address as the second argument to receive the scan results via email. If the address is not provided, this feature is skipped.
 1. Dependency Handling:The script checks for the presence of all required tools: curl, jq, xargs, parallel, and mail. If one is not found, the script stops and gives an error message.

## Installation Steps
Clone Repository from GitHubFirst, make sure you have Git on your system. If not, install Git:
```
sudo apt update && sudo apt install git -y
```
Clone project repository from GitHub:
```
git clone https://github.com/lamcodeofpwnosec/subdomain-scanner.git
cd subdomain-scanner
```
Make sure Dependencies are Installed
This script requires several tools: `curl`, `jq`, `parallel`, and `mail`. Install all these tools using the following command:
```
sudo apt update
sudo apt install curl jq parallel mailutils -y
```
Grant Execution Permission to Scripts
Change the access rights so that the script can be executed:
```
chmod +x subdomain_scanner.sh
```
## Usage of features
Run without Email Notification
To run the script without sending the results via email:
```
./subdomain_scanner.sh contoh.com
```
Run with Email Notification
Run by sending the scan results to email (for example: `email@example.com`):
```
./subdomain_scanner.sh contoh.com email@example.com
```
Help Options
If you want to see how to use:
```
./subdomain_scanner.sh
```

## Explanation of Generated Output Files
Subdomain List file
Contains a list of unique subdomains found from crt.sh:
```
$ cat contoh.com_subdomains.txt

www.contoh.com
mail.contoh.com
api.contoh.com
```
Connectivity Result File
Contains subdomains that are on or off after being checked with ping:
```
$ connectivity_result.txt

[LIVE] www.contoh.com
[DEAD] api.contoh.com
[LIVE] mail.contoh.com
```
Terminal Statistics
Once the scan is complete, you will see a summary like this:
```
=====================================
     Advanced Subdomain Scanner
=====================================
[+] Memulai pencarian subdomain untuk: contoh.com
[+] Ditemukan 5 subdomain untuk contoh.com.
[+] Memeriksa konektivitas subdomain secara paralel...
[+] 3 subdomain aktif dan 2 subdomain tidak aktif.
[+] Pemindaian selesai dalam waktu 8 detik.
```
## Conclusion
**With these steps, you can easily:**
 * Install dependencies and run scripts.
 * Perform an automated subdomain scan.
 * Save results into a file and check connectivity status.
 * Send reports via `email` for more effective monitoring.

This script is perfect for testers and administrators to enumerate subdomains efficiently. 🚀

&copy; [PT. Pwn0Sec DIGITAL TECHNOLOGIES LTD.](https://www.pwn0sec.com/) 
