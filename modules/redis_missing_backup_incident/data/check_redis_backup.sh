

#!/bin/bash



# Set variables

REDIS_HOST=${REDIS_HOST}

BACKUP_DIR=${BACKUP_DIRECTORY}

BACKUP_FILE=${BACKUP_FILENAME}



# Check Redis connectivity

redis-cli -h $REDIS_HOST ping >/dev/null 2>&1

if [ $? -ne 0 ]; then

    echo "ERROR: Could not connect to Redis at $REDIS_HOST"

    exit 1

fi



# Check backup directory exists

if [ ! -d "$BACKUP_DIR" ]; then

    echo "ERROR: Backup directory $BACKUP_DIR does not exist"

    exit 1

fi



# Check backup file exists

if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then

    echo "ERROR: Backup file $BACKUP_DIR/$BACKUP_FILE does not exist"

    exit 1

fi



echo "SUCCESS: Redis backup at $BACKUP_DIR/$BACKUP_FILE is present"

exit 0