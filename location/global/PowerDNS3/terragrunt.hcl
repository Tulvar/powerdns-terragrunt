include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/dns_zone_record"
}

inputs = {
    pdns_server_url  = "http://10.1.1.1:8081"
    additional_records = {
    "domen.ru." = {
      SOA = [
        {
          name   = "domen.ru."
          values = ["ns2.domen.ru. admin.example.com. 1 10800 3600 604800 3600"]
        }
      ],
      A = [
        {
          name   = "ns2.domen.ru."
          values = ["10.5.229.8"]
        },
        {
          name   = "atata.domen.ru."
          values = ["1.1.1.1"]
          ttl    = 500   
        }
      ],
      NS = [
        {
          name   = "domen.ru."
          values = ["ns2.domen.ru."]
        }
      ],
      MX = [
        {
          name   = "domen.ru."
          values = ["10 mail.zopka.ru."]
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
      ],
      A = [
        {
          name   = "privet.example.com."
          values = ["228.228.228.228"]
        }
      ]  
    }
  }
}
