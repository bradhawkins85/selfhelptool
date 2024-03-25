This tool generates a simple UI for end users to run self-help tools on their computers. It was developed with SyncroRMM in mind, but it should also work for other uses.

**** This has not been thoroughly tested in all situations so please use at your own risk ****

![image](https://github.com/bradhawkins85/selfhelptool/assets/15325110/b32d37f4-092a-49ad-8df6-4e351c74080f)

selfthelptool.ps1 file is the main UI
selfhelptool.reg file is an empty example of the structure for displaying items in the form.
Encode PS Commands.ps1 is a useful script to convert a PowerShell script to an encoded command to use in the script part of the registry. Leave out the "powershell.exe -EncodedCommand" part when adding to the registry.

Create the registry key HKEY_LOCAL_MACHINE\SOFTWARE\My Company\DIYTools\ then unique kay names under the main key. Items will be shown in the order they are loaded hence the number and , before a guid.

"My Company" in the PS1 file will load as the Display name of the form and will also load from the same company name folder in the registry so adjust accordingly

To encode a script, change the script name, as this will be used as the file name for the completed files and edit the $Command to your script.
The original script will be output as a PS1 file and the encoded command will be output in a text file.
