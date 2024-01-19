variable "pdns_api_key" {
  description = "API key for PowerDNS"
  type        = string
}

variable "pdns_server_url" {
  description = "Server URL for PowerDNS"
  type        = string
}

variable "dns_records_map" {
  description = "Map of DNS records"
  type = map(object({
    A     = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    NS    = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    CNAME = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))), 
    MX    = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SOA   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    TXT   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SRV   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SSHFP  = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SPF   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    NAPTR = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    LOC   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    HINFO = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    AAAA  = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    LUA   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
  }))
  default = {}
}

variable "additional_records" {
  description = "Additional DNS records specific to a server"
  type = map(object({
    A     = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    NS    = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    CNAME = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))), 
    MX    = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SOA   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    TXT   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SRV   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SSHFP  = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    SPF   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    NAPTR = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    LOC   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    HINFO = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    AAAA  = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
    LUA   = optional(list(object({
      name   = string
      values = list(string)
      ttl    = optional(number)
    }))),
  }))
  default = {}
}
