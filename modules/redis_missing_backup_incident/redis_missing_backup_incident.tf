resource "shoreline_notebook" "redis_missing_backup_incident" {
  name       = "redis_missing_backup_incident"
  data       = file("${path.module}/data/redis_missing_backup_incident.json")
  depends_on = [shoreline_action.invoke_check_redis_backup,shoreline_action.invoke_redis_backup_rename]
}

resource "shoreline_file" "check_redis_backup" {
  name             = "check_redis_backup"
  input_file       = "${path.module}/data/check_redis_backup.sh"
  md5              = filemd5("${path.module}/data/check_redis_backup.sh")
  description      = "Backup failure: If the backup process fails for any reason, Redis may not be properly backed up. This could be due to issues with the backup software, connectivity issues, or other technical issues."
  destination_path = "/agent/scripts/check_redis_backup.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "redis_backup_rename" {
  name             = "redis_backup_rename"
  input_file       = "${path.module}/data/redis_backup_rename.sh"
  md5              = filemd5("${path.module}/data/redis_backup_rename.sh")
  description      = "commands to force redis to generate a new backup"
  destination_path = "/agent/scripts/redis_backup_rename.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_redis_backup" {
  name        = "invoke_check_redis_backup"
  description = "Backup failure: If the backup process fails for any reason, Redis may not be properly backed up. This could be due to issues with the backup software, connectivity issues, or other technical issues."
  command     = "`chmod +x /agent/scripts/check_redis_backup.sh && /agent/scripts/check_redis_backup.sh`"
  params      = ["BACKUP_DIRECTORY","BACKUP_FILENAME","REDIS_HOST"]
  file_deps   = ["check_redis_backup"]
  enabled     = true
  depends_on  = [shoreline_file.check_redis_backup]
}

resource "shoreline_action" "invoke_redis_backup_rename" {
  name        = "invoke_redis_backup_rename"
  description = "commands to force redis to generate a new backup"
  command     = "`chmod +x /agent/scripts/redis_backup_rename.sh && /agent/scripts/redis_backup_rename.sh`"
  params      = ["REDIS_BACKUP_FILE"]
  file_deps   = ["redis_backup_rename"]
  enabled     = true
  depends_on  = [shoreline_file.redis_backup_rename]
}

