# atsip76_infra

# atsip76 Infra repository

# HW10
## Ansible-3
- создаем структуру ролей и разносим прежние плейбуки по ролям
- используем ansible-galaxy
- добавляем ресурс google_compute_firewall в конфигурацию терраформа для открытия 80 порта доступа к приложению
- имортируем роль прокси сервера jdauphant.nginx и добавляем в плейбук app.yml
- применяеи плейбук и проверяем доступность приложения на 80 порту
- используя механизм Ansible Vault создаем шифрованные файлы содержащие приватные данные регистрации пользователей, файл кодовой фразы скрываем на локальной машине вне локального репозитория
- создаем плейбук создания пользователей используя зашифрованные файлы данных пользователей
- импортируем users.yml и проганяем site.yml еще раз для создания пользователей
- проверяем на машинах успешное создание необходимых пользователей

###Task*
- Использование динамического inventory:
```sh
stage:
ansible-playbook -i playbooks/inv-stage.sh playbooks/site.yml

prod:
ansible-playbook -i playbooks/inv-prod.sh playbooks/site.yml
```
### Запуск проекта:

```sh
Выполнить ansible-playbook -i playbooks/inv-stage.sh playbooks/site.yml в директории проект/ansible
```

### Проверка развертывания, перейдя по адресу сервера в вашем браузере:
```sh
Открыть в вашем браузере:
reddit-app - узнаем external ip запустив inv.sh
reddit-app:80
```

# HW9

## Ansible-2
- коментим в модуле терраформа секцию деплоя приложения;
- создаем шаблоны;
- создаем unit-файл для деплоя;
- создаем простой плейбук reddit_app.yml с одним сценарием и несколькими тасками, при запуске указываем лимиты для груп хостов и нужные таски для выполения;
- создаем плейбук reddit_app2.yml с несколькими тегированными сценариями;
- выполняем созданный плейбук с несколькими сценариями указывая нужные теги:
```sh
ansible-playbook reddit_app2.yml --tags db-tag,deploy-tag,app-tag
```
- разобъем сценарий на несколько отдельных плейбуков:
1. app.yml
2. db.yml
3. deploy.yml
4. переиминуем плейбуки reddit_app.yml ➡ reddit_app_one_play.yml reddit_app2.yml ➡ reddit_app_multiple_plays.yml
- разнесем конфигурацию по отдельным плейбукам
- создадим единый плейбук включающий через импорт отельные плейбуки созданные ранее
- пересоздаем конфигурацию терраформ и накатываем плейбук ansible-playbook site.yml
- тестируем сервер
- создаем плейбуки для packer packer_app.yml & packer_db.yml
- правим файлы образов удалив секции деплоя через bash скрипты и заменив на выполнение плейбуков
- создаем новые образы
- накатываем плейбуки используя динамический inventory:
```sh
ansible-playbook -i inv.sh site.yml
```
- тестируем
###Task*
- Использование динамического inventory:
```sh
ansible-playbook -i inv.sh site.yml
```
### Запуск проекта:

```sh
Выполнить ansible-playbook -i inv.sh site.yml в директории проект/ansible
```

### Проверка развертывания, перейдя по адресу сервера в вашем браузере:
```sh
Открыть в вашем браузере:
reddit-app - узнаем external ip запустив inv.sh
reddit-app:9292
```

# HW8

## Ansible-1
- выполняем плейбук клонирования репы приложения
- командой
```sh
ansible app -m command -a 'rm -rf ~/reddit'
```
удаляем директорию клонированного приложения в хомдире (получаем варнинг с рекомендачией использования модуля file вместо command для операций удаления файлов и дир, или отключить вывод варнингов в конфиге энсибла)
- повторно выполняем плейбук клонирования репы приложения
- наблюдаем повторное пересоздание (изменение состояния) директории приложения повторным клонированием директории

### Task*
- написан простой скрипт на бэш динамически формирующий файл inventory.json  и возвращающий его ansible
- добавлены необходимые плагины в ansible.cfg
- запуск ansible all -i inv.sh -m ping

# HW7

## Terraform-2 Практика IaC с использованием Terraform

