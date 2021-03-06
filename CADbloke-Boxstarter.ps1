# https://gist.github.com/vintem/6334646
function Add-Path() {
    [Cmdletbinding()]
    param([parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)][String[]]$AddedFolder)
    # Get the current search path from the environment keys in the registry.
    $OldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
    # See if a new folder has been supplied.
    if (!$AddedFolder) {
        Return 'No Folder Supplied. $ENV:PATH Unchanged'
    }
    # See if the new folder exists on the file system.
    if (!(TEST-PATH $AddedFolder))
    { Return 'Folder Does not Exist, Cannot be added to $ENV:PATH' }cd
    # See if the new Folder is already in the path.
    if ($ENV:PATH | Select-String -SimpleMatch $AddedFolder)
    { Return 'Folder already within $ENV:PATH' }
    # Set the New Path
    $NewPath=$OldPath+';'+$AddedFolder
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath
    # Show our results back to the world
    Return $NewPath
}

# Begin BoxStarter + Chocolatey

######################################################
# To run this, use Internet Exploder and go to http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/CADbloke/BoxStarter/master/CADbloke-Boxstarter.ps1
######################################################
# moar instructions at http://boxstarter.org/Learn/WebLauncher

# Boxstarter Options
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

# Boxstarter (not Chocolatey) commands
Update-ExecutionPolicy Unrestricted
# Enable-RemoteDesktop  # already enabled on Azure VMs and no thanks for my laptop.
Disable-InternetExplorerESC  #Turns off IE Enhanced Security Configuration that is on by default on Server OS versions
Disable-UAC  # at least until this is over


Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives 
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableShowStartOnActiveScreen -EnableShowAppsViewOnStartScreen -EnableSearchEverywhereInAppsView -EnableListDesktopAppsFirst

if (Test-PendingReboot) { Invoke-Reboot }

disable-computerrestore -drive "C:\"  # http://ss64.com/ps/disable-computerrestore.html  ** Goes >BANG< on Server 2012 but not fatal.
if (Test-PendingReboot) { Invoke-Reboot }

try {
# https://github.com/chocolatey/choco/issues/52
choco feature enable allowInsecureConfirmation

######################################################
# General Apps
######################################################
Write-Host "Installing applications from Chocolatey"
choco install DotNet3.5 # not installed by default on Windows Server 2012
if (Test-PendingReboot) { Invoke-Reboot }

choco install sourcecodepro  # broken: https://chocolatey.org/packages/SourceCodePro#comment-1754540784
choco install notepadplusplus.install
choco install GoogleChrome
choco install 7zip.install
choco install lastpass
choco install sysinternals
choco install paint.net
choco install dropbox
choco install irfanview
choco install foxitreader
choco install vlc
choco install windirstat
choco install clipx  # Clipboard history manager
choco install beyondcompare
choco install ccleaner
choco install malwarebytes
# choco install flashplayeractivex meh
choco install virtualclonedrive
choco install console-devel   # a better CMD
choco install grepwin

######################################################
# Git & Hg
######################################################
choco install tortoisehg
choco install git.install -Version 1.9.2  # Later versions are broken with SVN
choco install tortoisegit
choco install sourcetree
choco install githubforwindows

if (Test-PendingReboot) { Invoke-Reboot }

# https://github.com/chocolatey/choco/issues/86#issuecomment-73439336
choco upgrade all -y


######################################################
# Pin the Taskbar icons
######################################################
Write-Host "Pinning Apps to the TaskBar"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files\IrfanView\i_view32.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Notepad++\notepad++.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files\TortoiseHg\thgw.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Windows\explorer.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files\console\console.exe"
Write-Host

######################################################
# Set Folders and Environment Variables
######################################################
Write-Host "Setting DropBox Environment Variable"
Install-ChocolateyEnvironmentVariable "DROPBOX" "%HOMEPATH%\Dropbox"  # let's see if that works
Write-Host


######################################################
# Add Git to the path
######################################################
Write-Host "Adding Git\bin to the path"
Add-Path "C:\Program Files (x86)\Git\bin"
Write-Host

######################################################
# Set file type associations
######################################################
Write-Host "Setting file type associations"
Install-ChocolateyFileAssociation ".txt" "$env:programfiles\Notepad++\notepad++.exe"
Install-ChocolateyFileAssociation ".log" "$env:programfiles\Notepad++\notepad++.exe"
Install-ChocolateyFileAssociation ".md" "$env:programfiles\MarkdownPad 2\MarkdownPad2.exe"
Write-Host
Write-Host "Finished."

}
catch {
  throw $_
}

Exit
#
# End of Chocolatey
#
###########################################################################################################
