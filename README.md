#cloud-testapp 
testapp_IP = 35.197.224.89
testapp_port = 9292

#*1
Для автоматического деплоя приложения при создании инстанса использованн примитивный линейный бэш скрипт
script=startup-script.sh
передающийся в качестве доп. аргумента при создании инстанса из gcloud консоли:
gcloud compute instances create reddit-app  --boot-disk-size=10GB   --image-family ubuntu-1604-lts   --image-project=ubuntu-os-cloud   --machine-type=g1-small   --tags puma-server   --restart-on-failure --metadata-from-file startup-script=startup-script.sh
опция - --metadata-from-file startup-script=startup-script.sh с указанием абсолютного пути до скрипта (в данном случае находящийся в текущей дире)

#*2
Правило файрвола создаем из консоли командой:
gcloud compute firewall-rules create default-puma-server --action allow --target-tags puma-server --direction ingress --source-ranges 0.0.0.0/0 --rules tcp:9292

Указывая правильные тегиб, сетки, направление фильтра, протокол, порт