- Создана ветка terraform-2
- Подчищаем задания с * установив количество инстансов app равным 1 и перенеся файл lb.tf в terraform/files
- Определяем ресурс файервола для порта ssh по умолчанию.
- Выполним команду применения изменений и получим ошибку Error 409: The resource 'projects/atsip76/global/firewalls/default-allow-ssh' already exists Правило firewall/default-allow-ssh уже существует.
- Импортируем существующую инфраструктуру в Terraform для исключения конфликта.
- Зададим IP для инстанса с приложением в виде внешнего ресурса задав ресурс google_compute_address
- Пересоздаем ресурсы
- Ссылаемся на атрибуты другого ресурса
- Неявная зависимость, удаляем и создам заново ресурсы, наблюдаем за порядком создания зависимостей ресурсов
- Проведем структуризацию ресурсов, вынесем БД и сервер приложения на отдельные инстансы, создадим две VM, app.tf & db.tf. Объявляем новые переменные в variables.tf
- Вынесем глобальное ssh правило файервола в отделный ресурс в конф. vpc.tf
- Окончательно правим main.tf оставив только определение провайдера
- Применяем конфигурацию, проверяем доступность по ssh созданных ресурсов и работоспособность созданных сервисов, в случае успеха удаляем ресурсы
- Разбиваем конфигурацию на модули db module, app module.
- Удаляем db.tf и app.tf
- Правим main.tf где у нас определен провайдер вставим секции вызова созданных нами модулей
- Подключаем модули terraform get
- При планировани конфигурации получаем ошибку старой выходной перменной определенной в outputs.tf, ошибка ссылки на несуществующий ресурс связанный с новой модульной структурой конфигурации
- Правим outputs.tf указывая новые выходные переменные из модулей db module, app module

  ```sh
  output "app_external_ip" { value = "${module.app.app_external_ip}" }
  output "db_external_ip" { value = "${module.db.db_external_ip}" }
  ```

- проверяем конфигурацию

- Создаем модуль vpc где определим глобальные настройки файервола

- Проверяем разграничение доступа. Вводим в source_ranges не наш IP адрес, применяем конфигурацию и проверяем отсутствие соединения к обоим хостам по ssh. Указываем сой IP и проверяем доступность соединения по ssh с хостами. Устанавливаем по умолчанию полный доступ для всех 0.0.0.0/0

- Создадим инфраструктуру для двух окружений (stage и prod), используя созданные модули. Создаем директории, копируем файлы, меняем пути в main.tf с учетом нового расположения файлов.

- Проверяем корректность конфигов применив конфигурацию в каждой из директории stage∏

- Удаляем из корня main.tf, outputs.tf,terraform.tfvars, variables.tf, так как они теперь перенесены в stage и prod

- Добавляем параметры для модулей app&db name instance

- Форматируем файлы terraform fmt (в этом нет нужды использую Atom с плагином авто-форматирования при сохранении файла)

- Переходим к работе с реестром модулей

- Создаем конфиг storage-bucket.tf и файлы объявление переменных

- Переименовываем бакеты

- Загружаем и инициализируем новый модуль terraform init

- Применяем конфигурацию
- Проверяем доступность бакетов

  ```sh
  gsutil ls
  gs://storage-bucket-test-1/
  gs://storage-bucket-test-2/
  ```

  ### Task*

- Настраиваем сохранение стейта в удаленном backend дял этого:

  1. Создаем файл backend.tf в директорииях stage:
  2. terraform { backend "gcs" { bucket = "storage-bucket-atsip76-stage или storage-bucket-atsip76-prod в зависимости от директории" prefix = "stage" } }
  3. Инициализируем удаленный backend - terraform init в каждой из дирктории stage∏
  4. Удаляем локальные файлы конфигурации в директориях (prod&stage)terraform.tfstate, terraform.tfstate.backup
  5. Создаем конфигурацию в директори prod и наблюдаем создание стейта default.tfstate в удаленном backend
  6. Удаляем созданную конфигурацию
  7. Создаем конфигурацию в директори stage и наблюдаем создание стейта default.tfstate в удаленном backend
  8. Удаляем созданную конфигурацию
  9. Проверяем работу блокировки запустив одновременно несколько apply конфигурации

  ### Task**

  - Правим db.json для копирования конфига mongodb с параметром открыть соединения на порту на всех интерфейсах
  - Правим скрипт деплоя БД с учетом нового конфига
  - Запекаем новые образы
  - Объявляем дополнительную переменную db_external_ip
  - Правим main.tf в prod&stage добавляем передачу переменной db_external_ip в модуль приложения
  - Правим модуль app в main добавляем провайдеров копирования unit файла, деплоя сервиса с передачей перменной DATABASE_URL
  - Передаем переменную app_external_ip в модуль ДБ для изменения правила файервола с подключением к БД только с IP сервера приложения

### Запуск проекта:

```sh
Выполнить terraform apply в директории terraform/stage или terraform/prod
```

### Проверка развертывания, перейдя по адресу сервера в вашем браузере:

```sh
Открыть в вашем браузере:
app_external_ip - ip address output variable
app_external_ip:9292
```

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
