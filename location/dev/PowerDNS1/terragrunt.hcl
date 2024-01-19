include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/dns_zone_record"
}

inputs = {
  pdns_server_url    = "http://192.168.1.1:8081"
  additional_records = {
    "domen.ru." = {
      SOA = [
        {
          name   = "domen.ru."
          values = ["ns1.domen.ru. admin.example.com. 1 10800 3600 604800 3600"]
        }
      ],
      NS = [
        {
          name   = "domen.ru."
          values = ["ns1.domen.ru.", "ns2.domen.ru."]
        }
      ],
      A = [
        {
          name   = "ns1.domen.ru."
          values = ["10.5.229.11"]
        }
      ],
      MX = [
        {
          name   = "domen.ru."
          values = ["10 mail.biba.ru."]
        }
      ],
      TXT = [
        {
          name   = "domen.ru."
          values = ["\"v=spf1 include:_spf.domen.ru. ~all\""]
        }
      ]
    },
    "example.com." = {
      SOA = [
        {
          name   = "example.com."
          values = ["ns1.example.com. admin.example.com. 1 10800 3600 604800 3600"]
        }
      ]  
    }
  }
}
