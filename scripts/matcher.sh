#!/bin/sh
# matcher helper script
#
CMD=$1
cd `dirname $0`/..; prjhome=$PWD/packetmatcher
M2CLASSPATH=$prjhome/.m2classpath 

# Usage
usage () {
    echo "USAGE: matcher.sh start [OPTIONS]" 
    echo "        matcher.sh clean"
    echo ""
    echo "Use \"matcher.sh start -h\" for help."
}

# Build dependencies
dependencies () {
    echo "=== Building dependencies (ipfix4java) ==="
    cd $prjhome/../ipfix4java
    mvn install -Dmaven.test.skip=true
    echo "=== Building dependencies (pt-api) ==="
    cd $prjhome/../netview/pt-api
    mvn install -Dmaven.test.skip=true
}

# Start Packet Matcher
start () {
    if [ ! -r $M2CLASSPATH ]; then
        dependencies
        echo "=== Extracting classpath (.m2classpath) ===" 
        cd $prjhome
        mvn compile exec:exec -Dmaven.test.skip=true
    fi
    cd $prjhome
    ../scripts/m2run -Dmainclass=de.fhg.fokus.net.packetmatcher.Matcher org.kohsuke.args4j.Starter $*
}

case $CMD in
    clean)
        echo "Removing $M2CLASSPATH" 
        rm -f $M2CLASSPATH
    ;;
    start)
        shift
        start $*
    ;;
    *)
        usage
    ;;
esac
