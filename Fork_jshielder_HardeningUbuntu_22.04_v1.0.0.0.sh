#!/bin/bash

# JShielder v2.4
# Deployer for Ubuntu Server 18.04 LTS y adaptado a proyectoFOC POR J Martín
#

source helpers.sh
##############################################################################################################

f_banner(){
echo
echo "Creado para Ubuntu Server 18.04 LTS Developed By Jason Soto @Jsitech"
echo "Filtrado y adaptado por JMartín"
echo
echo

}

##############################################################################################################

# Compruebe si se ejecuta con el usuario root

clear
f_banner

check_root() {
if [ "$USER" != "root" ]; then
      echo "Permiso denegado"
      echo "Solo se puede ejecutar por root"
      exit
else
      clear
      f_banner
      jshielder_home=$(pwd)
      cat templates/texts/welcome
fi
}

##############################################################################################################

# Instalando Dependencies
# Se establecerán requisitos necesarios aquí

install_dep(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Descargar requisitos previos"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   
   add-apt-repository universe
   
}

##############################################################################################################

# Configurar el nombre de host
config_host() {
echo -n " ¿Desea establecer un nombre de host?(y/n): "; read config_host
if [ "$config_host" == "y" ]; then
    serverip=$(__get_ip)
    echo " Escriba un nombre para identificar este servidor:"
    echo -n " (Por ejemplo: myserver): "; read host_name
    echo -n " ¿Tipo de nombre de dominio?: "; read domain_name
    echo $host_name > /etc/hostname
    hostname -F /etc/hostname
    echo "127.0.0.1    localhost.localdomain      localhost" >> /etc/hosts
    echo "$serverip    $host_name.$domain_name    $host_name" >> /etc/hosts
    # Creación de pancartas legales para el acceso no autorizado
    echo ""
    echo "Creación de pancartas legales para el acceso no autorizado"

    cat templates/motd > /etc/motd
    cat templates/motd > /etc/issue
    cat templates/motd > /etc/issue.net
    sed -i s/server.com/$host_name.$domain_name/g /etc/motd /etc/issue /etc/issue.net
    echo "OK "
fi
    
}

##############################################################################################################

# Configurar la zona horaria
config_timezone(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Ahora configuraremos la zona horaria"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   sleep 10
   dpkg-reconfigure tzdata
   
}

##############################################################################################################

# Actualizar el sistema
update_system(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Actualización del sistema"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   apt update
   # apt upgrade -y
   # apt dist-upgrade -y
   
}

##############################################################################################################

# Establecer un umask más restrictivo
restrictive_umask(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Establecer Umask a un valor más restrictivo (027)"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
  
   cp templates/login.defs /etc/login.defs
   echo ""
   echo "OK"
   
}

#############################################################################################################

# Deshabilitar los sistemas de archivos no utilizados

unused_filesystems(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Deshabilitar los sistemas de archivos no utilizados"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   spinner
   echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
   echo " OK"
   
}

##############################################################################################################

uncommon_netprotocols(){
   clear
   f_banner
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo -e "\e[93m[+]\e[00m Desabilitar protocolos de red no usados"
   echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
   echo ""
   
   echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
   echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
   echo " OK"
   

}


##############################################################################################################

# Establecer reglas iptables
set_iptables(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Configuración de reglas iptables"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -n " Configurar reglas de iptables ..."
    
    apt install iptables
    sh templates/iptables.sh
    cp templates/iptables.sh /etc/init.d/
    chmod +x /etc/init.d/iptables.sh
    ln -s /etc/init.d/iptables.sh /etc/rc2.d/S99iptables.sh
    
}

##############################################################################################################

# Install fail2ban
    # To Remove a Fail2Ban rule use:
    # iptables -D fail2ban-ssh -s IP -j DROP
install_fail2ban(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing Fail2Ban"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt install sendmail
    apt install fail2ban
    touch /var/log/auth.log
    
}


##############################################################################################################

# Configure fail2ban

config_fail2ban(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Configurar Fail2Ban cambiar dirección de correo en fichero"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo " Configuring Fail2Ban......"
    
    sed s/MAILTO/$inbox/g templates/fail2ban > /etc/fail2ban/jail.local
    cp /etc/fail2ban/jail.local /etc/fail2ban/jail.conf
    /etc/init.d/fail2ban restart
    
}

##############################################################################################################


