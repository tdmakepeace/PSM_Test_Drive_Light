## TestDrive Light Set up ...


Based on Ubuntu 20.04, 22.04 or 24.04, but should work on other Ubuntu versions. 

1. Run the ELK install and setup on the host first.
You need to have completed the ELK install first. - you can run the script below and select the options defined.

```
wget -O ELK_Install_Ubuntu_script.sh  https://raw.githubusercontent.com/tdmakepeace/ELK_Single_script/refs/heads/main/ELK_Install_Ubuntu_script.sh && chmod +x ELK_Install_Ubuntu_script.sh  &&  ./ELK_Install_Ubuntu_script.sh

```

Option B - sets up all the dependencies and installs base services and requires a reboot. \
Option E - Installs the ELK, the logstash passer and dashboards. \


2. Clone this Repo and then run the following option.

wget -O TestDrive_Install_script.sh  https://raw.githubusercontent.com/tdmakepeace/PSM_Test_Drive_Lightrefs/heads/main/TestDrive_Install_script.sh && chmod +x TestDrive_Install_script.sh  &&  ./TestDrive_Install_script.sh


```
cd testdrive/Setup
cd PowerShell_On_Linux



```

