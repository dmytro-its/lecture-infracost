inputs = {
  public_inbound = [
    # Allow ITSyndicate VPN to SSH
    {
      rule_number = 300
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "82.196.6.227/32"
    },
    # Allow internal inbound to SMTP
    {
      rule_number = 310
      rule_action = "allow"
      from_port   = 25
      to_port     = 25
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow connection to 500 ISAKMP port for establishing PHASE 1 of IPSEC tunnnel. For movius-sftp host
    {
      rule_number = 320
      rule_action = "allow"
      from_port   = 500
      to_port     = 500
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  public_outbound = [
    # Allow SSH 22 port out
    {
      rule_number = 300
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow outbound to Tomcat HTTPS
    {
      rule_number = 310
      rule_action = "allow"
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow outbound to internal SMTP
    {
      rule_number = 320
      rule_action = "allow"
      from_port   = 25
      to_port     = 25
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow outbound to external SMTP TLS/Start TLS Port
    {
      rule_number = 330
      rule_action = "allow"
      from_port   = 587
      to_port     = 587
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow outbound to NFS port (used by EFS)
    {
      rule_number = 340
      rule_action = "allow"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow connection to 500 ISAKMP port for establishing PHASE 1 of IPSEC tunnnel. For movius-sftp host
    {
      rule_number = 350
      rule_action = "allow"
      from_port   = 500
      to_port     = 500
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}
