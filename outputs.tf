output "azs_names" {
    value = data.aws_availability_zones.available
  
}

output "public" {
    value = [for s in aws_subnet.public : s.tags["Name"]]
  
}

output "private" {
    value = [for s in aws_subnet.private : s.tags["Name"]]
  
}

output "database" {
    value = [for s in aws_subnet.database : s.tags["Name"]]
  
}