locals {
  cleaned_dns_records = {
    for zone, records in var.dns_records_map : zone => {
      for type, value in records : type => value if value != null
    }
  }

  cleaned_additional_records = {
    for zone, records in var.additional_records : zone => {
      for type, value in records : type => value if value != null
    }
  }

  combined_records = {
    for zone in distinct(concat(keys(local.cleaned_dns_records), keys(local.cleaned_additional_records))) : zone => {
      for record_type in distinct(concat(keys(lookup(local.cleaned_dns_records, zone, {})), keys(lookup(local.cleaned_additional_records, zone, {})))) : record_type => 
        merge(
          { for r in lookup(local.cleaned_dns_records[zone], record_type, []) : r.name => r },
          { for r in lookup(local.cleaned_additional_records[zone], record_type, []) : r.name => r }
        )
    }
  }

  flat_records = flatten([
    for zone, types in local.combined_records : [
      for type, records in types : records != null ? [
        for record in records : {
          "id"      = "${zone}-${type}-${record.name}",
          "zone"    = zone,
          "name"    = record.name,
          "type"    = type,
          "values"  = record.values,
          "ttl"     = record.ttl != null ? record.ttl : 3600
        }
      ] : []
    ]
  ])
  }

provider "powerdns" {
  api_key    = var.pdns_api_key
  server_url = var.pdns_server_url
}

resource "powerdns_zone" "zones" {
  for_each = toset(keys(var.dns_records_map))

  name        = each.key
  kind        = "Native"
  nameservers = ["ns1.${each.key}", "ns2.${each.key}"]

  lifecycle {
    ignore_changes = [
      nameservers
    ]
  }

}

resource "powerdns_record" "dns_records" {
  for_each = { for r in local.flat_records : r.id => r }

  zone    = each.value.zone
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.values

  depends_on = [powerdns_zone.zones]
}
