<#
Robert Chaves Perez (r0b0t95) 2023
.\invoke-nc.ps1 -url '<url>' 
#>

param(
    [string]$url
)

$files = 'netCat.deps.json', 'netCat.dll', 'netCat.exe', 'netCat.pdb', 'netCat.runtimeconfig.json'


if(-Not [string]::IsNullOrEmpty($url)){

    for ($i = 0; $i -lt $files.Length; ++$i){

        $path = 'C:\Users\Public\' + $files[$i]

        $fileUrl = $url + '/' + $files[$i]

        Write-Host $fileUrl

        Invoke-WebRequest -Uri $fileUrl -Outfile $path
     
    }

}