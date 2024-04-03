terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "5.35.0"
    }
  }
  
  backend "http" {
    address = "https://axuu12ufi9oo.objectstorage.eu-marseille-1.oci.customer-oci.com/p/saT_OnDeieZMAfMxhjN_5HP-eJuhbFFnS10LgFKKTf1s4ngc-nK8UxfwsIupL8cg/n/axuu12ufi9oo/b/terraform-2404-nb-states/o/state"
    update_method = "PUT"
  }
}

provider "oci" {
  # Configuration options
}
