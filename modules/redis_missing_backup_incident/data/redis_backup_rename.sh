bash

#!/bin/bash



# Stop the Redis service

sudo systemctl stop redis



# Rename the existing backup file

sudo mv ${REDIS_BACKUP_FILE} ${REDIS_BACKUP_FILE}.bak



# Force Redis to generate a new backup file

sudo redis-cli save



# Start the Redis service

sudo systemctl start redis