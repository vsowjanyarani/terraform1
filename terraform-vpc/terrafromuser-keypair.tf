resource "aws_key_pair" "deployer" {
  key_name   = "us-east-2-region-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmHoLHP+c656Itsdshy7IDpC3vyml9m4d7tbko02p/A/uoYobOHGpkrBQesgHY7ZYDg+cYqJjI5WVSoeclcA7ZcdR38w3lIlLOkzydB6BUnWmE/Yy48Lb5yt60Pu9lTpF4WlXrD17qY6SL2S0vIkp+6UubH6kOVv78HW9qnyMAUUEckr2z+mylAzb4GwjcE2GodP+yKGtrqTTAdIvxJjXb0/BQBE/RjO7mr7wTjJwUi95J3oW3YVKlbFf09nv0jrIL1hgfZUXa1AsyEV85Suf5dGva3Zp5Ypr9eKJjS19IdsKusqaeodrRiywDCVgbokq0FCeN1u6rdA4N1oh7tAZZuXGyuyDsywJjcbde9+7ZMMLh/fvdJAFlZOZMY/xt/8pAbdz4MdNKYlerDBVa6jVAeWXsqc3bmpunGunF7ApV4BmtV4YLNURoc+S3Jy/12bTGbYC0yK21jV5rKxqFPARAaTAHHQzf483/ZfbgUC51q9ll1JVHwoNZIRwKXIuWue0= ubuntu@ip-172-31-15-88"
}