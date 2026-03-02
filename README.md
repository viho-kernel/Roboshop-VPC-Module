# VPC Module

This Terraform module creates:
- An AWS VPC
- An Internet Gateway attached to the VPC
- Common tagging applied to all resources

## Inputs

| Name        | Type        | Default       | Description                                                                 | Required |
|-------------|-------------|---------------|-----------------------------------------------------------------------------|----------|
| `project`   | `string`    | n/a           | Project name. Used in resource naming and tags.                             | ✅ Yes   |
| `environment` | `string` | n/a           | Environment name (e.g., `dev`, `prod`). Used in resource naming and tags.   | ✅ Yes   |
| `cidr`      | `string`    | `"10.0.0.0/16"` | CIDR block for the VPC.                                                     | ❌ No    |
| `vpc_tags`  | `map(string)` | `{}`        | Additional tags to apply to the VPC.                                        | ❌ No    |
| `igw_tags`  | `map(string)` | `{}`        | Additional tags to apply to the Internet Gateway.                           | ❌ No    |

---

## Outputs

You can extend outputs as needed, but typically you’d expose:
- `vpc_id` → ID of the created VPC
- `igw_id` → ID of the Internet Gateway

---

## Example Usage

```hcl
module "vpc" {
  source      = "git::https://github.com/your-org/vpc-module.git"
  project     = "myapp"
  environment = "prod"

  cidr        = "10.1.0.0/16"

  vpc_tags = {
    Owner = "team-network"
  }

  igw_tags = {
    Purpose = "public-access"
  }
}


#testing line