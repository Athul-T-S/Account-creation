#!/bin/bash

# Define the range of users to be created
START=1
END=100

# Loop through the range and create users
for i in $(seq $START $END)
do
    # Define the username
    USERNAME="mycompusr$i"

    # Create the user with the specified home directory and add to the wheel group
    useradd -m -d /home/$USERNAME -G wheel $USERNAME

    # Set the password to the username
    echo "$USERNAME:$USERNAME" | chpasswd

    # Set the permissions for the home directory
    chmod 700 /home/$USERNAME

    # Set the password to expire every month (30 days)
    chage -M 30 $USERNAME
done

# Implement the password expiration notification
# Create a script to check for expiring passwords and log notifications
cat << 'EOF' > /usr/local/bin/check_password_expiry.sh
#!/bin/bash
# Get today's date in seconds since epoch
TODAY=$(date +%s)
# Log file for password expiry notifications
LOG_FILE="/var/log/password_expiry_notifications.log"
# Iterate over all users
for USER in $(getent passwd | cut -d: -f1)
do
    # Skip system users (with UID < 1000)
    if [ $(id -u $USER) -lt 1000 ]; then
        continue
    fi

    # Get the date of the last password change
    LAST_CHANGE=$(chage -l $USER | grep "Last password change" | cut -d: -f2)
    LAST_CHANGE_DATE=$(date -d "$LAST_CHANGE" +%s)

    # Calculate the difference in days between today and the last password change
    DIFF_DAYS=$(( (TODAY - LAST_CHANGE_DATE) / (60*60*24) ))

    # Get the maximum number of days the password is valid
    MAX_DAYS=$(chage -l $USER | grep "Maximum number of days" | cut -d: -f2)

    # Calculate the days left until password expiry
    DAYS_LEFT=$((MAX_DAYS - DIFF_DAYS))

    # If the password is expiring within the next 7 days, log the notification
    if [ $DAYS_LEFT -le 7 ]; then
        echo "$(date): Your password for user $USER will expire in $DAYS_LEFT days. Please change it soon." >> $LOG_FILE
    fi
done
EOF

# Make the script executable
chmod +x /usr/local/bin/check_password_expiry.sh

# Schedule the password expiry check to run daily using cron
(crontab -l 2>/dev/null; echo "0 0 * * * /usr/local/bin/check_password_expiry.sh") | crontab -

echo "User accounts created and configured successfully."
echo "Password expiration notifications will be logged to /var/log/password_expiry_notifications.log."


