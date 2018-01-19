# VPC

This folder contains a [Terraform](https://www.terraform.io/) module to create firewall rule in [GCP](https://cloud.google.com/) for ssh access. 


## How do you use this module?

This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```hcl
module "vpc" {
  source = "path-to-vpc-module"
  version = "0.0.1"
  # Specify IP addresses range for access
  source_ranges = ["0.0.0.0/0"]
  # See variables.tf for the other parameters you must define for the vpc module
}
``` 

