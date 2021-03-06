output "gitea_repo_storage_vol_id" {
  value = "${aws_ebs_volume.gitea_repo_storage.id}"
}

output "concourse_volume_storage_vol_id" {
  value = "${aws_ebs_volume.concourse_volume_storage.id}"
}

/* Postgresql volumes */
output "postgres_gitea_db_vol_id" {
  value = "${aws_ebs_volume.postgres_gitea_db.id}"
}

output "postgres_concourse_db_vol_id" {
  value = "${aws_ebs_volume.postgres_concourse_db.id}"
}

output "postgres_clair_db_vol_id" {
  value = "${aws_ebs_volume.postgres_clair_db.id}"
}

output "postgres_notary_db_vol_id" {
  value = "${aws_ebs_volume.postgres_notary_db.id}"
}

output "postgres_harbor_db_vol_id" {
  value = "${aws_ebs_volume.postgres_harbor_db.id}"
}
