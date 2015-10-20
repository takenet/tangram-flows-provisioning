#/bin/bash
# This script sends a request to TANGRAM.
#
# To use this script YOU *MUST* install curl.
# To install on Windows, go to http://sourceforge.net/projects/msys2/
# and choose the C:\msys64 installation path.
#
# Usage: 
#       send_request.cmd provisioning_request.xml
#
# author: Andre Gomes, Takenet

# set the request and response content type]
export HEADER_CONTENT="application/xml"
export HEADER_ACCEPT="application/xml"

# set the username and password
export HEADER_PASS="pass"
export HEADER_USER="user"

# Check if XML command line argument
if [ -z ${1} ]; then
	echo "Input file was not specified"
	echo "Usage: ${0} FILE.XML"
	exit -1
else
	POST_XML_FILE=${1}
fi

# if not specified, choose the default URL
if [ -z ${2} ]; then
	URL_TARGET="https://TANGRAM_ADDRESS/"
else
	URL_TARGET=${2}
fi

# send the request via HTTP POST
curl -D - -X POST\
	-HContent-type:${HEADER_CONTENT} \
	-HAccept:${HEADER_ACCEPT}\
	-HTANGRAM_USER:${HEADER_USER}\
	-HTANGRAM_PASSWORD:${HEADER_PASS}\
	--data @${POST_XML_FILE}\
	${URL_TARGET}
