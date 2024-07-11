data "aws_secretsmanager_random_password" "random_password_generate" {
  password_length     = 9
  exclude_numbers     = false
  #exclude_punctuation = true
  #include_space       = false
  exclude_uppercase   = false
  exclude_lowercase   = false
  exclude_characters = "!@#$%^&*()?> <.=:;|-_+}]/,"
}

resource "aws_secretsmanager_secret" "my_secret" {
  name = "my_secret_for_rdsssssssssss"
}

resource "aws_secretsmanager_secret_version" "my_secret_for_rds" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  
  secret_string = jsonencode({
    username = "tayyab" #var.user_name
    password = data.aws_secretsmanager_random_password.random_password_generate
  })
}