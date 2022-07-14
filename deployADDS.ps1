# Dirección IP del controlador de dominio.
$DCIPAddress = '192.168.20.10'

# Tomamos credenciales
$cred = Get-Credential

# Abrimos sesión remota de PS contra XYZ-DC1
$session =  New-PSSession -ComputerName $DCIPAddress -Credential $cred

Enter-PSSession -Session $session

# Importamos comandos de despliegue de ADDS.
Import-Module ADDSDeployment

# Desplegamos ADDS

# Password DSRM.
$smap = ConvertTo-SecureString 'Pa55w.rd' -AsPlainText -Force

# Creamos el bosque.
Install-ADDSForest `
    -DomainName 'xyz.com' `
    -SafeModeAdministratorPassword $smap `
    -InstallDns `
    -Force


