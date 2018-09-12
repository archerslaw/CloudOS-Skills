#!/bin/bash
############################################################################
#Function:    confiture mirrors source
#Usage:       bash mirror_source.sh
#Author:      Huawei Cloud OS Team
#Company:     Huawei Cloud Computing
#Version:     1.0
############################################################################

check_os_release()
{
  while true
  do
    os_release=$(grep "Red Hat Enterprise Linux Server release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "Red Hat Enterprise Linux Server release" /etc/redhat-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=redhat5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=redhat6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
###################################CentOS###########################################
    #Check CentOS version 
    os_release_2=$(grep "CentOS" /etc/*release 2>/dev/null)
    if [ "$os_release_2" ]
    then
      if echo "$os_release_2"|grep "release 5" >/dev/null 2>&1
      then
        os_release=centos5
        echo "$os_release"
      elif echo "$os_release_2"|grep "release 6" >/dev/null 2>&1
      then
        os_release=centos6
        echo "$os_release"
      elif echo "$os_release_2"|grep "release 7" >/dev/null 2>&1
      then
        os_release=centos7
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
################################Ubuntu###########################################
    os_release=$(grep -i "ubuntu" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "ubuntu" /etc/lsb-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Ubuntu 10" >/dev/null 2>&1
      then
        os_release=ubuntu10
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 12.04" >/dev/null 2>&1
      then
        os_release=ubuntu1204
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 14.04" >/dev/null 2>&1
      then
        os_release=ubuntu1404
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 16.04" >/dev/null 2>&1
      then
        os_release=ubuntu1604
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 18.04" >/dev/null 2>&1
      then
        os_release=ubuntu1804
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
#################################Debian###########################################
    os_release=$(grep -i "debian" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "debian" /proc/version 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Linux 7" >/dev/null 2>&1
      then
        os_release=debian7
        echo "$os_release"
      elif echo "$os_release"|grep "Linux 8" >/dev/null 2>&1
      then
        os_release=debian8
        echo "$os_release"
      elif echo "$os_release"|grep "Linux 9" >/dev/null 2>&1
      then
        os_release=debian9
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
#################################EulerOS############################################
    os_release_2=$(grep "EulerOS" /etc/*release 2>/dev/null)
    if [ "$os_release_2" ]
    then
      if echo "$os_release_2"|grep "EulerOS release 2.0 (SP1)" >/dev/null 2>&1
      then
        os_release=EulerOS2.0SP1
        echo "$os_release"
      elif echo "$os_release_2"|grep "EulerOS release 2.0 (SP2)" >/dev/null 2>&1
      then
        os_release=EulerOS2.0SP2
        echo "$os_release"
      elif echo "$os_release_2"|grep "EulerOS release 2.0 (SP3)" >/dev/null 2>&1
      then
        os_release=EulerOS2.0SP3
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
############################opensuse################################################
    os_release=$(grep -i "opensuse" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "opensuse" /etc/*release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"| grep "openSUSE 13" >/dev/null 2>&1  ||  echo "$os_release_2"|grep "openSUSE 13" >/dev/null 2>&1 
      then
        os_release=opensuse13
        echo "$os_release"
      elif echo "$os_release"|grep "openSUSE 42.2" >/dev/null 2>&1 || echo "$os_release_2"|grep "openSUSE 42.2" >/dev/null 2>&1 
      then
        os_release=opensuse4202
        echo "$os_release"
      elif echo "$os_release"|grep "openSUSE 42.3" >/dev/null 2>&1 || echo "$os_release_2"|grep "openSUSE 42.3" >/dev/null 2>&1
      then
        os_release=opensuse4203
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    break
    done
}

######################################################CentOS && RedHat#####################################
modify_rhel5_yum()
{
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-5.repo
  yum clean metadata
  yum makecache
  cd ~
}

modify_rhel6_yum()
{
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-6.repo
  wget -qO /etc/yum.repos.d/epel.repo http://mirrors.myhuaweicloud.com/repo/epel-6.repo
  yum clean metadata
  yum makecache
  cd ~
}

modify_rhel7_yum()
{
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-7.repo
  wget -qO /etc/yum.repos.d/epel.repo http://mirrors.myhuaweicloud.com/repo/epel-7.repo
  yum clean metadata
  yum makecache
  cd ~
}
###############################################  Euler OS ################################################
modify_euler21_yum()
{
  echo -e "\033[40;32mBackup the original configuration file to /tmp dir.\n\033[40;37m"
  mv /etc/yum.repos.d/*.repo /tmp/
  wget -O /etc/yum.repos.d/EulerOS-Base.repo http://mirrors.myhuaweicloud.com/repo/euler/EulerOS_2_1_base.repo
  yum clean metadata
  yum makecache
  cd ~
}

modify_euler22_yum()
{
  echo -e "\033[40;32mBackup the original configuration file to /tmp dir.\n\033[40;37m"
  mv /etc/yum.repos.d/*.repo /tmp/
  wget -O /etc/yum.repos.d/EulerOS-Base.repo http://mirrors.myhuaweicloud.com/repo/euler/EulerOS_2_2_base.repo
  yum clean metadata
  yum makecache
  cd ~
}
modify_euler23_yum()
{
  echo -e "\033[40;32mBackup the original configuration file to /tmp dir.\n\033[40;37m"
  mv /etc/yum.repos.d/*.repo /tmp/
  wget -O /etc/yum.repos.d/EulerOS-Base.repo http://mirrors.myhuaweicloud.com/repo/euler/EulerOS_2_3_base.repo
  yum clean metadata
  yum makecache
  cd ~
}
###############################################  Ubuntu ##################################################

update_ubuntu1204_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#12.04
deb http://mirrors.myhuaweicloud.com/ubuntu/ precise main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ precise-security main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ precise-proposed main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ precise main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ precise-security main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ precise-backports main restricted universe multiverse
EOF
apt-get update
}

update_ubuntu1404_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#14.04
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF
apt-get update
}

update_ubuntu1604_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#16.04
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ xenial-backports main restricted universe multiverse
EOF
apt-get update
}

update_ubuntu1804_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#18.04
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.myhuaweicloud.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.myhuaweicloud.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF
apt-get update
}


update_debian7_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#debian6
deb http://mirrors.myhuaweicloud.com/debian/ wheezy main non-free contrib
deb http://mirrors.myhuaweicloud.com/debian/ wheezy-proposed-updates main non-free contrib
deb-src http://mirrors.myhuaweicloud.com/debian/ wheezy main non-free contrib
deb-src http://mirrors.myhuaweicloud.com/debian/ wheezy-proposed-updates main non-free contrib
EOF
apt-get update
}

update_debian8_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#debian7
deb http://mirrors.myhuaweicloud.com/debian/ jessie main non-free contrib
deb http://mirrors.myhuaweicloud.com/debian/ jessie-proposed-updates main non-free contrib
deb-src http://mirrors.myhuaweicloud.com/debian/ jessie main non-free contrib
deb-src http://mirrors.myhuaweicloud.com/debian/ jessie-proposed-updates main non-free contrib
EOF
apt-get update
}

update_debian9_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#debian7
deb http://mirrors.myhuaweicloud.com/debian/ stable main non-free contrib
deb http://mirrors.myhuaweicloud.com/debian/ stable-proposed-updates main non-free contrib
deb-src http://mirrors.myhuaweicloud.com/debian/ stable main non-free contrib
deb-src http://mirrors.myhuaweicloud.com/debian/ stable-proposed-updates main non-free contrib
EOF
apt-get update
}

update_opensuse_source13()
{
  mv /etc/zypp/repos.d/* /tmp/
  zypper addrepo -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/openSUSE-stable/repo/oss/ openSUSE-13.2-Oss
  zypper addrepo -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/openSUSE-stable/repo/non-oss/ openSUSE-13.2-Non-Oss
  zypper addrepo -fcg http://mirrors.myhuaweicloud.com/opensuse/update/openSUSE-stable/ openSUSE-13.2-Update-Oss
  zypper addrepo -fcg http://mirrors.myhuaweicloud.com/opensuse/update/openSUSE-non-oss-current/ openSUSE-13.2-Update-Non-Oss
}

update_opensuse_source4202()
{
  mv /etc/zypp/repos.d/* /tmp/
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.2/repo/oss HWCloud:42.2:OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.2/repo/non-oss HWCloud:42.3:NON-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.2/oss HWCloud:42.2:UPDATE-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.2/non-oss HWCloud:42.2:UPDATE-NON-OSS
}

update_opensuse_source4203()
{
  mv /etc/zypp/repos.d/* /tmp/
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.3/repo/oss HWCloud:42.3:OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/distribution/leap/42.3/repo/non-oss HWCloud:42.3:NON-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.3/oss HWCloud:42.3:UPDATE-OSS
  sudo zypper ar -fcg http://mirrors.myhuaweicloud.com/opensuse/update/leap/42.3/non-oss HWCloud:42.3:UPDATE-NON-OSS
}

####################Start###################
#check lock file ,one time only let the script run one time 
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ]
then
  echo -e "\033[1;40;31mThe script is already exist,please next time to run this script.\n\033[0m"
  exit
else
  echo -e "\033[40;32mStep 1.No lock file,begin to create lock file and continue.\n\033[40;37m"
  touch $LOCKfile
fi

#check user
if [ $(id -u) != "0" ]
then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to install this script.\n\033[0m"
  rm -rf $LOCKfile
  exit 1
fi
echo -e "\033[40;32mStep 2.Begin to check the OS issue.\n\033[40;37m"
os_release=$(check_os_release)
if [ "X$os_release" == "X" ]
then
  echo -e "\033[1;40;31mThe OS does not identify,So this script is not executede.\n\033[0m"
  rm -rf $LOCKfile
  exit 0
else
  echo -e "\033[40;32mThis OS is $os_release.\n\033[40;37m"
fi

echo -e "\033[40;32mStep 3.Begin to modify the source configration file and update.\n\033[40;37m"
case "$os_release" in
aliyun5)
  modify_aliyun5_yum
  ;;
redhat5|centos5)
  modify_rhel5_yum
  ;;
redhat6|centos6|aliyun6)
  modify_rhel6_yum
  ;;
centos7|aliyun7)
  modify_rhel7_yum
  ;;
EulerOS2.0SP1)
  modify_euler21_yum
  ;;
EulerOS2.0SP2)
  modify_euler22_yum
  ;;
EulerOS2.0SP3)
  modify_euler23_yum
  ;;
ubuntu1204)
  update_ubuntu1204_apt_source
  ;;
ubuntu1404)
  update_ubuntu1404_apt_source
  ;;
ubuntu1604)
  update_ubuntu1604_apt_source
  ;;
ubuntu1804)
  update_ubuntu1804_apt_source
  ;;
debian7)
  update_debian7_apt_source
  ;;
debian8)
  update_debian8_apt_source
  ;;
debian9)
  update_debian9_apt_source
  ;;
opensuse13)
  update_opensuse_source13
  ;;
opensuse4202)
  update_opensuse_source4202
  ;;
opensuse4203)
  update_opensuse_source4203
  ;;
esac
echo -e "\033[40;32mSuccess,exit now!\n\033[40;37m"
rm -rf $LOCKfile
