output "postgres_gitea_db_vol_id" {
  value = "${aws_ebs_volume.postgres_gitea_db.id}"
}

output "gitea_repo_storage_vol_id" {
  value = "${aws_ebs_volume.gitea_repo_storage.id}"
}
