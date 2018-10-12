# Terraform Automation

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Terraform automation build for AWS services. We need following components.
  - Java JDK/JRE - 8
  - Jenkins
  - Terraform

### Installation

I have followed [website][PlDb] for making my jenkins installation.

```sh
$ cd /tmp && wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
$ echo 'deb https://pkg.jenkins.io/debian-stable binary/' | sudo tee -a /etc/apt/sources.list.d/jenkins.list
$ sudo apt update
$ sudo apt install jenkins
```

Next I have installed terraform  [official website][PlGh]

```sh
$ wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
$ sudo apt-get install unzip
$ unzip terraform_0.11.1_linux_amd64.zip 
$ sudo mv terraform /usr/local/bin/
````
I have made 2 appraches separately 

- For each commit make some terraform actions
- Maual invocation of terraform script according to the environment variables

First Approach:

 - Open jenkins select on create new item
 - Select job type as multibranch pipeline
 - Add your git repo , username and password or how ever you want to access your project
 - Select the interval to which it needs to poll
 - Save the project 
 
 You're ready with your job which does polling based on commits and does the processing 

Second Approach:
- Create a new pipeling job
- Add a parameter accepting vaariable which environment options using choice parameter
- Add a new pipeline script
- The script executes terraform commands by using the envionment variables using user_input

This is a controlled way for doing the job.

The job configuration for the jenkins are given in the jobs folder of the repo

**Lots of ways, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [PlDb]: <https://websiteforstudents.com/install-jenkins-on-ubuntu-16-04-17-10-18-04-lts-server/>
   [PlGh]: <https://www.terraform.io/intro/getting-started/install.html>
 
