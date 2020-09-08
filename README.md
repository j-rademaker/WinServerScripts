# Windows Server Scripts

A collection of scripts made for Windows Server. The goal is to run scripts without having to download them.

## Prerequisites

Start powershell and run the following command:

```powershell 
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Set-ItemProperty -Path “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}” -Name “IsInstalled” -Value 0; Stop-Process -Name Explorer
```

## Usage
The folder structure of this repository indicates what type of scripts it contains. Every folder has their own readme on what each script does and how to run the different scripts. 


## License
[MIT](https://choosealicense.com/licenses/mit/)
