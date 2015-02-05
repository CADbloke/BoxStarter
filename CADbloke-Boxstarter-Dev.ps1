######################################################
# Before you run this, run http://boxstarter.org/package/url?https://raw.githubusercontent.com/CADbloke/BoxStarter/master/CADbloke-Boxstarter.ps1
######################################################

# This is http://boxstarter.org/package/url?https://raw.githubusercontent.com/CADbloke/BoxStarter/master/CADbloke-Boxstarter-Dev.ps1
# but just run it locally in PowerShell because Chocolatey should already be installed by the previous BoxStarter script

try {

cinst lessmsi  # MSI explorer
cinst fiddler4
cinst wireshark
cinst markdownpad2
cinst linqpad
cinst SublimeText3 
cinst atom # https://atom.io/

######################################################
# Set Folders and Environment Variables
######################################################
Write-Host "Setting Folders and Environment Variables"
if(!(Test-Path "c:\Codez")) { New-Item -Type Directory "C:\Codez"}
if(!(Test-Path "d:\CodezOnD")) { New-Item -Type Directory "d:\CodezOnD"}  # quite useless on an Azure VM

Install-ChocolateyEnvironmentVariable "CODEZ" "c:\codez"
Install-ChocolateyEnvironmentVariable "D-CODEZ" "d:\CodezOnD"
Write-Host

######################################################
# Visual Studio
######################################################
Write-Host "Installing Visual Studio 2013 Ultimate"
cinst VisualStudio2013Ultimate

if (Test-PendingReboot) { Invoke-Reboot }

cinst nunit
cinst xunit
cinst resharper -Version 8.2.3000.5176  # remove version info it you wan the latest
cinst dotpeek
cinst vs2013sdk
cinst wixtoolset

Install-ChocolateyVsixPackage NuGetPackageManager https://visualstudiogallery.msdn.microsoft.com/4ec1526c-4a8c-4a84-b702-b21a8f5293ca/file/105933/7/NuGet.Tools.2013.vsix
Install-ChocolateyVsixPackage CodeAlignment https://visualstudiogallery.msdn.microsoft.com/7179e851-a263-44b7-a177-1d31e33c84fd/file/32256/37/CodeAlignment.vsix
Install-ChocolateyVsixPackage GitSourceControlProvider https://visualstudiogallery.msdn.microsoft.com/63a7e40d-4d71-4fbb-a23b-d262124b8f4c/file/29105/46/GitSccProvider.vsix
Install-ChocolateyVsixPackage IntelliCommand https://visualstudiogallery.msdn.microsoft.com/83f59659-abc1-4bfa-9779-42f687af0481/file/87872/3/IntelliCommand.vsix
Install-ChocolateyVsixPackage MultiEditing https://visualstudiogallery.msdn.microsoft.com/2beb9705-b568-45d1-8550-751e181e3aef/file/93630/8/MultiEdit.vsix
Install-ChocolateyVsixPackage OpeninExternalBrowser https://visualstudiogallery.msdn.microsoft.com/46c0c49e-f825-454b-9f6a-48b216797eb5/file/136677/1/Tvl.VisualStudio.OpenInExternalBrowser.vsix
cinst VS2013.PowerTools
Install-ChocolateyVsixPackage SideWaffle https://visualstudiogallery.msdn.microsoft.com/a16c2d07-b2e1-4a25-87d9-194f04e7a698/referral/110630
Install-ChocolateyVsixPackage SQLCompactToolbox https://visualstudiogallery.msdn.microsoft.com/0e313dfd-be80-4afb-b5e9-6e74d369f7a1/file/29445/72/SqlCeToolbox.vsix
Install-ChocolateyVsixPackage VisualHg2 https://bitbucket.org/lmn/visualhg2/downloads/VisualHg.vsix
Install-ChocolateyVsixPackage cinst VS2013.VSCommands
Install-ChocolateyVsixPackage XAMLstyler https://visualstudiogallery.msdn.microsoft.com/3de2a3c6-def5-42c4-924d-cc13a29ff5b7/file/124126/11/XamlStyler.Package.vsix

######################################################
# Pin the Taskbar icons
######################################################
Write-Host "Pinning Apps to the TaskBar"
Install-ChocolateyPinnedTaskBarItem "$env:programfiles(x86)\Microsoft Visual Studio 12.0\Blend\Blend.exe"
Install-ChocolateyPinnedTaskBarItem "$env:programfiles(x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
Write-Host

}
catch {
  throw $_
}

######################################################
# Windows Updates
######################################################
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

enable-UAC # disbled at the start of this script

Write-ChocolateySuccess 'Dev Cloud VM'
Exit