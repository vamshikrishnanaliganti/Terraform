resource "aws_s3_bucket" "mybucket" {
  bucket = "myterraformbucket2025newvasmhikrishna"
}


resource "aws_instance" "dev" {
  ami           = var.amiid
  instance_type = var.instance_type
  key_name      = var.key
  tags = {
        Name = "dev21"
    }
}
