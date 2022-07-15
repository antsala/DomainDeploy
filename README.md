# Objetivo

La idea es crear un entorno de ADDS sobre el que poder hacer labs de seguridad. Esta guía requiere crear dos máquinas virtuales, una de ellas será un ***Controlador de dominio*** desplegado en versión ***Server Core***. La segunda VM es un ***Windows 11*** se que será usado para configurar el dominio y hacer los labs.

## 1. Crear el DC.

Crear en el entorno de virtualización una VM que hará de DC con la siguiente configuración:

* Sistema operativo WS 2022 Standard Server Core.
* IP 192.168.20.10/24, conectado a la red de laborarorio.
* GW 192.168.20.1
* DNS 8.8.8.8
* Habilitar WinRM y PoswerShell Remoto.

Toda esta configuración se puede hacer desde la utilidad ***sconfig***


## 2. Crear VM de W11 

En el entorno de virtualización, crear una máquina con sistema operativo ***Windows 11 Pro*** con la siguiente configuración:

* Sistema operativo Windows 11 pro.
* [Saltar comprobación del TPM](https://winbuzzer.com/tag/how-to-install-windows-11-without-tpm/)
* IP 192.168.20.11/24, conectado a la red del laboratorio.
* GW 192.168.20.1
* DNS 8.8.8.8
* Renombrar a ***WS11***
* Agregar 192.168.20.10 a lista [TrustedHosts](https://www.dtonias.com/add-computers-trustedhosts-list-powershell/)
* Instalar [Chocolatey](https://chocolatey.org/install)
* Instalar con Chocolatey ***git*** y ***vscode***.


## 3. Clonar repo git y ejecutar script de despliegue de ADDS.

En la ***VM de W11***, clonar el repo de git con el siguiente comando

```
git clone https://github.com/antsala/DomainDeploy.git
```

Ejecutar el script de despliegue de ADDS, usando las credenciales ***Administrator*** y ***Pa55w.rd***.
Nota importante: Como ***XYZ-DC1*** se reiniciará, la sesión remota se romperá. Ignorar este error.

```
.\deployADDS.ps1
```


## 4. Crear instantánea.

Aseguramos la configuración actual creando una instantánea en el entorno de virtualización. Para garantizar la coherencia de la instantánea, apagamos ***XYZ-DC1***. Posteriormente creamos una instantánea, que podemos llamar ***ADDS desplegado***. Una ver realizada, iniciamos de nuevo ***XYZ-DC1***.


## 5. Agregar ***W11*** al dominio.

Seguimos en la máquina virtual ***W11***, ahora vamos a agregarla al dominio. Para ello necesitamos que su resolvedor DNS apunte a ***XYZ-DC1***. Ejecutamos el script ***configIP.ps1*** usando la credencial ***xyz\administrator*** y ***Pa55w.rd***.

Nota: Al finalizar el script, el equipo se reiniciará. Una vez unido al dominio, iniciamos sesión con la credencial ***xyz\administrator*** y ***Pa55w.rd***.

```
.\configIP.ps1
```

## 6. Clonar el repo git en el perfil del administrador de ***W11***.

Para tener disponinbles la carpeta de scripts, abrimos una sesión de PowerShell y ejecutamos el siguiente comando en la máquina virtual ***W11***:

```
git clone https://github.com/antsala/DomainDeploy.git
```

## 7. Instalar RSAT en ***W11***.

Como ***XYZ-DC1*** es un ***Server Core*** no tiene interfaz gráfica. Toda la administración la haremos desde la máquina ***W11**. Nos aseguramos que estamos en ***W11*** y ejecutamos el siguiente script.

```
.\installRSAT.ps1
```

# 8. Crear instantáneas.
#
# Apagar XYZ-DC1 y WS11. Crear instantánea "Dominio creado".

# 9. Crear objetos en el esquema de ADDS.
#
# Desde la VM W11, asegurar que se pueden ejecutar scripts

Set-ExecutionPolicy -ExecutionPolicy unrestricted

# Ejecutar el siguiente script.
.\CreateObjects.ps1 .\ADDS_Schema.json
