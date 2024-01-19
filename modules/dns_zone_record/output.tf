output "created_zones" {
  description = "Details of the created zones."
  value = [
    for key in keys(powerdns_zone.zones) : {
      dns_server_url   = var.pdns_server_url,
      name         = powerdns_zone.zones[key].name,
      kind         = powerdns_zone.zones[key].kind,
      nameservers  = powerdns_zone.zones[key].nameservers
    }
  ]
}

output "created_records" {
  description = "Details of the created records."
  value = [
    for key in keys(powerdns_record.dns_records) : {
      dns_server_url = var.pdns_server_url,
      name           = powerdns_record.dns_records[key].name,
      type           = powerdns_record.dns_records[key].type,
      value          = powerdns_record.dns_records[key].records,
      ttl            = powerdns_record.dns_records[key].ttl
    }
  ]
}
