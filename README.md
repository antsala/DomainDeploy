# Configuración de ADDS
#
# 1. Crear una VM que hará de DC con la siguiente configuración:
#
#   Sistema operativo WS 2022 Standard Server Core.
#   IP 192.168.20.10/24, conectado a la red de laborarorio.
#   GW 192.168.20.1
#   DNS 8.8.8.8
#   Habilitar WinRM y PoswerShell Remoto.


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

# 6. Instalar RSAT.




