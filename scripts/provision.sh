#!/bin/bash

#
# Provisioning script for Vagrant Ubuntu system
# Comment out items that you don't need 
#

######

# Root password for MySQL
MYSQL_ROOT_PASSWORD=changemenow

# The user account that will receive RVM
APPS_USER=vagrant
APPS_USER_PWD=changemenow

# The initial Web application
APP_NAME=changeme
APP_GEMSET=changeme
APP_ENV=vagrant
CAPISTRANO_APP_DIRS="/home/$APPS_USER/public_html/$APP_NAME /home/$APPS_USER/public_html/$APP_NAME/releases /home/$APPS_USER/public_html/$APP_NAME/shared /home/$APPS_USER/public_html/$APP_NAME/shared/config /home/$APPS_USER/public_html/$APP_NAME/shared/system /home/$APPS_USER/public_html/$APP_NAME/shared/log /home/$APPS_USER/public_html/$APP_NAME/shared/pids"
RUBY_VERSION=2.0.0

# Directory for Passenger nginx
NGINX_DIR=/opt/nginx

# Locale and time zone for US East
# DEFAULT_LOCALE="en_US.UTF-8"
# DEFAULT_TIMEZONE="America/New_York"

# Locale and time zone for UK
DEFAULT_LOCALE="en_GB.UTF-8"
DEFAULT_TIMEZONE="Europe/London"

######

# Extra sudoers file
SUDOER_CONFIG="
$APPS_USER    ALL=(ALL:ALL) ALL\n
"

MYSQL_APP_CONFIG="
$APP_ENV:\n
  adapter: mysql2\n
  database: $APP_NAME_$APP_ENV\n
  username: $APP_NAME\n
  password: $MYSQL_ROOT_PASSWORD\n
  host: localhost\n
  encoding: utf8\n
  "

PG_APP_CONFIG="
$APP_ENV:\n
  adapter: postgresql\n
  database: $APP_NAME_$APP_ENV\n
  pool: 5\n
  username: $APPS_USER\n
  password:\n
  encoding: utf8\n
  min_messages: warning\n
  "

GEM_RC="
---\n
gem: --no-ri --no-rdoc\n
"

######

# Function that tests for packages and installs them
function ensure_packages {
  for p in $1 ; do
    dpkg-query -l $p | grep 'ii' > /dev/null 2>&1
    if [ $? != 0 ] ; then
      apt-get -qy install $p
    fi
  done
}

# Set apt-get to non-interactive mode 
export DEBIAN_FRONTEND=noninteractive

# Sets the locale of the box
if [[ `locale | head -n1` != "LANG=$DEFAULT_LOCALE" ]]; then
  echo -e "LANG=$DEFAULT_LOCALE\nLANGUAGE=$DEFAULT_LOCALE\nLC_ALL=$DEFAULT_LOCALE" | tee /etc/default/locale
  locale-gen $DEFAULT_LOCALE
  dpkg-reconfigure locales
fi

# Sets the time zone
if [[ `tail -n1 /etc/timezone` != "$DEFAULT_TIMEZONE" ]]; then
  echo $DEFAULT_TIMEZONE > /etc/timezone    
  dpkg-reconfigure -f noninteractive tzdata
fi

# Update installed system packages
apt-get -qy update
apt-get -qy upgrade

# Check for packages that are required for APPS,
# and install them if necessary.
ensure_packages "build-essential curl git-core"

# Check for packages that are required for compiling Ruby with APPS,
# and install them if necessary.
# libcurl4-openssl-dev is needed to compile Nginx with Passenger
ensure_packages "libcurl4-openssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libgdbm-dev libncurses5-dev automake libtool bison libffi-dev"

# Install Node.js
# to provide a JavaScript runtime for CoffeeScript support in Rails
ensure_packages "nodejs"

# Install Postfix mail service
# dpkg-query -l "postfix" | grep 'ii' > /dev/null 2>&1
# if [ $? != 0 ] ; then
#  debconf-set-selections <<< "postfix postfix/main_mailer_type select Internet Site"
#  debconf-set-selections <<< "postfix postfix/mailname string localhost"
#  debconf-set-selections <<< "postfix postfix/destinations string localhost.localdomain, localhost"
#  apt-get -qy install postfix
# fi

# Check for packages that are required for ImageMagick,
# and install them if necessary.
# ensure_packages "ghostscript imagemagick libmagickcore-dev libmagickwand-dev"

