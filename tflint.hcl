config {
    module = true
}

plugin "aws" {
  enabled = true
  version = "0.18.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "azurerm" {
  enabled = true
  version = "0.19.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_typed_variables" {
    enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}
