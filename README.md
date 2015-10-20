# TANGRAM flows examples


This repository contains some flows examples to start interacting with TANGRAM. **The purpose of these examples are to understand the basic principles of how TANGRAM works.**

The source tree includes Batch Windows sources and Unix Bash scripts, which sends XML files to TANGRAM
and prints the response. Using those scripts, you can see the raw requests and responses data, making **easier to debug the flow without programming anything.**

**All the scripts uses cURL**, a command-line tool for transferring HTTP data <sup id="curlHOMEPos">[[1]](#curlHOME)</sup> <sup id="curlWikiPos">[[2]](#curlWiki)</sup>. 


## Prerequisites 

You can find the **base scripts** to send data to TANGRAM in the scripts folder for both Windows and Unix Bash:
>[tangram-flows-examples/scripts/unix/send_request.sh](https://github.com/takenet/tangram-flows-examples/blob/master/scripts/unix/send_request.sh)
>
>[tangram-flows-examples/scripts/windows/send_request.cmd
](https://github.com/takenet/tangram-flows-examples/blob/master/scripts/windows/send_request.cmd)

**The flow examples, however, are all implemented using Shell script**. Therefore, to run those scripts on a Windows environment, you need to install MSYS. 

> **About MSYS <sup id="MSYSPos">[[3]](#MSYS)</sup>:**
> 
> *"MSYS is a collection of GNU utilities such as bash, make, gawk and grep to allow building of applications and programs which depend on traditionally Unix tools to be present. It is intended to supplement MinGW and the deficiencies of the cmd shell."*  [http://www.mingw.org/wiki/msys]

The basic steps to execute the flows are listed below:

- Install MSYS2 on Windows;
- Download tangram-notification-listener;
- Download and extract the flow examples;
- Edit the configuration file;
- Execute the flow sample script.

### Installing MSYS2 (for Windows users)

MSYS2 <sup id="MSYS2Pos">[[4]](#MSYS2)</sup> uses a Wizard setup which only ask to installation path. We recommend using the default path: c:\msys32 on Windows 32 bits or c:\msys64 on a 64 bits installation.

The installation setup are found here:

> [Windows 32 bits](http://repo.msys2.org/distrib/i686/msys2-i686-20150916.exe)
> 
> [Windows 64 bits](http://repo.msys2.org/distrib/x86_64/msys2-x86_64-20150916.exe)

The illustrated installation steps are found [here](http://msys2.github.io/).

Note there will be a new Windows **Start** entry called MSYS2 Shell after installation.

MSYS2 will automatically install cURL on one of the following path depending on the Windows environment:

>C:\msys64\usr\bin
>
>C:\msys32\usr\bin

#### Testing cURL and MSYS2

Open the MSYS2 Shell application and execute:

```sh
curl -I www.take.com.br
```

The output should look like this:

```
HTTP/1.1 200 OK
Date: Mon, 19 Oct 2015 17:45:24 GMT
Server: Apache
X-Powered-By: PHP/5.3.29
Connection: close
Content-Type: text/html
```

### Download tangram-notification-listener

**tangram-notification-listener** <sup id="TNLPos">[[5]](#TNL)</sup> is a console application that listen TANGRAM notification requests at 8181 port and outputs both the request and the response.

> **Note**: You need Java Runtime Environment (JRE) to run the application. You can download Java [here](https://www.java.com/download/).

The purpose of this application is to test the TANGRAM flows quickly. The application outputs raw request and response datas. Along with the scripts presents in this repository, partners can test the asynchronous behavior of TANGRAM.

You can find the binaries of tangram-notification-listener here:

> [tangram-notification-listener-bin](https://github.com/takenet/tangram-notification-listener-bin)

Click on **Download ZIP** button or directly download the latest version [here](https://github.com/takenet/tangram-notification-listener-bin/archive/master.zip).

On your computer, unzip the archive and execute tangram-notification-listener.exe by double clicking. On Unix system, using a terminal console go to the application path and execute the following command:

```
java -jar tangram-notification-listener.jar
```

The application will start and wait for notification requests. Note that the application needs permission the write log files at its own folder. The application will create a subfolder called *log*.

If you like to modify some behavior of the tangram-notifier-listener, you can get the application sources here:

> [tangram-notification-listener](https://github.com/takenet/tangram-notification-listener)

### Download Flow examples

Download the examples [here](https://github.com/takenet/tangram-flows-examples/archive/master.zip) and then extract the files (say to d:/). 

### Edit the configuration file

The configuration file contains a set of variables in a properties file format:

```
NAME_OF_VARIABLE=VALUE_OF_VARIABLE
```

Fill those variables with the proper values. Some of those variables are provided by Takenet and others don't, but all of them have comments on top explaining the meaning of each one.

### Execute the flow sample script

To execute the scripts go the path in which the files were extracted.

```
cd /d/tangram-flows-examples-master/
```

> **MSYS2 note (Windows users)**:
> 
> To navigate in the folders, you need to use the [Unix path style](https://en.wikipedia.org/wiki/Path_%28computing%29#Unix_style). MSYS2 automatically maps Windows drives:
> 
> **C:\\tangram-flows-examples-master** is mapped to **/c/tangram-flows-examples-master**
>
> **D:\\tangram-flows-examples-master** is mapped to **/d/tangram-flows-examples-master**
>
> Others drivers are mapped accordingly.

#### Provisioning example

```
cd /d/tangram-flows-examples-master/provisioning/subscribre_channel
```

Using **ls** to list the directory, you will see the Bash files containing one example for subscribe and one for unsubscribe. These scripts uses the templates files (inside templates folder) and the properties file to generate the requests.

```
ls
provisioning_subscribe_channel2.sh
provisioning_unsubscribe_channel2.sh
tangram.properties.txt
templates
```

Then, edit the file **tangram.properties.txt** and fill the properties values with the proper values. Note that **you need a valid internet address** to receive the TANGRAM notifications with tangram-notification-listener.

To execute the subscribe channel exemple, do as follow:

```
sh provisioning_subscribe_channel2.sh
```

# References
<a name="curlWiki">1</a>. [cURL](https://en.wikipedia.org/wiki/CURL). [↩](#curlWikiPos) 

<a name="curlHOME">2</a>. [Command line tool for transferring data with URL syntax](http://curl.haxx.se/). [↩](#curlHOMEPos) 

<a name="MSYS">3</a>. [Minimalist GNU for Windows](http://www.mingw.org/). [↩](#MSYSPos)

<a name="MSYS2">4</a>. [A Cygwin-derived software distro for Windows using Arch Linux's Pacman](http://sourceforge.net/projects/msys2/). [↩](#MSYS2Pos)

<a name="TNL">5</a>. [TANGRAM notification listener application](https://github.com/takenet/tangram-notification-listener). [↩](#TNLPos)
