#!/bin/sh

log="/root/nvidia_install.log"

driver_version="390.46"
cuda_version="9.1.85"

cuda_big_version=$(echo $cuda_version | awk -F'.' '{print $1"."$2}')

echo "install nvidia driver and cuda begin ......" >> $log 2>&1
echo "driver version: $driver_version" >> $log 2>&1
echo "cuda version: $cuda_version" >> $log 2>&1

##Centos
create_nvidia_repo_centos()
{
    url=$(cat /etc/yum.repos.d/CentOS-Base.repo |grep baseurl | head -1 | awk -F'[/]' '{print $1"//"$3}')
    if [ -z "$url" ]; then
        url="http://mirrors.cloud.aliyuncs.com"
    fi

    cudaurl=$url"/opsx/ecs/linux/rpm/cuda/${version}/\$basearch/"
    driverurl=$url"/opsx/ecs/linux/rpm/driver/${version}/\$basearch/"

    echo "[ecs-cuda]" |tee -a /etc/yum.repos.d/nvidia.repo
    echo "name=ecs cuda - \$basearch" | tee -a /etc/yum.repos.d/nvidia.repo
    echo $cudaurl | tee -a /etc/yum.repos.d/nvidia.repo
    echo "enabled=1" | tee -a /etc/yum.repos.d/nvidia.repo
    echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nvidia.repo

    echo "[ecs-driver]" | tee -a /etc/yum.repos.d/nvidia.repo
    echo "name=ecs driver - \$basearch" | tee -a /etc/yum.repos.d/nvidia.repo
    echo $driverurl | tee -a /etc/yum.repos.d/nvidia.repo
    echo "enabled=1" | tee -a /etc/yum.repos.d/nvidia.repo
    echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nvidia.repo
    yum clean all >> $log 2>&1
    yum makecache >> $log 2>&1

}

install_kernel_centos()
{
    #install kernel-devel
    kernel_version=$(uname -r)
    echo "******exec \"uname -r\": $kernel_version"

    echo "******exec \"rpm -qa | grep kernel-devel | grep $kernel_version | wc -l\""
    kernel_devel_num=$(rpm -qa | grep kernel-devel | grep $kernel_version | wc -l)
    echo "******kernel_devel_num=$kernel_devel_num"
    if [ $kernel_devel_num -eq 0 ];then
        echo "******exec \"yum install -y kernel-devel-$kernel_version\""
        yum install -y kernel-devel-$kernel_version
        if [ $? -ne 0 ]; then
            echo "error: install kernel-devel fail!!!"
            return 1
        fi
    fi

    #echo "******exec \"rpm -qa | grep kernel-headers | grep $kernel_version | wc -l\""
    #kernel_headers_num=$(rpm -qa | grep kernel-headers | grep $kernel_version | wc -l)
    #echo "******kernel_headers_num="$kernel_headers_num
    #if [ $kernel_headers_num -eq 0 ];then
    #    echo "******exec \"yum install -y kernel-headers-$kernel_version\""
    #    yum install -y kernel-headers-$kernel_version
    #fi

}


install_driver_centos()
{
    #install driver
    driver_file_num=$(yum list --showduplicates | grep nvidia | grep driver | grep $release | grep $driver_version | wc -l)
    if [ $driver_file_num -eq 1 ];then
        driver_file=$(yum list --showduplicates | grep nvidia | grep driver | grep $release | grep $driver_version | awk -F' ' '{print $1}')
        echo "******exec \"yum list --showduplicates |grep nvidia | grep driver |grep $release |grep $driver_version | awk -F' ' '{print \$1}'\":"
        echo $driver_file
    else
        echo "error: driver_file_num = $driver_file_num , get driver file failed, exit"
        return 1
    fi

    echo "******exec \"yum install -y $driver_file\" "
    yum install -y $driver_file

    echo "******exec \"yum clean all && yum install -y cuda-drivers\" "
    yum clean all && yum install -y cuda-drivers

    if [ $? -ne 0 ]; then
        echo "error: driver install fail!!!"
        return 1
    fi
}


