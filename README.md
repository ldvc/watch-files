watch-files
===========

Brief script to keep track of created files in specified directory.

Installation
------------

1. First, clone the project in your favorite folder (assuming git is already installed) :
> cd /home/jdoe/ && git clone https://github.com/ldvc/watch-files

2. Create symlinks (or copy files) in order to have correct environment :
> sudo ln -s /home/jdoe/watch-files/watch-files.conf /etc
> 
> sudo ln -s /home/jdoe/watch-files/*.sh /usr/local/bin
> 
> sudo ln -s /home/jdoe/watch-files/*.cron /etc/cron.d
>
> sudo ln -s /home/jdoe/watch-files/*.init /etc/init.d
