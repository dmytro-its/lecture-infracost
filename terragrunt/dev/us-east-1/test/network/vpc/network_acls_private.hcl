inputs = {
  private_inbound = [
    # Allow internal SSH connection to 22 port
    {
      rule_number = 200
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow internal PostgreSQL
    {
      rule_number = 210
      rule_action = "allow"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow Tomcat HTTPS port
    {
      rule_number = 220
      rule_action = "allow"
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow internal SMTP connection
    {
      rule_number = 230
      rule_action = "allow"
      from_port   = 25
      to_port     = 25
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow SSH for ITSyndicate VPN
    {
      rule_number = 240
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "82.196.6.227/32"
    },
  ]
  private_outbound = [
    # Allow Internal PostgreSQL connection
    {
      rule_number = 200
      rule_action = "allow"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow internal Tomcat HTTPS connection
    {
      rule_number = 210
      rule_action = "allow"
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow internal SMTP
    {
      rule_number = 220
      rule_action = "allow"
      from_port   = 25
      to_port     = 25
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow internal connection to SSH
    {
      rule_number = 230
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "172.17.0.0/16"
    },
    # Allow SSH connection to ITSyndicate VPN
    {
      rule_number = 240
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "82.196.6.227/32"
    },
  ]
}