# Instalar RootKit Hunter

install_rootkit_hunter(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Instalación de RootKit Hunter"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Rootkit Hunter es una herramienta de escaneo para asegurarse de que está limpio de herramientas desagradables.Esta herramienta escanea para RootKits, Backdoors y Exploits locales ejecutando pruebas como:
          - MD5 Hash Compare
          - Busque archivos predeterminados utilizados por rootkits
          - Permisos de archivo incorrectos para binarios
          - Busque cuerdas sospechosas en los módulos LKM y KLD
          - Busque archivos ocultos
          - Escaneo opcional dentro de los archivos de texto sin formato y binarios "
    sleep 1
    cd rkhunter-1.4.6/
    sh installer.sh --layout /usr --install
    cd ..
    rkhunter --update
    rkhunter --propupd
    echo ""
    echo " ***Para ejecutar RootKit Hunter ***"
    echo "     rkhunter -c --enable all --disable none"
    echo "    Informe detallado /var/log/rkhunter.log"
    
}


##############################################################################################################

# Install PortSentry

install_portsentry(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Installing PortSentry"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    apt install portsentry
    mv /etc/portsentry/portsentry.conf /etc/portsentry/portsentry.conf-original
    cp templates/portsentry /etc/portsentry/portsentry.conf
    sed s/tcp/atcp/g /etc/default/portsentry > salida.tmp
    mv salida.tmp /etc/default/portsentry
    /etc/init.d/portsentry restart
    
}

##############################################################################################################

# Pasos de endurecimiento adicionales

additional_hardening(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Ejecutando pasos de endurecimiento adicionales"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Ejecutando pasos de endurecimiento adicionales ...."
    echo " Cambiando permisos de carpeta root"
    echo " Cambiando fichero carpeta grub.cfg"
    echo
    chmod 700 /root
    chmod 600 /boot/grub/grub.cfg

    echo " Desinstalamos comando AT"
    apt purge at
    
    echo " Asegurando cron "
    touch /etc/cron.allow
    chmod 600 /etc/cron.allow
    awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/cron.deny
    echo ""
    echo -n " ¿Quiere deshabilitar el soporte USB para este servidor?(y/n): " ; read usb_answer
    if [ "$usb_answer" == "y" ]; then
       echo ""
       echo "Deshabilitar el soporte USB"
       
       echo "almacenamiento USB de la lista negra" | sudo tee -a /etc/modprobe.d/blacklist.conf
       update-initramfs -u
       echo "OK"
       
    else
       echo "OK"
       
    fi
}

##############################################################################################################

# Herramienta de deteccion rootkits
install_unhide(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Instalo unhide"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Unhide es una herramienta forense para encontrar procesos ocultos y puertos TCP / UDP por rootkits / LKMS o por otra técnica oculta."
    sleep 1
    apt -y install unhide
    echo ""
    echo " Unhide es una herramienta para detectar procesos ocultos "
    echo "Para obtener más información sobre la herramienta, use las páginas de manejo"
    echo "man unhide"
    say_done
}

##############################################################################################################

# Tiger
# Tiger herramienta de detección de intrusos
install_tiger(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Instalación de tiger"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Tiger es una herramienta de seguridad que se puede usar tanto como un sistema de auditoría de seguridad como de detección de intrusos"
    sleep 1
    apt -y install tiger
    echo ""
    echo " Para obtener más información sobre la herramienta, use las páginas de manejo "
    echo " man tiger "
    
}

##############################################################################################################


