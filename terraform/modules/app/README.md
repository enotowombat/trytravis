# Reddit Application

This folder contains a [Terraform](https://www.terraform.io/) module to deploy an application node in [GCP](https://cloud.google.com/). This module 
is designed to deploy a [GCP Image](https://cloud.google.com/compute/docs/images) that has [Ruby](https://www.ruby-lang.org) and the application installed on Ubuntu 16.04.


## How do you use this module?

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```hcl
module "app" {
  source  = "path-to-app-module"
  version = "0.0.1"
  # See variables.tf for the other parameters you must define for the app module
}
``` 


## How do you connect to Application node?

From your code using output variable: `"${module.app.app_external_ip}"`
http access is available on port 9292
