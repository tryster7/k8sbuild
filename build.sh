#!/bin/sh

# Set your GCP project ID and the zone where you want to create 
# the Kubeflow deployment:
if [ -z $PROJECT ]
then
	echo "GCP Project : "
	read PROJECT
	echo "You entered $PROJECT. Is this correct (Y/N)?"
	read ans
	while [ $ans = 'N' ] || [ $ans = 'n' ]
	do
		clear
		echo "GCP Project :" 
		read PROJECT
		echo "You entered $PROJECT. Is this correct (Y/N)?"
		read ans	
	done
else 
	echo "GCP Project set to $PROJECT."
fi

echo "##############"
if [ -z $ZONE ]
then 
	echo "GCP Zone" 
	read ZONE
	echo "GCP Zone Entered : $ZONE. Is this correct (Y/N)?"
	read ans
	while [ $ans = 'N' ] || [ $ans = 'n' ]
	do
		clear
		echo "GCP Zone" 
		read ZONE
		echo "You entered $ZONE. Is this correct (Y/N)?"
		read ans	
	done
else 
	echo "GCP Zone set to $ZONE"
fi


echo "##############"
if [ -z $CONFIG_URI ]
then 
	echo "Please provide deployment URL of the yaml file " 
	read CONFIG_URI
	echo "Deployment URI set to $CONFIG_URI. Is it correct (Y/N) ?"
	read ans
	while [ $ans = 'N' ] || [ $ans = 'n' ]
	do
		clear
		echo "Config URL for the yaml file"
		read CONFIG_URI
		echo "You entered $CONFIG_URI. Is this correct (Y/N)?"
		read ans
	done
else 
	echo "Config URI set to $CONFIG_URI"
fi

export KUBEFLOW_USERNAME=admin
export KUBEFLOW_PASSWORD=password
echo "##############"
echo "Default user is $KUBEFLOW_USERNAME "
echo "Default password is $KUBEFLOW_PASSWORD"


echo "##############"
if [ -z $KF_NAME ]
then 
	echo "Deployment URL is set to $CONFIG_URI"
	echo "GCP Zone Entered : $ZONE. Is this correct (Y/N)?"
	read ans
	while [ $ans = 'N' ] || [ $ans = 'n' ]
	do
		clear
		echo "Config URL for the yaml file"
		read CONFIG_URI
		echo "You entered $CONFIG_URI. Is this correct (Y/N)?"
		read ans
	done
else 
	echo "Config URI set to $CONFIG_URI"
fi

echo "Downloading kubectl from kfctl_v0.7.0_linux.tar.gz"
echo "Kubectl will be downloaded at location : " 
echo $PWD
echo "Would you like to continue (Y/N)"
read ans
if [ $ans = 'n' ] || [ $ans = 'N' ] 
then 
	echo "Exiting ... " 
fi

FILE=kfctl_v0.7.2-rc.0-0-g4df0157_linux.tar.gz

if test -f "$FILE"; then
    echo "$FILE exist. Would not download it again"
else
   wget https://github.com/kubeflow/kfctl/releases/download/v0.7.2-rc.0/kfctl_v0.7.2-rc.0-0-g4df0157_linux.tar.gz
   #wget https://github.com/kubeflow/kfctl/releases/download/v1.0-rc.1/kfctl_v1.0-rc.1-0-g963c787_linux.tar.gz
fi
tar -xvzf  kfctl_v0.7.2-rc.0-0-g4df0157_linux.tar.gz

export BASE_DIR=$PWD
export KF_DIR=${BASE_DIR}/${KF_NAME}
export PATH=$PATH:$KF_DIR

echo "Setting kubeflow installation directory to $KF_DIR"
echo "Deleting $KF_DIR if it exists"

echo "Would you like to continue (Y/N)?"
read ans
if [ $ans = 'n' ] || [ $ans = 'N' ]
then 
	exit -1
fi

rm -Rf $KF_DIR

echo "Kubeflow namespace is set to $NAMESPACE"

#kubectl create namespace $NAMESPACE

mkdir $KF_DIR
echo "Going to the directory $KF_DIR"
cd $KF_DIR
~/kfctl apply -V --file=${CONFIG_URI}

if [ $? -eq 0 ]
then
	echo "############################################################################"
	echo "##########                   SUCCESSFULLY DEPLOYED                ##########"
	echo "############################################################################"

	echo "The endpoint details are "

	kubectl -n istio-system get ingress
fi
