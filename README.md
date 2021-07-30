
# Welcome to Click Media's DevOps skills assessment.

# Linux
* What is the command to list the contents of a direcory, line by line and ordered by size ascending in human readable format?

```sh
ls -lhrS
```

* How would you add a DNS server to a network interface in Linux?
    * Update file `/etc/resolv.conf` with your DNS ip address.
```
nameserver 8.8.8.8
nameserver 1.1.1.1
```

* If the DNS server you've just added is not reachable, how can you get any particular hostname to resolve locally? 
    * By updating a local file called `/etc/hosts` and update it with a line like the below:
```
192.168.3.131 myserver.domain myserver
```

* How would you check for SELinux related errors?
    * Mostly by check error logs under `/var/log/audit/audit.log`. But most of the time the actuall errors can be found by running:
```sh
journalctl -t setroubleshoot
sealert -l $MESSAGE_NUMBER
```

* Write the commands to add 30GB disk space to a logical volume named "clickmedia" that belongs to a logical group named "clickmedia-group".
```sh
lvcreate -y -L 30G -n docker-group/docker 
```

* In the root of this repository, create a Bash script called "listit.sh", when executed, this script must do the following (in order):
    * Create a file called directories.list that contains the directory names only of the current directory.
    * Add a line at the beginning of the directories.list file that reads "line one's line".
    * Output the first three lines of directories.list on the console.
    * Accept an integer parameter when executed and repeat the previous question's output x amount of times based on the parameter provided at execution.
* Commit and push your changes.

# Docker
* In the root of this repository, create a Dockerfile that is based on the latest mariadb image.
    * Expose port 3307.
    * Define an evironment variable called BRUCE with a value of WAYNE.
    * Run a command that will output the value from BRUCE into a file called BATCAVE in the root directory of the container. 
* Create a Bash script in the root of this repository called FLY.sh that will do the following:
    * Install Docker if it is not yet installed.
    * Ensure the installed version of Docker is the latest version available.
    * Start a container using the image you've craeted above with your Dockerfile - this container must run as follows:
        * It must be named ALFRED.
        * It must mount /var/lib/mysql to the host operating system to /var/lib/mysql.
        * It must mount /BATCAVE to the host operating system.
    * Checks whether a container exists called ALFRED and if it does, removes an recreates it.
    * Create a schema in the database called "clickmedia" with one table in it called "users" with columns "ID" and "Name".
    * Insert an entry with ID "50" and Name "BATMOBILE".
* Create an encrypted file called "secret" in the root of this repository that contains the root password of the database (the password must be "clickmediasecurepassword123456789!").
* Change your Bash script to start the conainer using the root password from the "secret" file.
* Commit and push your changes.

# General
* How would you ensure any change made to this Dockerfile is source controlled, approved, tested and deployed. Explain which tools you will use as if this was going into a production environment.
    * By utilising CI/CD pipeline tools such as `Drone`, `Jenkins` or `Travis`.
    * And using git webhooks to auto build and test, perform git push to non master branch and only approve master merges when tests are done and
	  authorised by some approvers.
	* A simple pre-production tests can use also docker-compose to test the deployment workflow.
	* Upon success a configuration management tool like: `Ansible` and `Puppet` can be used to deploy to production and applied to specific hosts.
* Commit and push your changes.