install_cuda_centos()
{
    begin_cuda=$(date '+%s')
    cuda_file_num=$(yum list --showduplicates | grep cuda | grep $release | grep $cuda_version |grep -v update | wc -l)
    if [ $cuda_file_num -eq 1 ];then
        cuda_file=$(yum list --showduplicates | grep cuda | grep $release | grep $cuda_version | grep -v update | awk -F' ' '{print $1}')
        echo "******exec \"yum list --showduplicates |grep cuda |grep $release |grep $cuda_version|grep -v update| awk -F' ' '{print \$1}'\":"
        echo $cuda_file
    else
        echo "error: cuda_file_num = $cuda_file_num , get cuda file failed, exit"
        return 1
    fi

    #install cuda
    echo "******exec \"yum install -y $cuda_file\" "
    yum install -y $cuda_file

    end_cuda_unpack=$(date '+%s')
    time_cuda_unpack=$((end_cuda_unpack-begin_cuda))
    echo "******download and unpack cuda file end, end time: $end_cuda_unpack, use time $time_cuda_unpack s"


    echo "******exec \"yum list --showduplicates | grep cuda | grep $release | grep $cuda_big_version | grep update | awk -F' ' '{print \$1}'\" "
    cuda_patch_filelist=$(yum list --showduplicates | grep cuda | grep $release | grep $cuda_big_version | grep update | awk -F' ' '{print $1}')

    echo "****** cuda_patch_filelist"
    echo $cuda_patch_filelist
    for cuda_patch_file in $cuda_patch_filelist
    do
        echo "******exec \"yum install -y $cuda_patch_file\" "
        yum install -y $cuda_patch_file
    done

    echo "******exec \"yum clean all && yum install -y cuda\" "
    yum clean all && yum install -y cuda
    if [ $? -ne 0 ]; then
        echo "error: cuda install fail!!!"
        return 1
    fi

    end_cuda=$(date '+%s')
    time_cuda=$((end_cuda-begin_cuda))
    echo "******install cuda begin time: $begin_cuda, end time $end_cuda, use time $time_cuda s"
}

enable_pm()
{
    echo "#!/bin/bash" | tee -a /etc/init.d/enable_pm.sh
    echo "nvidia-smi -pm 1" | tee -a /etc/init.d/enable_pm.sh
    echo "exit 0" | tee -a /etc/init.d/enable_pm.sh

    chmod +x /etc/init.d/enable_pm.sh

    str=$(cat $filename |grep "exit")
    if [ -z "$str" ]; then
        echo "/etc/init.d/enable_pm.sh" | tee -a $filename
    else
        sed -i '/exit/i\/etc/init.d/enable_pm.sh' $filename
    fi
    chmod +x $filename

}

if [ ! -f "/usr/bin/lsb_release" ]; then
    pkgname=$(yum provides /usr/bin/lsb_release |grep centos|grep x86_64 |head -1 |awk -F: '{print $1}')
    yum install -y $pkgname
fi

str=$(lsb_release -i | awk -F':' '{print $2}')
os=$(echo $str | sed 's/ //g')
if [ "$os" = "CentOS" ]; then
    os="centos"
    str=$(lsb_release -r | awk -F'[:.]' '{print $2}')
    version=$(echo $str | sed 's/ //g')
    release="rhel${version}"
    filename="/etc/rc.d/rc.local"
else
    echo "ERROR: OS ($os) is invalid!" >> $log 2>&1
    exit 1
fi


echo "release:$release" >> $log 2>&1
echo "version:$version" >> $log 2>&1

create_nvidia_repo_centos

begin=$(date '+%s')
install_kernel_centos >> $log 2>&1 
if [ $? -ne 0 ]; then
    exit 1
fi
end=$(date '+%s')
time_kernel=$((end-begin))
echo "******install kernel-devel begin time: $begin, end time: $end, use time: $time_kernel s" >> $log 2>&1


begin_driver=$(date '+%s')
install_driver_centos >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error: driver download fail!!!" >> $log 2>&1
    exit 1
fi
end_driver=$(date '+%s')
time_driver=$((end_driver-begin_driver))
echo "******install driver begin time: $begin_driver, end time: $end_driver,  use time: $time_driver s" >> $log 2>&1

install_cuda_centos >> $log 2>&1 
if [ $? -ne 0 ]; then
    echo "error: cuda download fail!!!" >> $log 2>&1
    exit 1
fi

echo "******install kernel-devel use time $time_kernel s" >> $log 2>&1
echo "******install driver use time $time_driver s" >> $log 2>&1
echo "******install cuda use time $time_cuda s" >> $log 2>&1

echo "add auto enable Persistence Mode when start vm..." >> $log 2>&1
enable_pm

echo "reboot......" >> $log 2>&1
reboot