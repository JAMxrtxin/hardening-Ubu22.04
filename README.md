# Scripts básicos para ubuntu 22.04

- El archivo Lamp: monta nginx, apache y php 7.4
- El archivo hardUbu es un scritp de hardening básico para ubuntu linux 22.04 LTS

La carpeta templates, copia ficheros personalizados para asegurar el sistema.

El arvivo hardUbu es un Fork...es una versión de Jshielder para asegurar un ubuntu server vesrion 22.04
En esta versión , he quitado configuraciones no necesarias para levantar un WordPress en mi opinión y alguna configuración demasiado personalizada que no he podido analizar .

***** JSHIELDER es el original en lo que se refiere a el script de hardening *******

El trabajo original que inspira el mío, está en : https://github.com/Jsitech/JShielder
Documentado y explicado en : https://jsitech1.gitbooks.io/jshielder-linux-server-hardening-script/content/jshielder1.html

***** es un MAGNIFICO DE TRABAJO DE JSHIELDER **************************************



Más información sobre como blindar un sistema Linux.
 - https://ubuntu.com/security/certifications/docs
 - Ubuntu chanel -> https://youtu.be/wyEX0eyoK88

_______________________________________________________________________________________________________________

# Asegurar el Sistema operativo y servicios activos
________________________________________________________________________________________________________________

Checklist

PARTICIONES:  Buscar la estabilidad y la seguridad usando LVM

```bash
/
/home
/tmp
/var
/var/log
/var/log/audit
/var/tmp
swap
```



BLINDAJE SISTEMA OPERATIVO 

- [ ] Configurar la ip fija 
- [ ] Asegurar SINGLE USER (arranque seguro) 
- [ ] Configurar el acceso por SSH 
- [ ] ASEGURO SSH, permisos y solo el usuario remoto1 permitido. (/sshd_config) 
- [ ] Añadir y comprobar repositorios  (add-apt-repository universe)
- [ ] Actualizar el sistema 
- [ ] Configurar el nombre del HOST. (/etc/hostname - automatizado en script)
- [ ] Configurar: hora y zona horaria (sudo timedatectl set-timezone Europe/Madrid)
- [ ] Configurar SERVICIOS básicos -ntp (systemctl enable systemd-timesyncd.service  nano /etc/systemd/timesyncd.conf)
- [ ] Definir políticas de acceso para USUARIOS Y GRUPOS  (apt-get install libpam-pwquality)
- [ ] Caducidad o el intervalo de tiempo de cambio de las contraseñas. (nano /etc/pam.d/common-password)
- [ ] Definir permisos de ficheros y directorios por defecto (nano /etc/login.defs
- [ ] Políticas de creación de nuevos usuarios.-/ (Login.defs)
- [ ] Archivo de configuración del perfil - (/etc/profile) 
- [ ] Configuro tiempos de inactividad. (/etc/profile)
- [ ] Ahora aseguramos, las consolas alternativas (/etc/passwd) 
- [ ] Deshabilitar los sistemas de archivos no utilizados. 
- [ ] Deshabilitar los protocolos de red no usados. 

CONFIGURACIÓN DE FIREWALL (Varía según servicios instalados)

PROCESOS EXTRA – AUTOMATIZADOS 

- [ ] Instalación de fail2ban 
- [ ] Instalación RootKit Hunter 
- [ ] Instalación de PortSentry 
- [ ] Asegurar CRON y eliminar el comando AT
- [ ] Deshabilitar el soporte USB 
- [ ] Instalación de UNHIDE 
- [ ] Instalación de TIGER
- [ ] Deshabilitar el uso de COMPILADORES 
- [ ] Configurar la auditoría de procesos 
- [ ] Instalación SYSTAT 
- [ ] Asegurando el arranque del sistema.