# Ensure that the user exists
if [ ! -d /home/$APPS_USER ] ; then
  adduser --quiet --disabled-password --gecos "" $APPS_USER
  echo "$APPS_USER:$APPS_USER_PWD" | chpasswd
fi

# Give the user the ability to use sudo
SUDOER_FILE=/etc/sudoers.d/$APPS_USER
if [ ! -f $SUDOER_FILE ] ; then
  echo -e $SUDOER_CONFIG > $SUDOER_FILE 
  chown root:root $SUDOER_FILE
  chmod 0440 $SUDOER_FILE
fi

# Directory for SSH
if [ ! -d /home/$APPS_USER/.ssh ] ; then
  mkdir /home/$APPS_USER/.ssh
  chown $APPS_USER:$APPS_USER /home/$APPS_USER/.ssh
  chmod 0700 /home/$APPS_USER/.ssh
fi

# Ruby Gem settings
if [ ! -f /home/$APPS_USER/.gemrc ] ; then
  echo -e $GEM_RC > /home/$APPS_USER/.gemrc
  chown $APPS_USER:$APPS_USER /home/$APPS_USER/.gemrc
  chmod 0600 /home/$APPS_USER/.gemrc
fi

# Directory for Web applications
if [ ! -d /home/$APPS_USER/public_html ] ; then
  mkdir /home/$APPS_USER/public_html
  chown $APPS_USER:$APPS_USER /home/$APPS_USER/public_html
  chmod 0755 /home/$APPS_USER/public_html
fi

# Capistrano directories
if [ ! -d /home/$APPS_USER/public_html/$APP_NAME ] ; then
  mkdir -p $CAPISTRANO_APP_DIRS
  chown -R $APPS_USER:$APPS_USER /home/$APPS_USER/public_html/$APP_NAME
  chmod -R 0755 /home/$APPS_USER/public_html/$APP_NAME
fi

# Install PostgreSQL, with libpq-dev for compiling drivers
dpkg-query -l "postgresql" | grep 'ii' > /dev/null 2>&1
if [ $? != 0 ] ; then
  apt-get -qy install postgresql
  apt-get -qy install libpq-dev

  # Database config for Rails application
  PG_APP_FILE=/home/$APPS_USER/public_html/$APP_NAME/shared/config/database.yml
  if [ ! -f $PG_APP_FILE ] ; then
    echo -e $PG_APP_CONFIG > $PG_APP_FILE 
    chown $APPS_USER:$APPS_USER $PG_APP_FILE
    chmod 0600 $PG_APP_FILE
  fi

fi

# Install MySQL 5.5, with libmysqlclient-dev for compiling drivers
#dpkg-query -l "mysql-server-5.5" | grep 'ii' > /dev/null 2>&1
#if [ $? != 0 ] ; then
#  debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
#  debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
#  apt-get -qy install mysql-server-5.5
#  apt-get -qy install libmysqlclient-dev

# Database config
# MYSQL_APP_FILE=/home/$APPS_USER/public_html/$APP_NAME/shared/config/database.yml
# if [ ! -f $MYSQL_APP_FILE ] ; then
#   echo -e $MYSQL_APP_CONFIG > $MYSQL_APP_FILE 
#   chown $APPS_USER:$APPS_USER $MYSQL_APP_FILE
#   chmod 0600 $MYSQL_APP_FILE
# fi

#fi

# Install RVM 
if [ ! -d /home/$APPS_USER/.rvm ] ; then
  su -l -c "\curl -L https://get.rvm.io | bash -s stable --autolibs=disabled --ruby=$RUBY_VERSION" $APPS_USER
  su -l -c "source ~/.rvm/scripts/rvm ; rvm gemset create $APP_GEMSET" $APPS_USER
fi

# Install Passenger with Nginx
if [ ! -d $NGINX_DIR ] ; then
  su -l -c 'gem install passenger' $APPS_USER
  su -l -c "rvmsudo passenger-install-nginx-module --auto --prefix=$NGINX_DIR --auto-download" $APPS_USER

  # Init script for Nginx
  if [ ! -x /etc/init.d/nginx ] ; then
    wget -O init-deb.sh http://library.linode.com/assets/1139-init-deb.sh
    mv init-deb.sh /etc/init.d/nginx
    chmod 0755 /etc/init.d/nginx
    /usr/sbin/update-rc.d -f nginx defaults
  fi 
fi
