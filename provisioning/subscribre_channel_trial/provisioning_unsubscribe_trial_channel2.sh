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

# define the log location
export LOG_FILE="log/provisioning_trial.log"
mkdir -p log

print_header()
{
	# print header
	echo "-------------------------------------------------------------------------------" | 
	tee -a "${LOG_FILE}"
	date +"%x %X %z" | tee -a "${LOG_FILE}"
	echo | tee -a "${LOG_FILE}"
}

# read the properties file
declare -A props
while IFS='' read -r || [[ -n "$REPLY" ]]
do
	[[ $REPLY = *=* ]] || continue
	[[ $REPLY != "#"* ]] || continue
	props[${REPLY%%=*}]=${REPLY#*=}
done < tangram.properties.txt

# LARGE NUMBER PROVIDED BY TAKENET
export TANGRAM_LA=$(echo "${props[TANGRAM.LA]}")

# CARRIER ID
export TANGRAM_CARRIER_ID=$(echo "${props[TANGRAM.CARRIER.ID]}")

# COMPANY ID PROVIDED BY TAKENET
export TANGRAM_COMPANY_ID=$(echo "${props[TANGRAM.COMPANY.ID]}")

# COMPANY SERVICE ID
export TANGRAM_SERVICE_ID=$(echo "${props[TANGRAM.SERVICE.ID]}")

# COMPANY CHANNEL ID
# **DON'T USE NAVEGATION CHANNEL FOR PROVISIONING**
# EXAMPLES:
#    2 - DIARY
#    3 - WEEKLY
#    4 - MONTHLY
export TANGRAM_CHANNEL_ID=$(echo "${props[TANGRAM.CHANNEL.SIGN.DAY]}")

# OPERATION CODE 
#    1. Check provisioning
#    2. List channel clients
#    3. Subscribe service
#    4. Unsubscribe service
#    5. Subscribe channel
#    6. Unsubscribe channel
export OPERATION_CODE=6
export OPERATION_DESC="Unsubscribe channel"

# DESTINATION NUMBER
export DESTINATION=$(echo "${props[TANGRAM.PROVISIONING.DESTINATION]}")

# AUTO FILLED
export REQUEST_DATETIME=$(date  +%d%m%y%H%M)

# AUTENTICATION TYPE:
#    0 - By customer (Via SMS MO)
#    1 - 1.	By site (via site web ou wap)
export AUTH_TYPE=$(echo "${props[TANGRAM.PROVISIONING.AUTH.TYPE]}")

# NOTIFICATION TYPE (bitwise):
#    1 - SMSC_SUCCESS
#    2 - SMSC_FAIL
#    3 - SMSC_ALL
#    4 - DELIVERY_SUCCESS
#    8 - DELIVERY_FAIL
#   12 - DELIVERY_ALL
#   16 - CHARGING
#   32 - NONE
#   64 - AUTH
#  128 - PROVISIONING
#    5 - ALL_SUCCESS
#   10 - ALL_FAIL
#   31 - ALL
#  208 - CHARGING (16) or AUTH (64) or PROVISIONING (128)
export NOTIFICATION_TYPE=$(echo "${props[TANGRAM.NOTIFICATION.TYPE]}")

# NOTIFICATION CALLTYPE
#  0 - HTTP GET
#  1 - HTTP POST XML 
#  2 - SOAP
#  3 - COM_PLUS
#  4 - MSMQ
# * use 1 to teste with tangram-notification-listener application
export NOTIFICATION_CALLTYPE=$(echo "${props[TANGRAM.NOTIFICATION.CALLTYPE]}")

# NOTIFICATION SITE = URL 
# Must be a valid internet IP
export NOTIFICATION_SITE=$(echo "${props[TANGRAM.NOTIFICATION.URL]}")

# TANGRAM location URL
export URL_TARGET=$(echo "${props[TANGRAM.URL]}")

# URL TO SIMULATE MO
export USER_MO_ACCEPT_TEXT=$(echo "${props[TANGRAM.PROVISIONING.CONFIRM.TEXT]}")
export URL_DESTINATION_SEND_MO_LOCATION=$(echo "${props[TANGRAM.PROVISIONING.CONFIRM.URL]}")
export URL_DESTINATION_SEND_MO_PARAMS="?idCarrier=${TANGRAM_CARRIER_ID}&LargeAccount=${TANGRAM_LA}&Source=${DESTINATION}&Text=${USER_MO_ACCEPT_TEXT}"
export URL_DESTINATION_SEND_MO="${URL_DESTINATION_SEND_MO_LOCATION}${URL_DESTINATION_SEND_MO_PARAMS}"

# FILL WITH USER AND PASSWORD
export HEADER_PASS=$(echo "${props[TANGRAM.USER.VALUE]}")
export HEADER_USER=$(echo "${props[TANGRAM.PASS.VALUE]}")

###############################################################################
# DO NOT TOUCH BELOW THIS LINE
###############################################################################

# creates the XML request using the specified template file.
export SUBSCRIBE_CHANNEL_TEMPLATE="templates/provisioning_request_trial.xml"
export SUBSCRIBE_CHANNEL_XML=$(
cat "${SUBSCRIBE_CHANNEL_TEMPLATE}" |
sed 's#${company_id}#'"${TANGRAM_COMPANY_ID}"'#' |
sed 's#${service_id}#'"${TANGRAM_SERVICE_ID}"'#' |
sed 's#${channel_id}#'"${TANGRAM_CHANNEL_ID}"'#' |
sed 's#${carrier_id}#'"${TANGRAM_CARRIER_ID}"'#' |
sed 's#${operation_code}#'"${OPERATION_CODE}"'#' |
sed 's#${operation_desc}#'"${OPERATION_DESC}"'#' |
sed 's#${tangram_la}#'"${TANGRAM_LA}"'#' |
sed 's#${destination}#'"${DESTINATION}"'#' |
sed 's#${datetime}#'"${REQUEST_DATETIME}"'#' |
sed 's#${auth_type}#'"${AUTH_TYPE}"'#' |
sed 's#${notification_type}#'"${NOTIFICATION_TYPE}"'#' |
sed 's#${notification_calltype}#'"${NOTIFICATION_CALLTYPE}"'#' |
sed 's#${notification_site}#'"${NOTIFICATION_SITE}"'#' 
)

# print line header with date 
print_header

# PRINTS THE SUBSCRIBE REQUEST
echo "SUBSCRIBE REQUEST: " | tee -a "${LOG_FILE}"; echo | tee -a "${LOG_FILE}"
echo "${SUBSCRIBE_CHANNEL_XML}" | tee -a "${LOG_FILE}"; echo | tee -a "${LOG_FILE}"

# print line header with date 
print_header

# WAIT ENTER TO CONTINUE
echo "Type [ENTER] to send."
read type_enter

# SEND THE REQUEST TO TANGRAM AND PRINTS THE RESPONSE
export HEADER_CONTENT="application/xml"
export HEADER_ACCEPT="application/xml"

echo "SEND THE REQUEST TO TANGRAM AND PRINTS THE RESPONSE: "; echo | tee -a "${LOG_FILE}"
curl -D - -X POST \
	-HContent-type:${HEADER_CONTENT} \
	-HAccept:${HEADER_ACCEPT}\
	-HTANGRAM_USER:${HEADER_USER}\
	-HTANGRAM_PASSWORD:${HEADER_PASS}\
	--data "${SUBSCRIBE_CHANNEL_XML}"\
	${URL_TARGET} | tee -a "${LOG_FILE}"
echo | tee -a "${LOG_FILE}"

# print line header with date 
print_header

# WAIT ENTER TO CONTINUE
echo "Now, wait the for notification."
echo "Check tangram-notification-listener.exe window or the log file generated by the application" 
echo "WARNING: The notification will be sent only by the END OF SUBSCRIPTION TIME (DAY|WEEK|MONTH)"
echo "Type [ENTER] to continue." 
read type_enter