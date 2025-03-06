#!/bin/bash

# Database credentials

DB_HOST="172.20.30.47"
DB_USER="cavidh"
DB_PASS="DBSipInt22"
DB_NAME="asterisk"


# New number which you'll locate in the directory below

RESULTS_DIR="results"

# Generate a unique file name based on the current timestamp and save it in results folder

OUTPUT_FILE="$RESULTS_DIR/result_$(date +"%Y-%m-%d_%H-%M-%S").json"

# Create a new JSON file and initialize it with the start of the JSON

> "$OUTPUT_FILE"

# Loop to input multiple SIP numbers
while true; do
    read -p "Please enter SIP number (press Enter to stop): " NEW_SIP_NUMBER
    if [ -z "$NEW_SIP_NUMBER" ]; then
        break
    fi

# If secret is found, base64 encode it

    SECRET=$(mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -se \
        "SELECT var_val FROM sip_users WHERE cat_metric='$NEW_SIP_NUMBER' AND var_name='secret';")

    if [ -n "$SECRET" ]; then
        ENCODED_SECRET=$(echo -n "$SECRET" | base64)
        echo "The number you entered was found in the DB and successfully encoded for $NEW_SIP_NUMBER: $ENCODED_SECRET"

# Append each JSON object for the new number to the output file

        echo "{\"subscription\":{\"name\":\"+99412$NEW_SIP_NUMBER\",\"attachedPrivateIdentities\":[\"+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\"],\"imsu\":{\"name\":\"+99412$NEW_SIP_NUMBER\",\"scscfName\":\"\",\"diameterName\":\"\",\"diameterRealm\":\"\",\"idPreferredScscfSet\":1}},\"privateIdentities\":[{\"identity\":\"+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\",\"publicIdentityMapping\":[\"sip:+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\"],\"agcf\":{\"type\":\"SIP\",\"node\":1090,\"impu\":\"sip:+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\",\"impi\":\"+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\",\"uriType\":\"telUri\",\"embedTelUriSipUri\":true,\"standaloneCalls\":false,\"subscriberType\":\"AGCF\",\"profileId\":1,\"profileName\":\"SIP Default Profile\",\"madId\":1,\"madName\":\"AzerConnect\",\"registrationMode\":\"registration\",\"registrationExpires\":3600,\"subscriptionExpires\":0,\"sigControl\":6,\"clnioc\":false,\"ipRangeGroupId\":0},\"impi\":{\"type\":0,\"authScheme\":255,\"defaultAuthScheme\":128},\"agcfImpu\":\"sip:+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\",\"p\":\"$ENCODED_SECRET\",\"subscriptionAttachedTo\":\"+99412$NEW_SIP_NUMBER\"}],\"publicIdentities\":[{\"identity\":\"sip:+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\",\"agcfNodeId\":1090,\"agcfImpu\":\"sip:+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\",\"agcfType\":\"SIP\",\"privateIdentityMapping\":[\"+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\"],\"tas\":{\"impu\":\"sip:+99412$NEW_SIP_NUMBER@voip.ims.ultel.az\",\"node\":1050,\"licenseType\":\"advancedLicense\",\"serviceSetId\":-1,\"sipProfileId\":92,\"subscriberCategory\":1,\"concurrentSessions\":1,\"concurrentSessionType\":1,\"geographicalArea\":0,\"timeZone\":0,\"useRtpProxy\":false,\"nonTrustedName\":false,\"sendInfoMassages\":false,\"serviceNameStatusInfo\":false,\"boolFmcProp\":false,\"dtmfDetection\":false,\"customServiceSet\":{\"subsctg\":1,\"subsStatus\":10,\"cfuAuth\":1,\"cfbAuth\":1,\"cfnrAuth\":0,\"ccbsAuth\":1,\"hotiAuth\":0,\"dndAuth\":7,\"cfnrcAuth\":0,\"cdAuth\":0,\"ctAuth\":0,\"arAuth\":0,\"abdsCategory\":0,\"clipAuth\":1,\"clipCliro\":0,\"clirAuth\":0,\"colpAuth\":1,\"colpColro\":0,\"colrAuth\":0,\"mcidAuth\":0,\"cwAuth\":1,\"holdAuth\":1,\"s3ptyAuth\":1,\"confAuth\":1,\"pdcnfAuth\":0,\"cbscAuth\":0,\"cbacBarrclass\":61,\"peocAuth\":0,\"fcrAuth\":0,\"acrAuth\":0,\"acsAuth\":0,\"inbandIndType\":1,\"displayRingType\":1,\"annVariant\":0,\"origCtxRstr\":0,\"termCtxRstr\":0,\"annCtxsubsAuth\":0,\"licenseType\":22,\"uicctAuth\":0,\"cfutAuth\":0,\"cpuAuth\":0,\"cfnlAuth\":0,\"uiccpAuth\":0,\"vxmlAuth\":0,\"modifyMode\":false,\"modifySupplSrvList\":[\"licenseType\"]},\"origCtxRstr\":0,\"termCtxRstr\":0},\"impu\":{\"type\":0,\"barring\":0,\"userState\":0,\"idSp\":1,\"wildcardPsi\":\"\",\"displayName\":\"\",\"psiActivation\":0,\"canRegister\":1,\"idRoamingProfile\":1}}]}" >> "$OUTPUT_FILE"
    else
        echo "No number was found from the DB!"
    fi
done

# Output the final result

echo "The JSON result was created and saved to the file $OUTPUT_FILE."
