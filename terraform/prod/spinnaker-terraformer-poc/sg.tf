locals {
  yandexnets = {
    ipv4 = [
      "5.45.192.0/18",
      "5.255.192.0/18",
      "37.9.64.0/18",
      "37.140.128.0/18",
      "45.87.132.0/22",
      "77.88.0.0/18",
      "84.252.160.0/19",
      "87.250.224.0/19",
      "90.156.176.0/22",
      "93.158.128.0/18",
      "95.108.128.0/17",
      "100.43.64.0/19",
      "139.45.249.96/29", // https://st.yandex-team.ru/NOCREQUESTS-25161
      "141.8.128.0/18",
      "178.154.128.0/18",
      "185.32.187.0/24",
      "199.21.96.0/22",
      "199.36.240.0/22",
      "213.52.188.0/25",
      "213.180.192.0/19",
    ]
    ipv6 = [
      "2001:4d78:51b::/48",
      "2620:10f:d000::/44",
      "2a02:6b8::/32",
      "2a0e:fd80::/29",
    ]
  }
}

resource "aws_security_group" "allow_only_yandex" {
  name   = "lb-allow_only_yandex"
  vpc_id = data.aws_vpc.this.id

  ingress {
    protocol  = "TCP"
    from_port = 443
    to_port   = 443

    description = "443 access from _YANDEXNETS_"

    cidr_blocks      = local.yandexnets.ipv4
    ipv6_cidr_blocks = local.yandexnets.ipv6
  }

  ingress {
    protocol  = "TCP"
    from_port = 9000
    to_port   = 9000

    description = "9000 access from _YANDEXNETS_"

    cidr_blocks      = local.yandexnets.ipv4
    ipv6_cidr_blocks = local.yandexnets.ipv6
  }

  ingress {
    protocol  = "TCP"
    from_port = 8084
    to_port   = 8084

    description = "8084 access from _YANDEXNETS_"

    cidr_blocks      = local.yandexnets.ipv4
    ipv6_cidr_blocks = local.yandexnets.ipv6
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "lb-allow_only_yandex"
  }
}

