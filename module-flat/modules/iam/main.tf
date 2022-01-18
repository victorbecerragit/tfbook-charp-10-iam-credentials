module "iam-app1" {
  source   = "./modules/iam"
  name     = "app1"
  policies = [file("./policies/app1.json")]
}
 
module "iam-app2" {
  source   = "./modules/iam"
  name     = "app2"
  policies = [file("./policies/app2.json")]
}
