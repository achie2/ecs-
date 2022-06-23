resource "aws_db_instance" "ecs-mysql" {
  identifier                = "ecs-mysql" 
  allocated_storage         = 5
  multi_az                  = true
  engine                    = "mysql"
  instance_class            = "db.t2.micro"
  username                  = "ecs"
  password                  = "achiepalago"
  port                      = "3306"
  db_subnet_group_name      = aws_db_subnet_group.ecs_rds_instance_subnet.name  
  vpc_security_group_ids    = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
  skip_final_snapshot       = true
  publicly_accessible       = true
}


# RDS instance subnet
resource "aws_db_subnet_group" "ecs_rds_instance_subnet" {
  name       = "ecs_rds_instance_subnet"
  subnet_ids = [aws_subnet.public-sub1.id, aws_subnet.public-sub2.id]
  description = "rds instance subnet"

  tags = {
    Name = "ecs database subnet"
  }
}  

