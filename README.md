
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Redis missing backup incident.
---

The Redis missing backup incident refers to a situation where Redis, a popular in-memory data structure store, has not been backed up for a certain period of time. This could lead to data loss or corruption in the event of a system failure or other issues. The incident typically requires immediate attention to ensure that the data is properly backed up and that any potential issues are resolved quickly to avoid further complications.

### Parameters
```shell
export PATH_TO_REDIS_RDB="PLACEHOLDER"

export REDIS_HOST="PLACEHOLDER"

export BACKUP_DIRECTORY="PLACEHOLDER"

export BACKUP_FILENAME="PLACEHOLDER"

export REDIS_BACKUP_FILE="PLACEHOLDER"
```

## Debug

### Check if Redis is running on the instance
```shell
sudo systemctl status redis-server.service
```

### Check if Redis backup is enabled in the Redis configuration file
```shell
sudo grep -i save /etc/redis/redis.conf
```

### Check the size of Redis RDB file
```shell
sudo du -sh ${PATH_TO_REDIS_RDB}
```

### Check if Redis backup script is scheduled to run
```shell
sudo crontab -l | grep redis-backup.sh
```

### Check if the Redis backup script is running correctly
```shell
sudo tail -f /var/log/syslog | grep redis-backup.sh
```

### Backup failure: If the backup process fails for any reason, Redis may not be properly backed up. This could be due to issues with the backup software, connectivity issues, or other technical issues.
```shell


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


```

## Repair

### commands to force redis to generate a new backup

```shell
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


```