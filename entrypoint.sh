#!/bin/sh
# entrypoint.sh

#replace values with env-vars from cosmos-installer
# echo "Set configuration..."
# sed -i 's~FRIENDLY_NAME~'"$FRIENDLY_NAME"'~g' /usr/app/server-config.xml
# sed -i 's~NAME~'"$NAME"'~g' /usr/app/server-config.xml
# sed -i 's~PHYS_ADDRESS~'"$PHYS_ADDRESS"'~g' /usr/app/server-config.xml
# sed -i 's~DISCOVERY_LISTEN_IF~'"$DISCOVERY_LISTEN_IF"'~g' /usr/app/server-config.xml
# sed -i 's~DISCOVERY_OUT_IF~'"$DISCOVERY_OUT_IF"'~g' /usr/app/server-config.xml
# sed -i 's~DISCOVERY~'"$DISCOVERY"'~g' /usr/app/server-config.xml
# sed -i 's~NET_IF~'"$NET_IF"'~g' /usr/app/server-config.xml
# sed -i 's~SERIAL_PORT~'"$SERIAL_PORT"'~g' /usr/app/server-config.xml
# sed -i 's~SUBNET_TYPE~'"$SUBNET_TYPE"'~g' /usr/app/server-config.xml
# sed -i 's~ADDITIONAL_ADDRESS1~'"$ADDITIONAL_ADDRESS1"'~g' /usr/app/server-config.xml
# sed -i 's~ADDITIONAL_ADDRESS2~'"$ADDITIONAL_ADDRESS2"'~g' /usr/app/server-config.xml
# sed -i 's~ADDITIONAL_ADDRESS3~'"$ADDITIONAL_ADDRESS3"'~g' /usr/app/server-config.xml
# sed -i 's~ADDITIONAL_ADDRESS4~'"$ADDITIONAL_ADDRESS4"'~g' /usr/app/server-config.xml
# sed -i 's~ADDITIONAL_ADDRESS5~'"$ADDITIONAL_ADDRESS5"'~g' /usr/app/server-config.xml
# echo "Configuration set!"

### do the same with yq instead of sed to lay the base to be more dynamic ###
touch server-config.xml
yq '{ "+p_xml": "version=\"1.0\" encoding=\"UTF-8\"",
"knxServer": {
    "+@name": "${NAME}",
    "+@friendlyName": "${FRIENDLY_NAME}",
    "discovery": {
    "+@listenNetIf": "${DISCOVERY_LISTEN_IF}",
    "+@outgoingNetIf": "${DISCOVERY_OUT_IF}",
    "+@activate": "${DISCOVERY}"
    },
    "serviceContainer": {
    "+@activate": "true",
    "+@routing": "true",
    "+@networkMonitoring": "true",
    "+@netif": "${LISTEN_IF}",
    "knxAddress": {
        "+content": "${PHYS_ADDRESS}",
        "+@type": "individual"
    },
    "routing": "",
    "knxSubnet": {
        "+content": "${SERIAL_PORT}",
        "+@type": "${SUBNET_TYPE}",
        "+@medium": "tp1"
    },
    "groupAddressFilter": "",
    "additionalAddresses": {
        "knxAddress": [
        {
            "+content": "${ADDITIONAL_ADDRESS1}",
            "+@type": "individual"
        },
        {
            "+content": "${ADDITIONAL_ADDRESS2}",
            "+@type": "individual"
        },
        {
            "+content": "${ADDITIONAL_ADDRESS3}",
            "+@type": "individual"
        },
        {
            "+content": "${ADDITIONAL_ADDRESS4}",
            "+@type": "individual"
        },
        {
            "+content": "${ADDITIONAL_ADDRESS5}",
            "+@type": "individual"
        }
        ]
    }
    }
}
}
| (.. | select(tag =="!!str")) |= envsubst' -i server-config.xml

#remove the file that creates a issue starting the container.
rm -f /usr/app/Calimero-ios.xml

# Run the standard container command.
echo "Init done. Run Calimero..."
exec "$@"