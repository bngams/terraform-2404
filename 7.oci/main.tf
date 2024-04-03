resource "oci_identity_compartment" "my_compartment" {
    #Required
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa3zjd5v64gttflvu2apnfsdnlhpgms4es3xmw2qnauwjsqq2gckja"
    description = "training compartment"
    name = "terraform_2404_nb"
}

resource "oci_core_vcn" "my_vcn" {
    #Required
    compartment_id = oci_identity_compartment.my_compartment.compartment_id
    cidr_block = "10.0.0.0/16"
} 

resource "oci_core_internet_gateway" "test_internet_gateway" {
    #Required
    compartment_id = oci_identity_compartment.my_compartment.compartment_id
    vcn_id = oci_core_vcn.my_vcn.id
}

resource "oci_core_route_table" "test_route_table" {
    #Required
    compartment_id = oci_identity_compartment.my_compartment.compartment_id
    vcn_id = oci_core_vcn.my_vcn.id

    #Optional
    route_rules {
        #Required
        network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
        #Optional
        destination = "0.0.0.0/0"
    }
}

resource "oci_core_subnet" "my_subnet" {
    #Required
    cidr_block = "10.0.0.0/24"
    compartment_id = oci_identity_compartment.my_compartment.compartment_id
    vcn_id = oci_core_vcn.my_vcn.id
}

resource "oci_core_route_table_attachment" "test_route_table_attachment" {
  #Required    
  subnet_id = oci_core_subnet.my_subnet.id
  route_table_id =oci_core_route_table.test_route_table.id
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = oci_identity_compartment.my_compartment.compartment_id
}

resource "oci_core_instance" "ubuntu_instance" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = oci_identity_compartment.my_compartment.compartment_id
    shape = "VM.Standard.E2.1.Micro"
    source_details {
        source_id = "ocid1.image.oc1.eu-marseille-1.aaaaaaaab6s7ji4pka7v7sundmuums4fe5oyzkfzzhq45migsdrwflqzgr7a"
        source_type = "image"
    }

    # Optional
    display_name = "nb-wp-vm-1"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_subnet.my_subnet.id
    }
    metadata = {
        ssh_authorized_keys = file("${path.module}/.ssh/oci.pub")
    } 
    preserve_boot_volume = false
}