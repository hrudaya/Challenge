output "db_config" {
  value = {
    user     = aws_db_instance.db.username 
    password = aws_db_instance.db.password 
    db       = aws_db_instance.db.name 
    hostname = aws_db_instance.db.address 
    port     = aws_db_instance.db.port 
  }
}
