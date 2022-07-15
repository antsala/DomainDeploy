param([Parameter(Mandatory=$true)] $jsonFile)

function CreateADGroup(){
    param([Parameter(Mandatory=$true)] $groupObject)

    # Tomo el nombre del grupo.
    $name = $groupObject.name

    # Creo el grupo en ADDS, si no existe
    try {
        New-ADGroup -name $name -GroupScope Global
        Write-Output "Se ha creado el grupo $name"
    } catch {
        Write-Warning "Error al crear el grupo $name. Puede que ya exista"
    }
}

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
