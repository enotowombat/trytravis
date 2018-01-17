# HW5

### Hosts:
**bastion** ext IP: 35.187.59.2 int IP: 10.132.0.2
**someinternalhost** int IP: 10.132.0.3

**Подключение одной командой:**
```
$ ssh -t -i ~/.ssh/appuser -A appuser@35.187.59.2 ssh 10.132.0.3
```
**Подключение, используя алиас:** `$ ssh internalhost`

Пара вариантов `~/.ssh/config`:

1.
```
Host internalhost
 HostName 10.132.0.3
 User appuser
 ProxyCommand ssh -W %h:%p appuser@35.187.59.2
```
2.
```
Host internalhost
 HostName 35.187.59.2
 User appuser
 IdentityFile ~/.ssh/appuser
 ForwardAgent yes
 PermitLocalCommand yes
 LocalCommand ssh -t -A appuser@35.187.59.2 ssh 10.132.0.3
 ```
# HW6

### Добавляем startup script в создание инстанса

gcloud compute instances create reddit-app-new \
--boot-disk-size=10GB --image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud --machine-type=g1-small \
--tags puma-server --restart-on-failure --zone=europe-west3-a \
--metadata-from-file startup-script=startup.sh

# HW7

### Создание шаблона с использованием переменных
Передаем обязательные переменные в командной строке:
$ packer build -var 'project_id=infra-188820' -var 'source_image_family=ubuntu-1604-lts' ubuntu16.json
Передам переменные в файле:
$ packer build -var-file=variables.json.example ubuntu16.json

### Готовим полный образ
Шаблон immutable.json готовит полный образ reddit-full, остается только создать и запустить инстанс
Скрипт для создания и запуска create-reddit-vm.sh

# HW8

### Terraform. Homework 8

- В metadata проекта добавлен ssh-keys(потому что sshKeys deprecated) для appuser1 - для appuser1 все ок
- В ssh-keys к appuser1 добавлен appuser2 - сначала access denied для appuser2, может потому что был пробел между ключами в metadata resource, убрал, все ок для обоих пользователей
- В вебиннтерфйсе добавлен ключ для appuser_web, для всех пользователй вс ок. После terraform apply ключ appuser_web удаляется, потому что "If you have existing project-wide keys, any keys that you do not include in your list will be removed"

### Terraform. Homework 8. Задание со звездочкой **
1. Добавлено:
- global_forwarding_rule
- target_http_proxy
- url_map
- backend_service
- http_health_check
- instance_group c одним инстансом, уже созданным
- адрес балансера в output
Не добавлено (согласно заданию, но против стандартного подхода):
- instance_group_manager
- instance_template
Приложение доступно по адресу балансировщика. 
Но, при периодичских изменениях и обратных изменениях и применениях main.tf, на тех же параметрах приложение может быть как доступно, так и недоступно (502). Не работает -> поменять что-нибудь -> не работает -> поменять обратно -> работает. Время между проверками было больше, чем (интервал + таймаут)*2 в healh_check. Закоммичен вариант, при котором доступность приложения была
2. Добавлен второй инстанс и его адрес в output. При остановке одного из приложений все запросы отправляются на второй, сервис доступен
Недостаток конфигурации видимо в отсутствии autoscaling со всеми его преимуществами, необходимости вручную прописывать каждый инстанс

# HW9

### Terraform 2


1. Пройдена инструкция:
Созданы ресурсы google_compute_firewall, google_compute_address, образы для app и db (db.json, app.json), в tf разделено создание app и db и организовано модулями. Проверки пройдены

2. Создан модуль vpc

3. Созданы окружения stage и prod

4. Хранение state файла перенесено в remote backend
При переносе prod в prod2 (terraform.tfstate отсутствует) tf определяет состояние правильно
Проверка блокировок:
	1. `terraform apply` в первом терминале: запрос подтверждения
	2. `terraform apply` во втором терминале: Error: Error loading state: writing "gs://remote-backend/prod/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
	Lock Info: ...
	Блокировка появляется сразу после apply, до ввода подтверждения
	3. Отмена в первом терминале
	4. terraform apply во втором терминале: запрос подтверждения. Блокировка снята

5. Добавлены провиженеры в app/main.tf и db/main.tf ("file", "remote-exec"), плюс connection. 
В провиженерах:
- добавлена возможность подключения к MongoDB из локальной сети в дополнение к подключению с localhost(в /etc/mongod.conf в bindIp добавляется интерфейс вутренней сети хоста БД, применяем изменения)
- в юнит puma добавлена переменная окружения Environment=DATABASE_URL, применям изменения. Адрес БД передается с помощью output переменной из модуля db

6. Реестр модулей
Бакеты созданы с уникальными именами
