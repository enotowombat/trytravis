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

### Создание шаблона с использованием перменных
``` $ packer build -var 'project_id=infra-188820' -var 
'source_image_family=ubuntu-1604-lts' -var-file=variables.json ubuntu16.json
```
