# powerdns-terragrunt

Данный репозиторий предназначен для самостоятельного создания записей на DNS сервере.

## Как создавать DNS записи.

1. Скачиваем себе репозиторий и создаем новую ветку.
2. В репозитории выбираем каталог `zones`. 
3. В каталоге выбираем каталог необходимый зоны, в ней будет лежать .yml файл с именем требуемый зоны (допусти example.yml).
4. Файл разделен на несколько категорий по типу записи (A, CNAME, MX и т.д.). Записи доложны быть в своей категории.
5. Создаем нужную запись. TTL это необязательное поле. Если его не указать будет выставленно дефолтное значение 3600.
6. terragrunt run-all plan
7. terragrunt run-all apply

## Как создать новую зону

Этот процесс посложнее и в он не обойдется без администраторов системы PowerDNS.

1. Скачиваем себе репозиторий.
2. В каталоге `zones` создаем каталог с именем нашей зоны. (например: `primer`)
3. В новосозданном каталоге создаем файл .yml с именем нашей зоны. (например: `primer.yml`)
4. Заполняем файл в соответствии с примером
5. В файле `terragrunt.hcl` в корне репозитория в дерективе locals добавляем строчку 
```
locals {
...
...
...
  primer_vars  = yamldecode(file("${get_parent_terragrunt_dir()}/zones/primer/primer.yml"))
}
```
6. В директиве inputs добавляем в переменную `dns_records_map` `local.primer_vars.dns_records_map`
```
inputs = {
    pdns_api_key    = get_env("SECRET_API_KEY", "")
    dns_records_map = merge(.........., .........., local.primer_vars.dns_records_map)
}
```
7. terragrunt run-all plan
8. terragrunt run-all apply

## Как добавить новый DNS сервер.

1. Скачиваем себе репозиторий.
2. В каталоге `location` выбирааем требуемый каталог с локацией или созаем новый. (допустим выбрали `dev`).
3. В каталоге с именем локации(`dev`) с выбираем каталог с именем сервера или создаем новый (например: `PowerDNS1`).
4. В каталоге с именем сервера(`PowerDNS1`) создаем файл `terragrunt.hcl` примерно такого содержания:
```
include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/dns_zone_record"
}

inputs = {
  pdns_server_url    = "http://1.1.1.1:8081" <----------------данную строку надо заменить.
  //В этой переменной можно указать индивидуальные для того сервера настройки зоны.
  additional_records = {
    "primer.ru." = {
      SOA = [
        {
          name   = "primer.ru."
          values = ["ns1.primer.ru. admin.primer.ru. 1 10800 3600 604800 3600"]
        }
      ],
      MX = [
        {
          name   = "primer.ru."
          values = ["10 mail.primer.ru."]
          ttl    = 500
        }
      ],
      TXT = [
        {
          name   = "primer.ru."
          values = ["\"v=spf1 include:_spf.primer.ru. ~all\""]
        }
      ]
    }
    "zopa.com." = {
      SOA = [
        {
          name   = "zopa.com."
          values = ["ns1.zopa.com. admin.zopa.com. 1 10800 3600 604800 3600"]
          ttl    = 1500
        }
      ]  
    }
  }
}

```
5. В переменной `additional_records` можно добавить индивидуальные настройки для данного сервера. Напирмер изменить запись SOA или переписать NS сервера, а так же заменить изменить A записи уникальные для данной зоны.
6. terragrunt run-all plan
7. terragrunt run-all apply

## Пример файла с зоной

```
dns_records_map:
  "primer.ru.":
    A:
      - name: "l.primer.ru."
        values: ["192.168.1.5"]
      - name: "olololo.primer.ru."
        values: ["192.168.1.6"]
        ttl: 1500
    MX:
      - name: "primer.ru."
        values: ["10 mail.primer.ru."]
        ttl: 300
    CNAME:
      - name: "alias.primer.ru."
        values: ["target.google.com."]
    LUA:
      - name: "scripted.primer.ru." 
        values: ["A \"pickrandom({'192.168.0.111','192.168.0.222'})\""]
```
