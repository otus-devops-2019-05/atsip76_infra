# atsip76_infra

# atsip76 Infra repository

# HW6

## Terraform-1 Практика IaC с использованием Terraform

- Создана ветка terraform-1
- Установлен Terraform 0.11.11
- Установлен модуль провайдера google
- Создан первый конфиг main.tf
- На основе конфига main.tf создан тестовый инстанс VM
- Добавлен ssh ключ пользователя appuser функцией file
- Протестирован ssh доступ юзером work
- Создан файл outputs.tf с инициализацие переменной app_external_ip
- В конфиг добавлен ресурс файрволла с определением правил фильтрации
- В конфиг добавлен провижинер типа file для переноса конфиг файла unit puma.service с локальной директории в темповую на создаваемом инстансе
- В директории terraform/files создан unit файл puma.service
- В конфиг добавлен провижинер remote-exec для удаленного выполнения скрипта на локальной машине files/deploy.sh для провижинга приложения и запуска puma.service
- Описаны входные переменные в variables.tf
- Инициализированы входные переменные в terraform.tfvars
- Выполнено пересоздание всех ресурсов и тестирование
- Определены дополнительные переменные для private_key & Zone
- Создан terraform.tfvars.exampl с образцами переменных

  ##### Task*

- Для внесения множества параметров в одну строку можно использовать символ новой стороки \n, но гораздо удобнее использовать метод here document собственный EOT.

  ```sh
  Пример
      ssh-keys = <<EOT
      appuser:${file(var.public_key_path)}
      appuser1:${file(var.public_key_path)}
      appuser2:${file(var.public_key_path)}
      appuser3:${file(var.public_key_path)}
      appuserN:${file(var.public_key_path)}
      EOT`
  ```

- При добавлении ключа пользователя через web интерфейс, при следующем apply это пользователь и ключ будет удален, что логично, т.к. терраформ приводить всю систему в единое подобие своего конф. файла

  ##### Task**

- создана конфигурация tcp load_balancer lb.tf

- В файл output добавлена переменная для возврата ip адреса load-balancer
- в файле output исправлен синтаксис app_external_ip имя переменной для множества инстансов
- в файл variable добавлена переменная count_instance для задания нужного количества создаваемых инстансов

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
