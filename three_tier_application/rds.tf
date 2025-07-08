resource "aws_db_subnet_group" "rds_subnetgrp" {
  name       = "main"
  subnet_ids = [aws_subnet.rds_subnet1.id, aws_subnet.rds_subnet2.id]
  depends_on = [aws_subnet.rds_subnet1, aws_subnet.rds_subnet2]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage       = 20
  identifier              = "books-rds"
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  multi_az                = true
  publicly_accessible     = false
  backup_retention_period = 7
  db_subnet_group_name    = aws_db_subnet_group.rds_subnetgrp.id
  vpc_security_group_ids  = [aws_security_group.book_rds_sg.id]
  depends_on              = [aws_db_subnet_group.rds_subnetgrp]
  tags = {
    DB_identifier = "book-rds"
  }
}