# Deshabilitar compiladores
disable_compilers(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Disabilitar compiladores cambiando permisos"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo "Disabling Compilers....."
   
    chmod 000 /usr/bin/as >/dev/null 2>&1
    chmod 000 /usr/bin/byacc >/dev/null 2>&1
    chmod 000 /usr/bin/yacc >/dev/null 2>&1
    chmod 000 /usr/bin/bcc >/dev/null 2>&1
    chmod 000 /usr/bin/kgcc >/dev/null 2>&1
    chmod 000 /usr/bin/cc >/dev/null 2>&1
    chmod 000 /usr/bin/gcc >/dev/null 2>&1
    chmod 000 /usr/bin/*c++ >/dev/null 2>&1
    chmod 000 /usr/bin/*g++ >/dev/null 2>&1
    
    echo ""
    echo " Si se quieren usar es simplemente cambiar permisos"
    echo " Example: chmod 755 /usr/bin/gcc "
    echo " OK"
    
}

##############################################################################################################

# Habilitar auditoría de procesos

enable_proc_acct(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Habilitar auditoría de procesos"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install acct
  touch /var/log/wtmp
  echo "OK"
}

##############################################################################################################

# Instalar y habilitar Auditd

install_auditd(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Instalando auditd"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install auditd

  # Uso de la configuración de referencia CIS
  
  # Asegurar la auditoría de los procesos que se inician antes de Auditd está habilitado

  echo ""
  echo "Enabling auditing for processes that start prior to auditd"
  
  sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="audit=1"/g' /etc/default/grub
  update-grub

  echo ""
  echo "Configurando Auditd Rules"
  

  cp templates/audit-CIS.rules /etc/audit/rules.d/audit.rules

  find / -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print \
  "-a always,exit -F path=" $1 " -F perm=x -F auid>=1000 -F auid!=4294967295 \
  -k privileged" } ' >> /etc/audit/rules.d/audit.rules

  echo " " >> /etc/audit/rules.d/audit.rules
  echo "#End of Audit Rules" >> /etc/audit/rules.d/audit.rules
  echo "-e 2" >>/etc/audit/rules.d/audit.rules

  systemctl enable auditd.service
  service auditd restart
  echo "OK"
  
}
##############################################################################################################

# Instalar y habilitar sysstat

install_sysstat(){
  clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Instalando y habilitando sysstat"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  apt install sysstat
  sed -i 's/ENABLED="false"/ENABLED="true"/g' /etc/default/sysstat
  service sysstat start
  echo "OK"
  
}

##############################################################################################################


set_grubpassword(){
  
echo -e ""
echo -e "Asegurando arranque : Boot Settings"

sleep 2
chown root:root /boot/grub/grub.cfg
chmod og-rwx /boot/grub/grub.cfg
say_done

}    

##############################################################################################################

file_permissions(){
 clear
  f_banner
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo -e "\e[93m[+]\e[00m Configuración de permisos de archivo en archivos críticos del sistema"
  echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
  echo ""
  
  sleep 2
  chmod -R g-wx,o-rwx /var/log/*

  chown root:root /etc/ssh/sshd_config
  chmod og-rwx /etc/ssh/sshd_config

  chown root:root /etc/passwd
  chmod 644 /etc/passwd

  chown root:shadow /etc/shadow
  chmod o-rwx,g-wx /etc/shadow

  chown root:root /etc/group
  chmod 644 /etc/group

  chown root:shadow /etc/gshadow
  chmod o-rwx,g-rw /etc/gshadow

  chown root:root /etc/passwd-
  chmod 600 /etc/passwd-

  chown root:root /etc/shadow-
  chmod 600 /etc/shadow-

  chown root:root /etc/group-
  chmod 600 /etc/group-

  chown root:root /etc/gshadow-
  chmod 600 /etc/gshadow-


  echo -e ""
  echo -e "Setting Sticky bit on all world-writable directories"
  sleep 2
  

  df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t

  echo " OK"
  say_done

}
##############################################################################################################

# Reboot Server
reboot_server(){
    clear
    f_banner
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[93m[+]\e[00m Paso final"
    echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    sed -i s/USERNAME/$username/g templates/texts/bye
    sed -i s/SERVERIP/$serverip/g templates/texts/bye
    cat templates/texts/bye
    echo -n " ¿Were you able to connect via SSH to the Server using $username? (y/n): "; read answer
    if [ "$answer" == "y" ]; then
        reboot
    else
        echo "Servidor reiniciará "
        echo "Bye."
    fi
}

##################################################################################################################

clear
f_banner
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[93m[+]\e[00m Selecciona la opción deseada"
echo -e "\e[34m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo "1. Blindaje sistema operativo"

echo 

echo "8. Exit"
echo

read choice

case $choice in

1)
check_root
install_dep
config_host
config_timezone
update_system
restrictive_umask
unused_filesystems
uncommon_netprotocols
admin_user
set_iptables
install_fail2ban
config_fail2ban
additional_packages
install_rootkit_hunter
additional_hardening
install_unhide
install_tiger
disable_compilers
enable_proc_acct
install_sysstat
set_grubpassword
file_permissions
reboot_server
;;



8)
exit 0
;;

esac
##############################################################################################################