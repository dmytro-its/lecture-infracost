inputs = {
  default_inbound = [
    # Allow HTTP 80 inbound
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow HTTPS 443 inbound
    {
      rule_number = 110
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # DNS port 53
    {
      rule_number = 800
      rule_action = "allow"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
    # NTP port 123
    {
      rule_number = 810
      rule_action = "allow"
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow ICMP ping
    {
      rule_number = 820
      rule_action = "allow"
      icmp_code   = -1
      icmp_type   = 8
      protocol    = "icmp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow ephemerial TCP ports. Needs to be restricted
    {
      rule_number = 830
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow ephemerial UDP ports. Needs to be restricted
    {
      rule_number = 840
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  default_outbound = [
    # Allow HTTP 80 port out
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow HTTPS 443 port out
    {
      rule_number = 110
      rule_action = "allow"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow DNS port
    {
      rule_number = 800
      rule_action = "allow"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow NTP port
    {
      rule_number = 810
      rule_action = "allow"
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow ICMP responce
    {
      rule_number = 820
      rule_action = "allow"
      icmp_code   = -1
      icmp_type   = 0
      protocol    = "icmp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow TCP ephemerial port range. Required by ALB
    {
      rule_number = 830
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    # Allow UDP ephemerial ports
    {
      rule_number = 840
      rule_action = "allow"
      from_port   = 1024
      to_port     = 65535
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}
