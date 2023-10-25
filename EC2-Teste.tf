// Instancia do servidor para teste
resource "aws_instance" "EC2-Teste-Lab" {
  ami           = var.ubuntu-2-0-ami
  instance_type = "t2.micro"
  key_name      = "Chave"
  vpc_security_group_ids = [aws_security_group.ec2_teste_sg.id]

  //Volume
  root_block_device {
    delete_on_termination = true
    volume_size           = 30
    volume_type           = "standard"
  }

  volume_tags = {
    Name     = "EC2-Teste-Lab"
    Time     = "Projetos"
  }

  //Instance Tags
  tags = {
    Name     = "EC2-Teste-Lab"
    Time     = "Projetos"
  }
}

output "Servidor-Ec2-Teste-Lab-IP" {
  value = aws_instance.EC2-Teste-Lab.public_ip
}


// Monitoramento com Cloud Watch

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric triggers when the CPU Utilization is greater or equal to 80% for 2 consecutive periods of 2 minutes."
  alarm_actions       = [aws_sns_topic.cpu_alerts.arn]
  dimensions = {
    InstanceId = aws_instance.EC2-Teste-Lab.id
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_alarm" {
  alarm_name          = "high-memory-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric triggers when the Memory Utilization is greater or equal to 80% for 2 consecutive periods of 2 minutes."
  alarm_actions       = [aws_sns_topic.memory_alerts.arn]
  dimensions = {
    InstanceId = aws_instance.EC2-Teste-Lab.id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_usage_alarm" {
  alarm_name          = "high-disk-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskSpaceUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric triggers when the Disk Space Utilization is greater or equal to 80% for 2 consecutive periods of 2 minutes."
  alarm_actions       = [aws_sns_topic.disk_alerts.arn]
  dimensions = {
    InstanceId = aws_instance.EC2-Teste-Lab.id
  }
}

resource "aws_sns_topic" "cpu_alerts" {
  name = "cpu-alerts"
}

resource "aws_sns_topic" "memory_alerts" {
  name = "memory-alerts"
}

resource "aws_sns_topic" "disk_alerts" {
  name = "disk-alerts"
}
