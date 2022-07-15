



# Objeto JSON que contiene el esquema de ADDS.
$json = (Get-content $jsonFile | ConvertFrom-JSON)

# Nombre del dominio.
$Global:Domain = $json.domain

foreach ($group in $json.groups) {
    CreateADGroup $group
}

foreach ($user in $json.users) {
    CreateADUser $user
}
