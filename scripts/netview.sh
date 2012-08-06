#!/bin/sh
# NetView helper script
#
CMD=$1

usage () {
    echo "USAGE:   netview.sh {clean|build|start}"
}

cleanall() {
    save_dir=`pwd`
    cd $buildhome/netview/worldmap
    if [ -r "./pom.xml" ]; then
        echo "# cleaning WorldMap # "
        mvn clean
        echo "# cleaning NetView"
        cd $buildhome/netview/netview
        mvn clean
    else
        curr_dir=`pwd`
        echo "ERROR: Could not find $curr_dir/pom.xml"
        echo "       Please checkout worldmap in the"
        echo "       indicated location and try again." 
        echo ""
        echo "See also" 
        echo ""
        echo "https://svnsrv.fokus.fraunhofer.de/cc/ccnet/pt/wiki"
    fi
    cd $save_dir
}

# Build dependencies
dependencies () {
    echo "=== Building dependencies (ipfix4java) ==="
    cd $buildhome/ipfix4java
    mvn install -Dmaven.test.skip=true
    echo "=== Building dependencies (pt-api) ==="
    cd $buildhome/netview/pt-api
    mvn install -Dmaven.test.skip=true
}


# Build all dependencies using maven
buildall () {
    save_dir=`pwd`
    dependencies
    cd $buildhome/netview/worldmap
    if [ -r "./pom.xml" ]; then
        echo ""
        echo "=== Building WorldMap ==="
        mvn compile install -Dmaven.test.skip=true
        echo ""
        echo "=== Building NetView ==="
        cd $buildhome/netview/netview
        mvn compile exec:exec -Dmaven.test.skip=true
    else
        curr_dir=`pwd`
        echo "ERROR: Could not find $curr_dir/pom.xml"
        echo "       Please checkout worldmap in the"
        echo "       indicated location and try again." 
        echo ""
        echo "See also" 
        echo ""
        echo "https://svnsrv.fokus.fraunhofer.de/cc/ccnet/pt/wiki"
    fi
    cd $save_dir
}

# Start NetView
start (){
    if [ -r $buildhome/netview/netview/.m2classpath ]; then
        echo "Starting NetView"
        cd $buildhome/netview/netview
        ../../scripts/m2run de.fhg.fokus.net.netview.control.MainController 
    else
        echo "ERROR: project not built. Assure you have mvn in the path and"
        echo "run \"netview.sh build\""
    fi
}

# MAIN
cd `dirname $0`/..;
buildhome=$PWD

case $CMD in
    build)
        buildall
    ;;
    clean)
        cleanall
    ;;
    start)
        start
    ;;
    *)
        usage
esac
