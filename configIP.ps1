$DCIPAddress = '192.168.20.10'

# Tomamos credenciales
$cred = Get-Credential

# Tomamos índice de la interfaz de la tarjeta de red.
$ifIndex = (Get-NetAdapter).ifIndex

# Ponemos como servidor DNS a XYZ-DC1.
Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses $DCIPAddress

# Probamos la resolución DNS.
Test-Connection 'xyz-dc1.xyz.com'

# Añadimos equipo al dominio.
Add-Computer `
    -DomainName 'xyz.com' `
    -Credential $cred `
    -Restart `
    -Force 



