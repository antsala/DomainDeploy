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

function CreateADUser(){
    param([Parameter(Mandatory=$true)] $userObject)

    # Tomo el nombre y el password del usuario.
    $name = $userObject.name
    $password = $userObject.password

    # Generamos diversos atributos del usuario.
    $firstName, $lastName = $name.Split(" ")
    $userName = ($firstName[0] + $lastName).ToLower()
    $samAccountName = $userName
    $userPrincipalName = "$userName@$Global:domain"

    # Creo el usuario en ADDS, si no existe
    try {
        New-ADUser `
            -Name $name `
            -GivenName $firstName `
            -Surname $lastName `
            -SamAccountName $samAccountName `
            -UserPrincipalName $userPrincipalName `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force)

        Write-Output "Se ha creado el usuario $name"
    } catch {
        Write-Warning "Error al crear el usuario $name. Puede que ya exista"
        return
    }

    # Añadimos al usuario a los grupos a los que pertenece.
    foreach ($group in $userObject.groups) {
        try {
            Add-ADGroupMember `
                -Identity $group `
                -Members $username

            Write-Output "El usuario $name se ha hecho miembro del grupo $group."
        }
        catch {
            Write-Warning "El usuario $name no se puede hacer miembro del grupo $group. Puede que ya lo sea."
        }
    }
}


# Objeto JSON que contiene el esquema de ADDS.
$json = (Get-content $jsonFile | ConvertFrom-JSON)

# Nombre del dominio.
$Global:domain = $json.domain

foreach ($group in $json.groups) {
    CreateADGroup $group
}

foreach ($user in $json.users) {
    CreateADUser $user
}
