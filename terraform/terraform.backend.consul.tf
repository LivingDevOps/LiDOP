terraform {
  backend "consul" {
    scheme  = "http"
    path    = "terraform/states"
  }
}