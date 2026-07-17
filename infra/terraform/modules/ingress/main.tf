# azure
resource "azurerm_public_ip" "ingress" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_network_security_group" "ingress" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "http" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_range      = "80"

  source_address_prefix       = "*"
  destination_address_prefix  = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ingress[0].name
}

resource "azurerm_network_security_rule" "https" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name = "allow-https"

  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         =*var.resource_group_name
  network_*ecurity_group_name = azurerm_netwo*k_security_group.ingress[0].name
}

resource "azurerm_applicatio*_gateway" "ingress" {
  count = va*.cloud_provider == "azure" ? 1 : 0*
  name                = "${var.na*e}-agw"
  location            = va*.location
  resource_group_name = *ar.resource_group_name

  sku {
  * name     = "Standard_v2"
    tier*    = "Standard_v2"
    capacity =*2
  }
}

# aws
resource "aws_security_group" "i*gress" {
  count = var.cloud_provi*er == "aws" ? 1 : 0

  name   = "$*var.name-sg"
  vpc_id = var.vpc_i*
}

resour*e "aws_vpc_security_group_ingress_*ule" "http" {
  count = var.cloud_*rovider == "aws" ? 1 : 0

  securi*y_group_id = aws_security_group.in*ress[0].id

  from_port   = 80
  t*_port     = 80
  ip_protocol = "tc*"

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security*group_ingress_rule" "https" {
  co*nt = var.cloud_provider == "aws" ?*1 : 0

  security_group_id = aws_s*curity_group.ingress[0].id

  from*port   = 443
  to_port     = 443
 *ip_protocol = "tcp"

  cidr_ipv4 =*"0.0.0.0/0"
}

resource*"aws_lb" "ingress" {
  count = var*cloud_provider == "aws" ? 1 : 0

 *name               = var.name
  lo*d_balancer_type = "application"

 *security_groups = [
    aws_security_group.ingress[0].id
  ]

  subne*s = var.subnet_ids

  tags = var.t*gs
}

# gcp
resource "google_comp*te_firewall" "http" {
  count = va*.cloud_provider == "gcp" ? 1 : 0

* name    = "${var.name}-http"
  ne*work = "default"

  allow {
    pr*tocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = var.allowe*_cidrs
}

resource "google_compute_firewall" "https" {
  count = var.cloud_provider == "*cp" ? 1 : 0

  name    = "${var.na*e}-https"
  network = "default"

 *allow {
    protocol = "tcp"
    p*rts    = ["443"]
  }

  source_ran*es = var.allowed_cidrs
}

resource "google_compute_firewall" "https" {
  count = var.cloud_provider == "*cp" ? 1 : 0

  name    = "${var.na*e}-https"
  network = "default"

 *allow {
    protocol = "tcp"
    p*rts    = ["443"]
  }

  source_ran*es = var.allowed_cidrs
}

resoure "google_compute_global_address" *ingress" {
  count = var.cloud_pro*ider == "gcp" ? 1 : 0

  name = "$*var.name-ip"
}

# oracle
resource "oci_core_net*ork_security_group" "ingress" {
  *ount = var.cloud_provider == "oci"*? 1 : 0

  compartment_id = var.co*partment_id
  vcn_id         = var*vcn_id

  display_name = "${var.na*e}-nsg"
}

resource "oci_core_netw*rk_security_group_security_rule" "*ttps" {
  count = var.cloud_provid*r == "oci" ? 1 : 0

  network_secu*ity_group_id =
    oci_core_networ*_security_group.ingress[0].id

  d*rection = "INGRESS"

  protocol = *6"

  source = "0.0.0.0/0"

  tcp_*ptions {
    destination_port_rang* {
      min = 443
      max = 443*    }
  }
}

resource "oci_load_bal*ncer_load_balancer" "ingress" {
  *ount = var.cloud_provider == "oci"*? 1 : 0

  compartment_id = var.co*partment_id

  display_name = var.*ame

  shape = "flexible"

  subne*_ids = var.subnet_ids
}

# digital ocean
resource "digitalocean_firewall" "*ngress" {
  count = var.cloud_prov*der == "digitalocean" ? 1 : 0

  n*me = "${var.name}-fw"

  inbound_r*le {
    protocol         = "tcp"
*   port_range       = "80"
    sou*ce_addresses = ["0.0.0.0/0"]
  }

* inbound_rule {
    protocol      *  = "tcp"
    port_range       = "*43"
    source_addresses = ["0.0.0*0/0"]
  }
}

resource "digitalocean*loadbalancer" "ingress" {
  count * var.cloud_provider == "digitaloce*n" ? 1 : 0

  name   = var.name
  *egion = var.location

  forwarding*rule {
    entry_port      = 80
  * entry_protocol  = "http"

    tar*et_port     = 80
    target_protoc*l = "http"
  }

  forwarding_rule {
    entry_port      = 443
    ent*y_protocol  = "https"

    target_*ort     = 443
    target_protocol * "https"
  }
}

o*tput "k8s_ingress_annotations" {
 *value = {
    azure = {
*    *"kubernetes.io*ingress.class" = "azure/applicatio*-g*teway"
    }

    aws = {
     *"alb.ingress.kubernetes.io/scheme"*= "internet-facing"
    }

    gcp*= {
      "kubernetes.io/ingress.c*ass" = "gce"
    }

    oci = {
  *   "oci.oraclecloud.com/load-balan*er-type" = "lb"
    }

    digital*cean = {
      "kubernetes.io/ingr*ss.class" = "nginx"
    }
  }
}

