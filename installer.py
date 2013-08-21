import subprocess
import os
import time
import sys

class Installer:

  ############################################################
  # install_software
  ############################################################
  def install_software(self):
    if self.benchmarker.install == 'all' or self.benchmarker.install == 'server':
        self.__install_server_software()

    if self.benchmarker.install == 'all' or self.benchmarker.install == 'client':
        self.__install_client_software()
  ############################################################
  # End install_software
  ############################################################

  ############################################################
  # __install_server_software
  ############################################################
  def __install_server_software(self):
    print("\nINSTALL: Installing server software\n")

    #######################################
    # Prerequisites
    #######################################
    self.__run_command("sudo apt-get update")
    self.__run_command("sudo apt-get upgrade -qq")
    self.__run_command("sudo apt-get install build-essential libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev python-software-properties unzip git-core libcurl4-openssl-dev libbz2-dev libmysqlclient-dev mongodb-clients libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libgdbm-dev ncurses-dev automake libffi-dev htop libtool bison libevent-dev libgstreamer-plugins-base0.10-0 libgstreamer0.10-0 liborc-0.4-0 libwxbase2.8-0 libwxgtk2.8-0 libgnutls-dev libjson0-dev libmcrypt-dev libicu-dev cmake gettext curl libpq-dev mercurial -qq")
    self.__run_command("sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ubuntu-toolchain-r/test")
    self.__run_command("sudo apt-get update")
    self.__run_command("sudo apt-get install gcc-4.8 g++-4.8 -qq")

    self.__run_command("cp ../config/benchmark_profile ../../.bash_profile")
    self.__run_command("sudo sh -c \"echo '*               -    nofile          16384' >> /etc/security/limits.conf\"")

    ##############################################################
    # System Tools
    ##############################################################

    #
    # Leiningen
    #
    self.__run_command("mkdir -p bin")
    self.__run_command("wget https://raw.github.com/technomancy/leiningen/stable/bin/lein")
    self.__run_command("mv lein bin/lein")
    self.__run_command("chmod +x bin/lein")

    #
    # Maven
    #
    self.__run_command("sudo apt-get install maven -qq")
    self.__run_command("mvn -version")

    #######################################
    # Languages
    #######################################

    self._install_python()

    #
    # Dart
    #
    self.__run_command("curl https://storage.googleapis.com/dart-editor-archive-integration/latest/dartsdk-linux-64.tar.gz | tar xvz")

    #
    # Erlang
    #
    self.__run_command("sudo cp ../config/erlang.list /etc/apt/sources.list.d/erlang.list")
    self.__run_command("wget -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc | sudo apt-key add -")
    self.__run_command("sudo apt-get update")
    self.__run_command("sudo apt-get install esl-erlang -qq")

    #
    # nodejs
    #

    self.__run_command("curl http://nodejs.org/dist/v0.10.8/node-v0.10.8-linux-x64.tar.gz | tar xvz")

    #
    # Java
    #

    self.__run_command("sudo apt-get install openjdk-7-jdk -qq")
    self.__run_command("sudo apt-get remove --purge openjdk-6-jre openjdk-6-jre-headless -qq")

    #
    # Ruby/JRuby
    #

    self.__run_command("curl -L get.rvm.io | bash -s head")
    self.__run_command("echo rvm_auto_reload_flag=2 >> ~/.rvmrc")
    self.__run_command("bash -c 'source ~/.rvm/scripts/rvm && rvm install 2.0.0-p0'")
    self.__run_command("bash -c 'source ~/.rvm/scripts/rvm && rvm 2.0.0-p0 do gem install bundler'")
    self.__run_command("bash -c 'source ~/.rvm/scripts/rvm && rvm install jruby-1.7.4'")
    self.__run_command("bash -c 'source ~/.rvm/scripts/rvm && rvm jruby-1.7.4 do gem install bundler'")

    # We need a newer version of jruby-rack
    self.__run_command("git clone git://github.com/jruby/jruby-rack.git")
    self.__run_command("bash -c 'cd jruby-rack && source ~/.rvm/scripts/rvm && rvm jruby-1.7.4 do bundle install'")
    self.__run_command("bash -c 'cd jruby-rack && source ~/.rvm/scripts/rvm && rvm jruby-1.7.4 do jruby -S bundle exec rake clean gem SKIP_SPECS=true'")
    self.__run_command("bash -c 'cd jruby-rack/target && source ~/.rvm/scripts/rvm && rvm jruby-1.7.4 do gem install jruby-rack-1.2.0.SNAPSHOT.gem'")

    #
    # go
    #

    self.__run_command("curl http://go.googlecode.com/files/go1.1.1.linux-amd64.tar.gz | tar xvz")

    #
    # Perl
    #
    
    # Sometimes this HTTP server returns 404, so retry a few times until it works, but don't retry forever
    tries = 0
    while True:
        self.__run_command("curl http://downloads.activestate.com/ActivePerl/releases/5.16.3.1603/ActivePerl-5.16.3.1603-x86_64-linux-glibc-2.3.5-296746.tar.gz | tar xvz");
        if os.path.exists(os.path.join('installs', 'ActivePerl-5.16.3.1603-x86_64-linux-glibc-2.3.5-296746')):
            break
        tries += 1
        if tries >= 30:
            raise Exception('Could not download ActivePerl after many retries')
        time.sleep(5)

    self.__run_command("sudo bash -c 'cd ActivePerl-5.16.3.1603-x86_64-linux-glibc-2.3.5-296746 && yes | ./install.sh --license-accepted --prefix /opt/ActivePerl-5.16 --no-install-html'")
    self.__run_command("curl -L http://cpanmin.us | perl - --sudo App::cpanminus")
    self.__run_command("cpanm -f -S DBI DBD::mysql Kelp Dancer Mojolicious Kelp::Module::JSON::XS Dancer::Plugin::Database Starman Plack JSON Web::Simple DBD::Pg JSON::XS EV HTTP::Parser::XS Monoceros EV IO::Socket::IP IO::Socket::SSL")

    #
    # php
    #

    self.__run_command("wget --trust-server-names http://www.php.net/get/php-5.4.13.tar.gz/from/us1.php.net/mirror")
    self.__run_command("tar xvf php-5.4.13.tar.gz")
    self.__run_command("cd php-5.4.13 && ./configure --with-pdo-mysql --with-mysql --with-mcrypt --enable-intl --enable-mbstring --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --with-openssl")
    self.__run_command("cd php-5.4.13 && make")
    self.__run_command("cd php-5.4.13 && sudo make install")
    self.__run_command("cd php-5.4.13 && printf \"\\n\" | sudo pecl install apc-beta")
    self.__run_command("sudo cp ../config/php.ini /usr/local/lib/php.ini")
    self.__run_command("sudo cp ../config/php-fpm.conf /usr/local/lib/php-fpm.conf")
    self.__run_command("rm php-5.4.13.tar.gz")

    # Composer
    self.__run_command("curl -sS https://getcomposer.org/installer | php -- --install-dir=bin")

    # Phalcon
    self.__run_command("git clone git://github.com/phalcon/cphalcon.git")
    self.__run_command("cd cphalcon/build && sudo ./install")

    # YAF
    self.__run_command("sudo pecl install yaf")

    #
    # Haskell
    #

    self.__run_command("sudo apt-get install ghc cabal-install -qq")

    #
    # RingoJs
    #
    self.__run_command("wget http://www.ringojs.org/downloads/ringojs_0.9-1_all.deb")
    self.__run_command("sudo apt-get install jsvc -qq")
    self.__run_command("sudo DEBIAN_FRONTEND=noninteractive dpkg -i ringojs_0.9-1_all.deb")
    self.__run_command("rm ringojs_0.9-1_all.deb")

    #
    # Mono
    #
    self.__run_command("git clone git://github.com/mono/mono")
    self.__run_command("cd mono && git checkout mono-3.0.10")
    self.__run_command("cd mono && ./autogen.sh --prefix=/usr/local")
    self.__run_command("cd mono && make get-monolite-latest")
    self.__run_command("cd mono && make EXTERNAL_MCS=${PWD}/mcs/class/lib/monolite/gmcs.exe")
    self.__run_command("cd mono && sudo make install")

    self.__run_command("mozroots --import --sync")

    self.__run_command("git clone git://github.com/mono/xsp")
    self.__run_command("cd xsp && git checkout 3.0")
    self.__run_command("cd xsp && ./autogen.sh --prefix=/usr/local")
    self.__run_command("cd xsp && make")
    self.__run_command("cd xsp && sudo make install")

    #
    # Nimrod
    #
    self.__run_command("wget http://www.nimrod-code.org/download/nimrod_0.9.2.zip")
    self.__run_command("unzip nimrod_0.9.2.zip")
    self.__run_command("cd nimrod && chmod +x build.sh")
    self.__run_command("cd nimrod && ./build.sh")
    self.__run_command("cd nimrod && chmod +x install.sh")
    self.__run_command("cd nimrod && sudo ./install.sh /usr/bin")

    #######################################
    # Webservers
    #######################################

    #
    # Nginx
    #
    self.__run_command("curl http://nginx.org/download/nginx-1.4.1.tar.gz | tar xvz")
    self.__run_command("cd nginx-1.4.1 && ./configure")
    self.__run_command("cd nginx-1.4.1 && make")
    self.__run_command("cd nginx-1.4.1 && sudo make install")

    #
    # Openresty (nginx with openresty stuff)
    #
    self.__run_command("curl http://openresty.org/download/ngx_openresty-1.2.7.5.tar.gz | tar xvz")
    self.__run_command("cd ngx_openresty-1.2.7.5 && ./configure --with-luajit")
    self.__run_command("cd ngx_openresty-1.2.7.5 && make")
    self.__run_command("cd ngx_openresty-1.2.7.5 && sudo make install")

    #
    # Resin
    #

    self.__run_command("sudo cp -r /usr/lib/jvm/java-1.7.0-openjdk-amd64/include /usr/lib/jvm/java-1.7.0-openjdk-amd64/jre/bin/")
    self.__run_command("curl http://www.caucho.com/download/resin-4.0.36.tar.gz | tar xz")
    self.__run_command("cd resin-4.0.36 && ./configure --prefix=`pwd`")
    self.__run_command("cd resin-4.0.36 && make")
    self.__run_command("cd resin-4.0.36 && sudo make install")
    self.__run_command("cd resin-4.0.36 && mv conf/resin.properties conf/resin.properties.orig")
    self.__run_command("cat ../config/resin.properties > resin-4.0.36/conf/resin.properties")
    self.__run_command("cd resin-4.0.36 && mv conf/resin.xml conf/resin.xml.orig")
    self.__run_command("cat ../config/resin.xml > resin-4.0.36/conf/resin.xml")

    ##############################################################
    # Frameworks
    ##############################################################

    #
    # Grails
    #
    self.__run_command("wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.1.1.zip")
    self.__run_command("unzip -o grails-2.1.1.zip")
    self.__run_command("rm grails-2.1.1.zip")

    #
    # Play 2
    #
    self.__run_command("wget http://downloads.typesafe.com/play/2.1.2-RC1/play-2.1.2-RC1.zip")
    self.__run_command("unzip -o play-2.1.2-RC1.zip")
    self.__run_command("rm play-2.1.2-RC1.zip")

    #
    # Play 1
    #
    self.__run_command("wget http://downloads.typesafe.com/releases/play-1.2.5.zip")
    self.__run_command("unzip -o play-1.2.5.zip")
    self.__run_command("rm play-1.2.5.zip")
    self.__run_command("mv play-1.2.5/play play-1.2.5/play1")

    # siena
    self.__run_command("yes | play-1.2.5/play1 install siena")

    #
    # TreeFrog Framework
    #
    self.__run_command("sudo apt-get install qt4-qmake libqt4-dev libqt4-sql-mysql g++ -qq")
    self.__run_command("wget http://downloads.sourceforge.net/project/treefrog/src/treefrog-1.6.tar.gz")
    self.__run_command("tar xzf treefrog-1.6.tar.gz")
    self.__run_command("rm treefrog-1.6.tar.gz")
    self.__run_command("cd treefrog-1.6 && ./configure --enable-mongo")
    self.__run_command("cd treefrog-1.6/src && make")
    self.__run_command("cd treefrog-1.6/src && sudo make install")
    self.__run_command("cd treefrog-1.6/tools && make")
    self.__run_command("cd treefrog-1.6/tools && sudo make install")

    #
    # Vert.x
    #
    self.__run_command("curl http://vertx.io/vertx-downloads/downloads/vert.x-1.3.1.final.tar.gz | tar xvz")

    #
    # Yesod
    #
    self.__run_command("cabal update")
    self.__run_command("cabal install yesod persistent-mysql")

    #
    # Jester
    #
    self.__run_command("git clone git://github.com/dom96/jester.git jester/jester")

    print("\nINSTALL: Finished installing server software\n")
  ############################################################
  # End __install_server_software
  ############################################################

  def _install_python(self):
    # .profile is not loaded yet. So we should use full path.
    pypy_bin   = "pypy/bin"
    python_bin = "py2/bin"
    python3_bin= "py3/bin"
    def easy_install(pkg, two=True, three=False, pypy=False):
      cmd = "/easy_install -ZU '" + pkg + "'"
      if two:   self.__run_command(python_bin + cmd)
      if three: self.__run_command(python3_bin + cmd)
      if pypy:  self.__run_command(pypy_bin + cmd)

    self.__run_command("curl -L http://bitbucket.org/pypy/pypy/downloads/pypy-2.0.2-linux64.tar.bz2 | tar xj")
    self.__run_command('ln -sf pypy-2.0.2 pypy')
    self.__run_command("curl -L http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tgz | tar xz")
    self.__run_command("curl -L http://www.python.org/ftp/python/3.3.2/Python-3.3.2.tar.xz | tar xJ")
    self.__run_command("cd Python-2.7.5 && ./configure --prefix=$HOME/FrameworkBenchmarks/installs/py2 --disable-shared CC=gcc-4.8")
    self.__run_command("cd Python-3.3.2 && ./configure --prefix=$HOME/FrameworkBenchmarks/installs/py3 --disable-shared CC=gcc-4.8")
    self.__run_command("cd Python-2.7.5 && make -j")
    self.__run_command("cd Python-2.7.5 && make install")
    self.__run_command("cd Python-3.3.2 && make -j")
    self.__run_command("cd Python-3.3.2 && make install")

    self.__run_command("wget https://bitbucket.org/pypa/setuptools/downloads/ez_setup.py")
    self.__run_command(pypy_bin + "/pypy ez_setup.py")
    self.__run_command(python_bin + "/python ez_setup.py")
    self.__run_command(python3_bin + "/python3 ez_setup.py")

    easy_install('pip==1.3.1', two=True, three=True, pypy=True)
    easy_install('MySQL-python==1.2.4', two=True, three=False, pypy=True)
    easy_install('https://github.com/clelland/MySQL-for-Python-3/archive/master.zip',
                 two=False, three=True, pypy=False)
    easy_install('PyMySQL==0.5', pypy=True)
    easy_install('PyMySQL3==0.5', two=False, three=True)
    easy_install('simplejson==3.3.0', two=True, three=True, pypy=False)
    easy_install('psycopg2==2.5.1', three=True)
    easy_install('ujson==1.33', three=True)
    easy_install('https://github.com/downloads/surfly/gevent/gevent-1.0rc2.tar.gz', three=True)
    easy_install('uwsgi', three=True)  # uwsgi is released too often to stick on single version.

    # Gunicorn
    easy_install('gunicorn==17.5', two=True, three=True, pypy=True)
    # meinheld HEAD supports gunicorn worker on Python 3
    easy_install('https://github.com/mopemope/meinheld/archive/master.zip',
                 two=True, three=True, pypy=True)

    # Tornado
    easy_install('tornado==3.1', two=True, three=True, pypy=True)
    easy_install('motor==0.1.1', two=True, three=True, pypy=True)
    easy_install('pymongo==2.5.2', two=True, three=True, pypy=True)

    # Django
    easy_install("https://www.djangoproject.com/download/1.6b1/tarball/", two=True, three=True, pypy=True)

    # Flask
    easy_install('Werkzeug==0.9.2', two=True, three=True, pypy=True)
    easy_install('flask==0.10.1', two=True, three=True, pypy=True)
    easy_install('sqlalchemy==0.8.2', two=True, three=True, pypy=True)
    easy_install('Jinja2==2.7', two=True, three=True, pypy=True)
    easy_install('Flask-SQLAlchemy==1.0', two=True, three=True, pypy=True)

    # Bottle
    easy_install('bottle==0.11.6', two=True, three=True, pypy=True)
    easy_install('bottle-sqlalchemy==0.4', two=True, three=True, pypy=True)

  ############################################################
  # __install_error
  ############################################################
  def __install_error(self, message):
    print("\nINSTALL ERROR: %s\n" % message)
    if self.benchmarker.install_error_action == 'abort':
      sys.exit("Installation aborted.")
  ############################################################
  # End __install_error
  ############################################################

  ############################################################
  # __install_client_software
  ############################################################
  def __install_client_software(self):
    print("\nINSTALL: Installing client software\n")

    self.__run_command("cd .. && " + self.benchmarker.sftp_string(batch_file="config/client_sftp_batch"))

    remote_script = """

    ##############################
    # Prerequisites
    ##############################
    yes | sudo apt-get update
    yes | sudo apt-get install build-essential git libev-dev libpq-dev libreadline6-dev postgresql
    sudo sh -c "echo '*               -    nofile          16384' >> /etc/security/limits.conf"

    sudo mkdir -p /ssd
    sudo mkdir -p /ssd/log

    ##############################
    # MySQL
    ##############################
    sudo sh -c "echo mysql-server mysql-server/root_password_again select secret | debconf-set-selections"
    sudo sh -c "echo mysql-server mysql-server/root_password select secret | debconf-set-selections"

    yes | sudo apt-get install mysql-server

    sudo stop mysql
    # use the my.cnf file to overwrite /etc/mysql/my.cnf
    sudo mv /etc/mysql/my.cnf /etc/mysql/my.cnf.orig
    sudo mv my.cnf /etc/mysql/my.cnf

    sudo cp -R -p /var/lib/mysql /ssd/
    sudo cp -R -p /var/log/mysql /ssd/log
    sudo cp usr.sbin.mysqld /etc/apparmor.d/
    sudo /etc/init.d/apparmor reload
    sudo start mysql

    # Insert data
    mysql -uroot -psecret < create.sql

    ##############################
    # Postgres
    ##############################
    sudo useradd benchmarkdbuser -p benchmarkdbpass
    sudo -u postgres psql template1 < create-postgres-database.sql
    sudo -u benchmarkdbuser psql hello_world < create-postgres.sql

    sudo -u postgres -H /etc/init.d/postgresql stop
    sudo mv postgresql.conf /etc/postgresql/9.1/main/postgresql.conf
    sudo mv pg_hba.conf /etc/postgresql/9.1/main/pg_hba.conf

    sudo cp -R -p /var/lib/postgresql/9.1/main /ssd/postgresql
    sudo -u postgres -H /etc/init.d/postgresql start

    ##############################
    # wrk
    ##############################

    git clone https://github.com/wg/wrk.git
    cd wrk
    make
    sudo cp wrk /usr/local/bin
    cd ~

    git clone https://github.com/wg/wrk.git wrk-pipeline
    cd wrk-pipeline
    git checkout pipeline
    make
    sudo cp wrk /usr/local/bin/wrk-pipeline
    cd ~

    ##############################
    # MongoDB
    ##############################
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    sudo cp 10gen.list /etc/apt/sources.list.d/10gen.list
    sudo apt-get update
    yes | sudo apt-get install mongodb-10gen

    sudo stop mongodb
    sudo mv /etc/mongodb.conf /etc/mongodb.conf.orig
    sudo mv mongodb.conf /etc/mongodb.conf
    sudo cp -R -p /var/lib/mongodb /ssd/
    sudo cp -R -p /var/log/mongodb /ssd/log/
    sudo start mongodb
    """
    
    print("\nINSTALL: %s" % self.benchmarker.ssh_string)
    p = subprocess.Popen(self.benchmarker.ssh_string.split(" "), stdin=subprocess.PIPE)
    p.communicate(remote_script)
    returncode = p.returncode
    if returncode != 0:
      self.__install_error("status code %s running subprocess '%s'." % (returncode, self.benchmarker.ssh_string))

    print("\nINSTALL: Finished installing client software\n")
  ############################################################
  # End __install_client_software
  ############################################################

  ############################################################
  # __run_command
  # All commands run as-is on install_dir
  # and generate logs which can be reviewed
  # with grep '^INSTALL'
  ############################################################
  def __run_command(self, command):
    print("\nINSTALL: %s" % command)
    returncode = subprocess.call(command, shell=True, cwd=self.install_dir)
    if returncode != 0:
      self.__install_error("status code %s running command '%s' in directory '%s'." % (returncode, command, self.install_dir))
  ############################################################
  # End __run_command
  ############################################################

  ############################################################
  # __init__(benchmarker)
  ############################################################
  def __init__(self, benchmarker):
    self.benchmarker = benchmarker
    self.install_dir = "installs"

    try:
      os.mkdir(self.install_dir)
    except OSError:
      pass
  ############################################################
  # End __init__
  ############################################################

# vim: sw=2
