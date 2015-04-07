# symfony2 Vagrant

##Requirements##
Host Machine shall support 64 bit virtualization
For better performance folders are shared using NFS, if you are on windows machine please install cygwin, on OSX NFS Server comes by default. 

##Installation##
Clone repository to your machine, and issue 
vagrant up

While vagrant is being setup, edit your hosts file and enter the following entry

192.168.33.11    symfony2.dev

once the provision has been finished, enter http://symfony2.dev in your browser
