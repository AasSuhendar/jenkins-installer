#!/bin/bash -e
MY_PATH=$(pwd)

echo "--------------------------------------------------"
echo "Jenkins Master Installer for Debian/Ubuntu"
echo "Email: aas.suhendar@gmail.com"
echo "--------------------------------------------------"


echo ""
echo "[1] Configuring Directory"
echo "--------------------------------------------------"
groupadd jenkins \
  && useradd -d "/var/lib/jenkins" -g jenkins -m -s /bin/bash jenkins \
  && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
  && mkdir -p /usr/share/jenkins \
  && mkdir -p /usr/share/jenkins/ref/init.groovy.d \
  && chown -R jenkins:jenkins /var/lib/jenkins /usr/share/jenkins /usr/share/jenkins/ref

echo ""
echo "Please insert new password for jenkins user"
passwd jenkins

echo ""
echo "Generating SSH keys for jenkins user"
ssh-keygen -t rsa -b 4096

rm -rf ~jenkins/.ssh
mkdir ~jenkins/.ssh
cp ~/.ssh/* ~jenkins/.ssh/

chown -R jenkins:jenkins ~jenkins/.ssh
chmod 755 ~jenkins/.ssh

chown -R jenkins:jenkins ~jenkins/.ssh/id_rsa
chmod 600 ~jenkins/.ssh/id_rsa
echo "--------------------------------------------------"


echo ""
echo "[2] Configuring Environment"
echo "--------------------------------------------------"
if [ $(cat ~/.bashrc | grep COPY_REFERENCE_FILE_LOG | wc -l) -eq 0 ]; then
  echo "" >> ~/.bashrc \
  && echo "export COPY_REFERENCE_FILE_LOG=/var/lib/jenkins/copy_reference_file.log" >> ~/.bashrc
fi
if [ $(cat /var/lib/jenkins/.bashrc | grep COPY_REFERENCE_FILE_LOG | wc -l) -eq 0 ]; then
  echo "" >> ~/.bashrc \
  && echo "export COPY_REFERENCE_FILE_LOG=/var/lib/jenkins/copy_reference_file.log" >> /var/lib/jenkins/.bashrc
fi

if [ $(cat ~/.bashrc | grep JENKINS_UC | wc -l) -eq 0 ]; then
  echo "export JENKINS_UC=https://updates.jenkins.io" >> ~/.bashrc
fi
if [ $(cat /var/lib/jenkins/.bashrc | grep JENKINS_UC | wc -l) -eq 0 ]; then
  echo "export JENKINS_UC=https://updates.jenkins.io" >> /var/lib/jenkins/.bashrc
fi

if [ $(cat ~/.bashrc | grep JENKINS_UC_EXPERIMENTAL | wc -l) -eq 0 ]; then
  echo "export JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental" >> ~/.bashrc
fi
if [ $(cat /var/lib/jenkins/.bashrc | grep JENKINS_UC_EXPERIMENTAL | wc -l) -eq 0 ]; then
  echo "export JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental" >> /var/lib/jenkins/.bashrc
fi

if [ $(cat ~/.bashrc | grep JENKINS_SLAVE_AGENT_PORT | wc -l) -eq 0 ]; then
  echo "export JENKINS_SLAVE_AGENT_PORT=50000" >> ~/.bashrc
fi
if [ $(cat /var/lib/jenkins/.bashrc | grep JENKINS_SLAVE_AGENT_PORT | wc -l) -eq 0 ]; then
  echo "export JENKINS_SLAVE_AGENT_PORT=50000" >> /var/lib/jenkins/.bashrc
fi

if [ $(cat ~/.bashrc | grep JENKINS_HOME | wc -l) -eq 0 ]; then
  echo "export JENKINS_HOME=/var/lib/jenkins" >> ~/.bashrc
fi
if [ $(cat /var/lib/jenkins/.bashrc | grep JENKINS_HOME | wc -l) -eq 0 ]; then
  echo "export JENKINS_HOME=/var/lib/jenkins" >> /var/lib/jenkins/.bashrc
fi
echo "--------------------------------------------------"


echo ""
echo "[3] Installing Prequisites"
echo "--------------------------------------------------"
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
  && apt-get -y -o Acquire::Check-Valid-Until=false update \
  && apt-get -y -o Acquire::Check-Valid-Until=false install \
      apt-transport-https \
      bzip2 \
      ca-certificates-java \
      curl \
      git \
      maven \
      openjdk-8-jdk \
      ttf-mscorefonts-installer \
      ttf-dejavu \
      tzdata \
      unzip \
      wget \
      xz-utils \
  && apt-get -y -o Acquire::Check-Valid-Until=false autoremove \
  && apt-get -y -o Acquire::Check-Valid-Until=false clean
echo "--------------------------------------------------"


echo ""
echo "[6] Installing Jenkins"
echo "--------------------------------------------------"
cd $MY_PATH \
  && cp $MY_PATH/bin/* /usr/local/bin/ \
  && chmod 755 /usr/local/bin/jenkins.sh \
  && chmod 755 /usr/local/bin/jenkins-support.sh \
  && chmod 755 /usr/local/bin/install-plugins.sh \
  && chmod 755 /usr/local/bin/plugins.sh \
  && cp ./lib/init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/ \
  && chmod -R 775 /usr/share/jenkins/ref/init.groovy.d \
  && cd /usr/share/jenkins \
  && wget -O jenkins.war http://mirrors.jenkins.io/war-stable/latest/jenkins.war \
  && chown -R jenkins:jenkins /usr/share/jenkins \
  && chmod 755 /usr/share/jenkins/jenkins.war
echo "--------------------------------------------------"


echo ""
echo "[7] Restarting System"
echo "--------------------------------------------------"
reboot
echo "--------------------------------------------------"


exit 0
