resource "aws_ebs_volume" "gitea_repo_storage" {
  availability_zone = "us-east-1c"
  type              = "gp2"
  size              = "50"

  tags {
    Name = "Gitea Repository Storage"
  }
}

resource "aws_ebs_volume" "concourse_volume_storage" {
  availability_zone = "us-east-1c"
  type              = "gp2"
  size              = "50"

  tags {
    Name = "Concourse Volume Storage"
  }
}

/* Postgresql volumes */
resource "aws_ebs_volume" "postgres_gitea_db" {
  availability_zone = "us-east-1c"
  type              = "gp2"
  size              = "20"

  tags {
    Name = "Gitea Postgres DB"
  }
}

resource "aws_ebs_volume" "postgres_concourse_db" {
  availability_zone = "us-east-1c"
  type              = "gp2"
  size              = "20"

  tags {
    Name = "Concourse Postgres DB"
  }
}

resource "aws_ebs_volume" "postgres_clair_db" {
  availability_zone = "us-east-1c"
  type              = "gp2"
  size              = "20"

  tags {
    Name = "Clair Postgres DB"
  }
}

resource "aws_ebs_volume" "postgres_notary_db" {
  availability_zone = "us-east-1c"
  type              = "gp2"
  size              = "20"

  tags {
    Name = "Notary Postgres DB"
  }
}

resource "aws_ebs_volume" "postgres_harbor_db" {
  availability_zone = "us-east-1c"
  type              = "gp2"
  size              = "20"

  tags {
    Name = "Harbor Postgres DB"
  }
}
