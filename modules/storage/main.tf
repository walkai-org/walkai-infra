resource "aws_dynamodb_table" "cluster_cache" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name = var.table_name
    }
  )
}
