# Objetivo

La idea es crear un entorno de ADDS sobre el que poder hacer labs de seguridad. Esta guía requiere crear dos máquinas virtuales, una de ellas será un **Controlador de dominio** desplegado en versión **Server Core**. La segunda VM es un **Windows 11** se que será usado para configurar el dominio y hacer los labs.

## 1. Crear el DC.

Crear en el entorno de virtualización una VM que hará de DC con la siguiente configuración:

    * Sistema operativo WS 2022 Standard Server Core.
    * IP 192.168.20.10/24, conectado a la red de laborarorio.
    * GW 192.168.20.1
    * DNS 8.8.8.8
    * Habilitar WinRM y PoswerShell Remoto.

Toda esta configuración se puede hacer desde la utilidad **sconfig**




# 2. Crear una VM de W11 con la siguiente configuración.
#
#   Sistema operativo Windows 11 pro.
#   Saltar comprobación TPM (https://winbuzzer.com/tag/how-to-install-windows-11-without-tpm/)
#   IP 192.168.20.11/24, conectado a la red de laboratorio.
#   GW 192.168.20.1
#   DNS 8.8.8.8
#   Renombrar a 'WS11'
#   Agregar 192.168.20.10 a lista TrustedHosts (https://www.dtonias.com/add-computers-trustedhosts-list-powershell/)
#   Instalar Chocolatey (https://chocolatey.org/install)
#   Instalar con Chocolatey 'git' y 'vscode'.


# 3. Clonar repo git y ejecutar script de despliegue de ADDS.
#
#   En la *VM de W11*, clonar el repo de git.

git clone https://github.com/antsala/DomainDeploy.git

# Ejecutar el script de despliegue de ADDS.
# Nota: Usar credenciales 'Administrator' y 'Pa55w.rd'
# Importante: Como XYZ-DC1 se reiniciará, la sesión remota se romperá. Ignorar este error.

.\deployADDS.ps1

# 4. Crear instantánea.
#
#   Apagar XYZ-DC1, crear instantánea "ADDS desplegado", iniciar XYZ-DC1.


# Seguimos en la *VM de W11*, ahora vamos a agregarla al dominio.

# 5. Cambiar el servidor DNS de W11 para que contacte con 192.168.20.10
# 
# Ejecutamos el script usando como credencial 'xyz\administrator' y 'Pa55w.rd'
# Nota: Al finalizar el script, el equipo se reiniciará. Una vez en el dominio
#       iniciar sesión con la credencial 'xyz\administrator' y 'Pa55w.rd'.

.\configIP.ps1

# 6. Volver a clonar el git en el perfil del administrador.
#
# Abrir una sesión de PowerShell y ejecutar lo siguiente:

git clone https://github.com/antsala/DomainDeploy.git

# 7. Instalar RSAT.
#
# Ejecutar el siguiente script.

.\installRSAT.ps1

# 8. Crear instantáneas.
#
# Apagar XYZ-DC1 y WS11. Crear instantánea "Dominio creado".

# 9. Crear objetos en el esquema de ADDS.
#
# Desde la VM W11, asegurar que se pueden ejecutar scripts

Set-ExecutionPolicy -ExecutionPolicy unrestricted

# Ejecutar el siguiente script.
.\CreateObjects.ps1 .\ADDS_Schema.json
