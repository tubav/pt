#!/bin/sh
# Bootstrap CAN project
#
# ==[ START CONFIG ]==
JAVA=java

# ==[ END CONFIG ]==
CMD=$1
M2CLASSPATH=$2
CLASSPATH_FILE=.m2classpath
usage () {
  cat <<EOT
=======[ Maven Classpath extractor]=======

Extracts maven class path for launching scripts.

USAGE:  this script should be called from within maven using
        the exec-maven-plugin via "mvn compile exec:exec" 
         <reporting>
            <plugins>
              <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <version>1.1</version>
                <configuration>
                  <executable>../scripts/m2classpath.sh</executable>
                  <arguments>
                    <argument>create_classpath_file</argument>
                    <classpath />
                 </arguments>
              </configuration>
             </plugin>
            </plugins>
         </reporting>

EOT
}
# ==[ create classh path file via maven ]==
create_classpath_file () {
  if [ "$M2CLASSPATH" != "" ]; then
     echo "#=> Creating $CLASSPATH_FILE"
     # FIXME worldmap target class path
     echo ./target/classes:../../worldmap/target/classes:$M2CLASSPATH > $CLASSPATH_FILE
  else 
     echo "ERROR: this script must be called via 'mvn compile exec:exec'"
  fi
}
# ==[ main switch ]==
case $CMD in
  create_classpath_file)
    create_classpath_file
  ;;
  *)
    usage
  ;;
esac

