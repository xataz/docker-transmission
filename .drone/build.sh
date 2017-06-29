#!/bin/bash

## Variables
CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"


## Functions
f_log() {
    TYPE=$1
    MSG=$2

    if [ "${TYPE}" == "ERR" ]; then
        COLOR=${CRED}
    elif [ "${TYPE}" == "INF" ]; then
        COLOR=${CBLUE}
    elif [ "${TYPE}" == "WRN" ]; then
        COLOR=${CYELLOW}
    elif [ "${TYPE}" == "SUC" ]; then
        COLOR=${CGREEN}
    else
        COLOR=${CEND}
    fi

    echo -e "${COLOR}=${TYPE}= $TIMENOW : ${MSG}${CEND}"
}


# Build transmission
f_log INF "Build xataz/transmission:latest ..."
docker build -t xataz/transmission:latest . > /tmp/build.log 2>&1
if [ $? -eq 0 ]; then
    f_log SUC "Build xataz/transmission:latest successful"
else
    f_log ERR "Build xataz/transmission:latest failed"
    cat /tmp/build.log
    exit 1
fi

f_log INF "Build xataz/transmission:filebot ..."
docker build --build-arg WITH_FILEBOT=YES -t xataz/transmission:filebot . > /tmp/build.log 2>&1
if [ $? -eq 0 ]; then
    f_log SUC "Build xataz/transmission:filebot successful"
    docker tag xataz/transmission:filebot xataz/transmission:latest-filebot
else
    f_log ERR "Build xataz/transmission:filebot failed"
    cat /tmp/build.log
    exit 1
fi
