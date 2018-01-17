# MongoDB

This folder contains a [Terraform](https://www.terraform.io/) module to deploy a 
[MongoDB](https://www.mongodb.com/) node in [GCP](https://cloud.google.com/). This module 
is designed to deploy a [GCP Image](https://cloud.google.com/compute/docs/images) 
that has MongoDB 3.2 installed on Ubuntu 16.04.


## How do you use this module?

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```hcl
module "db" {
  source  = "path-to-db-module"
  version = "0.0.1"
  # See variables.tf for the other parameters you must define for the db module
}
``` 


## How do you connect to DB node?

From your code using output variable: `"${module.db.db_internal_ip}"`
Only internal network connections to MongoDB are allowed.
