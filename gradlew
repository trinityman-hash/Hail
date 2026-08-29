#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls -ld "$PRG"
    PRG=`readlink "$PRG"`
done
PRG_DIR=`dirname "$PRG"`
APP_HOME=`cd "$PRG_DIR"/.. >/dev/null 2>&1 && pwd`

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS='" "-Xmx64m" "-Xms64m"'

# Use the maximum available, or set MAX_FD != unlimited.
MAX_FD="maximum"

warn () {
    echo "$*"
}

die () {
    echo
    echo "$*"
    exit 1
}

# OS specific support (must be 'true' or 'false').
DARWIN=false
MINGW=false
MSYS=false
CYGWIN=false

case `uname` in
  Darwin* )
    DARWIN=true
    ;;
  MINGW* )
    MINGW=true
    ;;
  MSYS* )
    MSYS=true
    ;;
  CYGWIN* )
    CYGWIN=true
    ;;
esac

# Increase the maximum file descriptors if we can.
if [ "$DARWIN" = "true" ] && [ -z "$JAVA_HOME" ] ; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

if [ "$DARWIN" = "true" ] && [ -z "$JAVA_HOME" ] ; then
  [ "$JAVA_HOME" = "" ] && JAVA_HOME=`/usr/libexec/java_home`
  if [ -z "$JAVA_HOME" ] ; then
    user_java_home=`dscl /Search -search /Users UserShell | grep -v Local | cut -d: -f1 | head -1 | xargs dscl /Search -read`
    JAVA_HOME=`echo $user_java_home | sed 's/^ *UserShell: *//;s/ *$//'`
  fi
fi

if [ -z "$JAVA_HOME" ] ; then
  if [ -x /usr/bin/java ] ; then
    JAVA_HOME=/usr
  fi
fi

if [ -z "$CLASSPATH" ] ; then
    CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar
else
    CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar:$CLASSPATH
fi

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

# Increase the maximum file descriptors if we can.
if [ "$DARWIN" = "true" ] ; then
    MAX_FD_LIMIT=`ulimit -H -n`
    if [ $? -eq 0 ] ; then
        if [ "$MAX_FD" = "maximum" -o "$MAX_FD" = "max" ] ; then
            MAX_FD="$MAX_FD_LIMIT"
        fi
        ulimit -n $MAX_FD
        if [ $? -ne 0 ] ; then
            warn "Could not set maximum file descriptor limit: $MAX_FD"
        fi
    else
        warn "Could not query maximum file descriptor limit: $MAX_FD_LIMIT"
    fi
fi

# For Darwin, add options to specify how the application appears in the dock
if [ "$DARWIN" = "true" ] ; then
    GRADLE_OPTS="$GRADLE_OPTS \"-Xdock:name=$APP_NAME\" \"-Xdock:icon=$APP_HOME/media/gradle.icns\"
fi

# For Cygwin or MSYS, switch paths to Windows format before running java
if [ "$CYGWIN" = "true" ] -o [ "$MSYS" = "true" ] ; then
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`

    JAVACMD=`cygpath --unix "$JAVACMD"`

    # We build the pattern for arguments to be converted via cygpath
    ROOTDIRSRAW=`find -L / -maxdepth 3 -type d -name java_home 2>/dev/null`
    SEP=""
    for dir in $ROOTDIRSRAW ; do
        ROOTDIRS="$ROOTDIRS$SEP$dir"
        SEP="|"
    done
    OURCYGPATTERN="(^($ROOTDIRS)$)"
    # Add a user-defined pattern to the cygpath arguments
    if [ "$GRADLE_CYGWIN_VERBOSE" = "true" ] ; then
        echo base directory: $1
    fi
    case $base in
        /)
            # MSYS
            ;;
        *)
            ;;
    esac
fi

if [ "$MINGW" = "true" ] ; then
    nfiles=0
    for arg in "$@" ; do
        if [ -n "$MINGW_STATUS" ] && [ x"${MINGW_STATUS}" = x0 ] ; then
            if expr "$arg" : [-].*Xms >/dev/null ; then
                new_arg="$arg"
            elif expr "$arg" : [-].*Xmx >/dev/null ; then
                new_arg="$arg"
            elif [ "$arg" = "continue" ] ; then
                MINGW_STATUS=
                new_arg=
            else
                new_arg=
                MINGW_STATUS=
            fi
        fi
        if [ -z "$new_arg" ] ; then
            new_arg="$arg"
        fi
        nfiles=$((nfiles + 1))
        eval "set -- \"$@\" \"$new_arg\""
    done
fi

eval "set -- $GRADLE_OPTS \"-Dorg.gradle.appname=$APP_BASE_NAME\" -classpath \"$CLASSPATH\" org.gradle.wrapper.GradleWrapperMain \"$@\""

eval exec "$JAVACMD" "$@"
