#!/bin/sh

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
# Resolve links: $0 may be a symlink
app_path="$0"

# Need this for daisy-chained symlinks.
while
    APP_HOME=${app_path%"${app_path##*/}"}
    [ -h "$app_path" ]
do
    ls=$( ls -ld "$app_path" )
    link=${ls#*' -> '}
    case $link in
    /*) app_path=$link ;;
    *) app_path=$APP_HOME$link ;;
    esac
done

# This is normally unused
app_base_name=${0##*/}
app_home_dir=$( cd "${APP_HOME-.}" && pwd -P ) || exit

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS='" -Xmx64m" "-Xms64m"'

# Use the maximum available, or set MAX_FD != unlimited.
MAX_FD=maximum

warn () {
    echo "$*" >&2
}

die () {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
case "$( uname )" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MSYS* | MINGW* )
    msys=true
    ;;
  NOHUP* )
    nohup=true
    ;;
esac

# Increase the maximum file descriptors if we can.
if ! "$cygwin" && ! "$darwin" && ! "$msys" ; then
    case $MAX_FD in
    max*)
        # In POSIX sh, RLIMIT_INFINITY is -1, not 2147483647.
        ulimit -n unbounded 2>/dev/null || ulimit -n 2147483647
        ;;
    esac
fi

# Escape application args
save () {
    for i do printf %s\\n "$i" | sed "s/'/'\"'\"'/g;1s/^/'/;\$s/\$/'" ; done
    echo " "
}
APP_ARGS=$( save "$@" )

# Collect all arguments for the java command.
set -- \
        "-Dorg.gradle.appname=$app_base_name" \
        -classpath "$app_home_dir/gradle/wrapper/gradle-wrapper.jar" \
        org.gradle.wrapper.GradleWrapperMain \
        "$APP_ARGS"

# Stop when "xargs" by itself has been stopped (in case of "-e +flag").
if ! IFS= read -r line <&- ; then
    IFS= read -r line
fi
set -- "$@" "$line"

case $( uname ) in
  CYGWIN* )
    # Fix for Windows git bash that gives\r\r\n .
    path_conv() {
        sed -e "s@^\(.*\)@/cygdrive/\L\1@g"
    }
    ;;
  MSYS* | MINGW* )
    # Fix for Windows git bash that gives\r\r\n .
    path_conv() {
        sed -e "s@^\(.*\)@/\1@g"
    }
    ;;
  NOHUP* )
    path_conv() {
        echo "$1"
    }
    ;;
esac

# Now convert the arguments - kludge to limit ourselves to /bin/sh
for arg do
    if
        case $arg in
        -*) false ;;
        *) true ;;
        esac
    then
        arg=$( path_conv "$1" )
    fi
    shift
    set -- "$@" "$arg"
done

# Collect all arguments for the java command;
# * $DEFAULT_JVM_OPTS, $JAVA_OPTS, and $GRADLE_OPTS can contain fragments of
#   shell commands we need for word splitting, so put them in double quotes to
#   make it clear that they should be evaluated as such; see the
#   "shut_down" and "init_proc" functions for examples. to avoid this
#   problem, let's set a Java system property as a reference instead.
# * When using the daemon. the Java heap will be managed by the daemon, and
#   the " -Xmx" and "-Xms" values will only apply to the client VM, not the
#   daemon. see https://docs.gradle.org/latest/userguide/gradle_daemon.html
#   " -Xmx768m" " -Xms256m"
set -- \
        "-Dorg.gradle.appname=$app_base_name" \
        -classpath "$app_home_dir/gradle/wrapper/gradle-wrapper.jar" \
        org.gradle.wrapper.GradleWrapperMain \
        "$APP_ARGS"

exec "$JCMD" "$@"
