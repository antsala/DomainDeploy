# Configuración de ADDS
#
# 1. Crear una VM que hará de DC con la siguiente configuración:
#
#   Sistema operativo WS 2022 Standard Server Core.
#   IP 192.168.20.10/24, conectado a la red de laborarorio.
#   GW 192.168.20.1
#   DNS 8.8.8.8
#   Habilitar WinRM y PoswerShell Remoto.
#
# 2. Crear una VM de W11 con la siguiente configuración.
#
#   Sistema operativo Windows 11 pro.
#   Saltar comprobación TPM (https://winbuzzer.com/tag/how-to-install-windows-11-without-tpm/)
#   IP 192.168.20.11/24, conectado a la red de laboratorio.
#   GW 192.168.20.1
#   DNS 8.8.8.8
#   Agregar 192.168.20.10 a lista TrustedHosts (https://www.dtonias.com/add-computers-trustedhosts-list-powershell/)
#   Instalar Chocolatey (https://chocolatey.org/install)
#   Instalar con Chocolatey 'git' y 'vscode'.