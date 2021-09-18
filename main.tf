terraform {
  required_providers {
    googleworkspace = {
      source = "hashicorp/googleworkspace"
      version = "0.4.1"
    }
  }
}
provider "googleworkspace" {
  credentials             = "/Users/mathew.roy/mathew/tf/gcpkey/gcp.json"
  customer_id             = "C03cmqlyp"
  impersonated_user_email = "admin@mathewroy.us"
  oauth_scopes    = [
      "https://www.googleapis.com/auth/admin.directory.user",
      "https://www.googleapis.com/auth/admin.directory.group",
      "https://www.googleapis.com/auth/admin.directory.group.member"
    ]
}

resource "googleworkspace_user" "gcpUser" {

  for_each = toset(var.emails)

  primary_email = "${each.value}"
  password      = "34819d7beeabb9260a5c854bc85b3e44"
  hash_function = "MD5"
  

  name {
    family_name = "${each.value}"
    given_name  = "${each.value}"
  }

  aliases = ["assistant_to_regional_manager@mathewroy.us"]

  emails {
    address = "${each.value}"
    type    = "work"
  }

  relations {
    type  = "assistant"
    value = "Michael Scott"
  }

  addresses {
    country        = "USA"
    country_code   = "US"
    locality       = "Scranton"
    po_box         = "123"
    postal_code    = "18508"
    region         = "PA"
    street_address = "123 Dunder Mifflin Pkwy"
    type           = "work"
  }

  organizations {
    department = "mathewroy.us"
    location   = "Scranton"
    name       = "Dunder Mifflin"
    primary    = true
    symbol     = "DUMI"
    title      = "member"
    type       = "work"
  }

  phones {
    type  = "home"
    value = "555-123-7890"
  }

  phones {
    type    = "work"
    primary = true
    value   = "555-123-0987"
  }

  keywords {
    type  = "occupation"
    value = "salesperson"
  }

  recovery_email = "mathew.roy@gmail.com"
}

resource "googleworkspace_group" "gcpGroup" {
  email       = "sales@mathewroy.us"
  name        = var.group
  description = "Sales Group"
 
  aliases = ["paper-sales@mathewroy.us", "sales-dept@mathewroy.us"]
}


resource "googleworkspace_group_member" "manager" {

   for_each = googleworkspace_user.gcpUser
  group_id = googleworkspace_group.gcpGroup.id
  email    = each.value.primary_email

  role = "MANAGER"
}

output "value" {
 
  value = {
    for k, v in googleworkspace_user.gcpUser : k => v.primary_email
  }
}