# Batch User Account Creation Script for MyComp

This project contains a Bash script that automates the creation of 100 user accounts for a batch of fresh engineers joining the company "MyComp." The script handles account creation, password management, home directory setup, and password expiration notifications.

## Features

- **User Account Creation**: Creates 100 users with usernames in the format `mycompusr1`, `mycompusr2`, ..., `mycompusr100`.
- **Home Directory Setup**: Each user has a corresponding home directory in `/home/mycompusr1`, `/home/mycompusr2`, etc.
- **Password Setup**: The initial password for each user is set to the username itself (e.g., the password for `mycompusr1` is `mycompusr1`).
- **Permissions**: Home directories are configured with `700` permissions, granting only the user full access.
- **Group Membership**: All users are added to the `wheel` group, giving them administrative privileges.
- **Password Expiration**: Passwords are configured to expire every 30 days.
- **Password Expiration Notification**: A mechanism to notify users when their passwords are expiring, with a warning 7 days before expiration.

## Files

- `create_users.sh`: The main Bash script for user account creation and configuration.
- `check_password_expiry.sh`: A helper script that logs notifications for users whose passwords are expiring soon.
- `cronjob`: A cron job to schedule daily checks for password expiration.

## Prerequisites

Ensure you have the following:

- Linux system with `useradd`, `chpasswd`, and `chage` commands available.
- Root or administrative privileges to create users and set up cron jobs.

## How to Use

1. Clone this repository to your server:
   ```bash
   git clone https://github.com/your-username/batch-user-creation-mycomp.git
   cd batch-user-creation-mycomp
