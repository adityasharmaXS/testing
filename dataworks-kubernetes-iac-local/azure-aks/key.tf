resource "tls_private_key" "ssh" {
  count             = var.public_ssh_key == "" ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  count             = var.public_ssh_key == "" ? 1 : 0
  sensitive_content = tls_private_key.ssh[0].private_key_pem
  filename          = "./private_ssh_key"
}