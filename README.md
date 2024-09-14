# **Lazy Pull**

This script automates the process of pulling changes from multiple Git branches across multiple repositories. It is designed to be flexible and configurable through a configuration file, making it portable and customizable for different environments.

## **Features**

- Automatically pulls changes from multiple branches in multiple repositories.
- Logs pull activity to a specified log file.
- Sends email notifications in case of pull failures (optional).
- Configurable via a simple text configuration file.
- Supports scheduling via cron jobs for automation.

## **Requirements**

- Bash (for running the script).
- Git (for pulling repository changes).
- Cron (for scheduling the script execution).

## **Configuration**

### 1. **Script Configuration**

Update the following paths in the script or provide them as arguments when running the script:

- **Repository Configuration File**: Contains the paths to repositories and branches to pull.
- **Log File**: File to log pull operations.
- **Email Address**: For sending failure notifications (optional).

### 2. **Configuration File**

Create a configuration file (e.g., `config.txt`) with the following format:

```
/path/to/project1,branch1 branch2
/path/to/project2,branch1 branch2
```

Each line represents a repository and its associated branches. The repository path is followed by a comma and a space-separated list of branches.

### 3. **Cron Job**

To automate the script execution, add a cron job. For example, to run the script every minute:

```bash
* * * * * /path/to/auto_pull.sh -c /path/to/config.txt -l /path/to/logs/pull_log.txt -e youremail@example.com
```

## **Usage**

1. **Clone the Repository**

```bash
git clone <your-repo-url>
```

2. **Make the Script Executable**

```bash
chmod +x /path/to/auto_pull.sh
```

3. **Run the Script Manually**

To run the script manually with your configuration file, log file, and email:

```bash
/path/to/auto_pull.sh -c /path/to/config.txt -l /path/to/logs/pull_log.txt -e youremail@example.com
```

### **Command-Line Options**

- `-c`: Path to the configuration file with repository and branch information.
- `-l`: Path to the log file where pull activity will be recorded.
- `-e`: Email address for notifications in case of failure.

### **Example**

```bash
/home/me/www/workspace/auto/auto_pull.sh -c /home/me/www/workspace/auto/config.txt -l /home/me/www/ayush/workspace/logs/pull_log.txt -e youremail@gmail.com
```

## **Setting Up Cron**

1. Open the cron job editor:

```bash
crontab -e
```

2. Add the following line to schedule the script (this example runs the script every minute):

```bash
* * * * * /home/me/www/workspace/auto/auto_pull.sh -c /home/me/www/workspace/auto/config.txt -l /home/me/www/workspace/logs/pull_log.txt -e youremail@gmail.com
```

3. Save the crontab file and exit.

## **Logging**

The script logs all pull activities to the specified log file. It includes:

- Timestamps for each operation.
- Success or failure messages for branch pulls.
- Any errors encountered during the process.

## **Email Notifications**

The script can send email notifications if a Git pull operation fails. To enable this, ensure that your machine is configured to send emails (e.g., using `mail` or another email service).

## **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
