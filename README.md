# atsip76_infra

# atsip76 Infra repository

# HW7

## Terraform-2 Практика IaC с использованием Terraform

- Создана ветка terraform-2
- Подчищаем заданя с * установив количество инстансов app равным 1 и перенеся файл lb.tf в terraform/files
- Определяем ресурс файервола для порта ssh по умолчанию.
- Выполним команду применения изменений и получим ошибку Error 409: The resource 'projects/atsip76/global/firewalls/default-allow-ssh' already exists Правило firewall/default-allow-ssh уже существует.
- Импортируем существующую инфраструктуру в Terraform для исключения конфликта.
- Зададим IP для инстанса с приложением в виде внешнего ресурса задав ресурс google_compute_address
- Пересоздаем ресурсы
- Ссылаемся на атрибуты другого ресурса
- Неявная зависимость, удаляем и создам заново ресурсы, наблюдаем за порядком создания зависимостей ресурсов
- ##### Task*

### Task**

#### Запуск проекта:

```sh
Выполнить terraform apply в директории terraform
```

### Проверка развертывания, перейдя по адресу сервера в вашем браузере:

```sh
Открыть в вашем браузере:
lb_ip - ip address output variable
lb_ip:443
```

# HW5

## Сборка образов VM припомощи Packer

- Создан packer шаблон ubuntu16.json
- Образ собран и протестирован
- Шаблон ubuntu16.json параметизирован используя пользовательские переменные
- В файле variables.json заданы переопределяемые переменные
- Добавлены дополнительные опции (disk_type disk_size network tags image_description)

  ##### Task*1

- Создан packer шаблон immutable.jso

- Создан bash скрипт packer/files/deploy.sh деплоя приложения и старта инитника для автозапуска демона puma в системе с systemd после разворачивания инстанса

  ##### Task*2

- Создан скрипт create-reddit-vm.sh в директории config-scripts для ускорения деплоя из образа reddit-full

  #### Запуск проекта:

  ```sh
  Запустить скрипт reate-reddit-vm.sh в директории config-scripts
  ```

  #### Проверка развертывания, перейдя по адресу сервера в вашем браузере:

  ```sh
  wanip_addr_vm:9292
  ```

# HW4

## Практика управления ресурсами GCP через gcloud. Ручной деплой тестового приложения. Написание bash скриптов для автоматизации задач настройки VM и деплоя приложения.

## testapp_IP = 35.197.224.89 testapp_port = 9292

## Task *1

- Для автоматического деплоя приложения при создании инстанса использованн линейный бэш скрипт script=startup-script.sh передающийся в качестве доп. аргумента при создании инстанса из gcloud консоли:

  ```sh
  gcloud compute instances create reddit-app --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server --restart-on-failure\
  --metadata-from-file startup-script=startup-script.sh
  ```

  > Опция - --metadata-from-file startup-script=startup-script.sh с указанием абсолютного пути до скрипта (в данном случае находящийся в текущей директории)

## Task *2

- Правило файрвола создаем из консоли командой:

  ```sh
  gcloud compute firewall-rules create default-puma-server \
  --action allow --target-tags puma-server --direction ingress \
  --source-ranges 0.0.0.0/0 --rules tcp:9292
  ```

  > Указывая правильные теги, подсети, направление фильтра, протокол, порт.

### Проверка развертывания, перейдя по адресу сервера в вашем браузере:

```sh
testapp_IP:9292
```

# HW3

## Запуск VM в GCP, управление правилами фаервола, настройка SSH подключения, настройка SSH подключения через Bastion Host, настройка VPN сервера и VPN-подключения

## bastion_IP = 35.234.112.242 someinternalhost_IP = 10.156.0.3

### Task *1

#### Подключение в одну команду из консоли

#### Два способа реализации:

##### 1 Способ прыжком с доступного хоста на изолированный:

ssh -J bastion_IP someinternalhost_IP попадаем через наш внешний хост 35.234.112.242 на изолированный хост 10.156.0.3

##### 2 Способ подключения к изолированному инстансу через тунель:

ssh -tA work@bastion_IP ssh work@someinternalhost_IP используем тунелирование -t для доступа к хосту в изолированной подсети через доступный хост с маршрутизированным IP

### Task *2

#### Подключение по алиасу

#### Два способа реализации:

##### 1 Способ использование ~/.ssh/config для создания алиасов нужных хостов

редактируем ~/.ssh/config: Host someinternalhost HostName someinternalhost_IP User work ProxyJump bastion_IP После этого по команде ssh someinternalhost мы будем сразу прыгать на нужный изолированный хост

##### 2 Способ (как вариант) использование алиасов пользовательского окружения

Для подключения с локальной консоли по алиасу someinternalhost можно настроить пользовательское окружение на локальной машине создав алиас в .bashrc файле пользователя, например: alias someinternalhost='ssh -tA work@35.234.112.242 ssh work@10.156.0.3' теперь набрав в консоли алиас someinternalhost мы получим подключениек к консоли хоста someinternalhost
