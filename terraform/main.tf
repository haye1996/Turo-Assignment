module "app1" {
  source    = "./modules/app"
  namespace = "hye"
  app_name  = "devops-interview-app-1"
  image     = var.image1
}

module "app2" {
  source    = "./modules/app"
  namespace = "hye"
  app_name  = "devops-interview-app-2"
  image     = var.image2
} 