@ECHO OFF
REM # This script sends a request to TANGRAM.
REM #
REM # To use this script YOU *MUST* install curl.
REM # To install, go to http://sourceforge.net/projects/msys2/
REM # and choose the C:\msys64 installation path.
REM #
REM # Usage: 
REM #       send_request.cmd provisioning_request.xml
REM #
REM # author: Andre Gomes, Takenet

REM # include curl to the PATH environment
SET PATH=%PATH%;C:\msys64\usr\bin;C:\msys32\usr\bin

REM # set the request and response content type
SET HEADER_CONTENT=application/xml
SET HEADER_ACCEPT=application/xml

REM # set the username and password
SET HEADER_PASS=pass
SET HEADER_USER=user

REM # Check if XML command line argument
IF %1.==. GOTO Error_Param_File
SET POST_XML_FILE=%1

REM # if not specified, choose the default URL
IF %2.==. (
	SET URL_TARGET=https://TANGRAM_ADDRESS/
) ELSE (
	SET URL_TARGET=%2
)

REM # send the request via HTTP POST
@ECHO ON
curl -D - -X POST^
 -HContent-type:%HEADER_CONTENT%^
 -HAccept:%HEADER_ACCEPT%^
 -HTANGRAM_USER:%HEADER_USER%^
 -HTANGRAM_PASSWORD:%HEADER_PASS%^
 --data @%POST_XML_FILE%^
 %URL_TARGET%
@ECHO OFF

GOTO End_Program

:Error_Param_File
  ECHO Input file was not specified
  ECHO Usage: %0 FILE.XML
GOTO End_Program

:End_Program

REM # wait for user ENTER
PAUSE