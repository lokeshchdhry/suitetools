#!/bin/bash

function check_dir_exist_or_create(){
	a=$(ls ~/Desktop|grep "yourtests")
	echo $a
	if [ "$a" != "yourtests" ]; then
		echo
		echo "====> Making a folder on the desktop to put your tests into ....."
		echo
		mkdir -m 755 ~/Desktop/yourtests
		echo
		echo "====> 'yourtests folder created .....'"	
		echo
		echo "====> Please put your test apps in 'yourtests' folder."
		quit
	else
		echo
		echo "====> 'yourtests' folder already exists. Skipping folder creation ....."
		echo
	fi
}


function getdeviceid(){
	echo
	echo "====> Getting device serial no ....."
	deviceid=$(adb get-serialno)
	echo "====> Device serial captured :"$deviceid
	echo
}

function import_apps(){
	check_dir_exist_or_create
	echo

	if  [ "$(ls ~/Desktop/"yourtests"/)" == false ]; then
		echo "====> Please put your test app folders in 'yourtests' folder."
		quit
	else
		cd ~/Desktop/"yourtests"/

		for dir in $(find . -maxdepth 1 -type d -name "TIMOB*");
		do 
			cd $dir
			echo "***** Importing Project: "+$dir+"*****"
			appc new --import --no-services
			echo DONE
			cd ..
		done

		for dir in $(find . -maxdepth 1 -type d -name "timob*");
		do 
			cd $dir 
			echo "***** Importing Project: "+$dir+"*****"
			appc new --import --no-services
			echo DONE
			cd ..
		done

		for dir in $(find . -maxdepth 1 -type d -name "*module*");
		do
			cd $dir
			echo "***** Importing Project: "+$dir+"*****"
			appc new --import --no-services
			echo DONE
			cd ..
		done

		for dir in $(find . -maxdepth 1 -type d -name "*Module*");
		do
			cd $dir
			echo "***** Importing Project: "+$dir+"*****"
			appc new --import --no-services
			echo DONE
			cd ..
		done

		echo "***** DONE IMPORTING PROJECT'S *****"
		echo
	fi
}

function change_uses-sdk(){
	if  [ "$(ls ~/Desktop/"yourtests"/)" ]; then
		echo "====> Tests exists in the 'yourtests' folder, continuing with changing <sdk-version> ....."
		echo
		read -p "Enter the SDK to change <uses-sdk> too :" sdk
		cd ~/Desktop/"yourtests"/
		for dir in $(find . -maxdepth 1 -type d -name "TIMOB*");
			do 
				cd $dir
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo DONE
				cd ..
			done

		for dir in $(find . -maxdepth 1 -type d -name "timob*");
			do 
				cd $dir 
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo DONE
				cd ..
			done

		for dir in $(find . -maxdepth 1 -type d -name "*module*");
			do
				cd $dir
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo DONE
				cd ..
			done

		for dir in $(find . -maxdepth 1 -type d -name "*Module*");
			do
				cd $dir
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo DONE
				cd ..
			done

			echo
			echo "***** DONE CHANGING <sdk-version> IN THE PROJECT'S ***** "
			echo
	else
		echo "====> Please copy your test apps in the 'your tests' folder."
		echo
		quit
	fi
	echo	
}


function install_to_device(){
	getdeviceid

	cd ~/Desktop/"yourtests"/

	for dir in $(find . -maxdepth 1 -type d -name "TIMOB*");
	do 
		cd $dir
		echo "***** Installing Project: "+$dir+"*****"
		appc ti clean
		appc run -p android -T device --deviceid $device-id --no-launch
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "timob*");
	do 
		cd $dir 
		echo "***** Installing Project: "+$dir+"*****"
		appc ti clean
		appc run -p android -T device --device-id $deviceid --no-launch
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "*module*");
	do
		cd $dir
		echo "***** Installing Project: "+$dir+"******"
		appc ti clean 
		appc run -p android -T device --device-id $deviceid --no-launch
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "*Module*");
	do
		cd $dir
		echo "***** Installing Project: "+$dir+"*****"
		appc ti clean 
		appc run -p android -T device --device-id $deviceid --no-launch
		cd ..
	done

	echo "***** DONE INSTALLING PROJECTS *****"
	echo
}

function remove_apps(){
	adb shell rm -R /sdcard/com.appcelerator.*
	adb shell pm list packages | grep -i com.appc* | tr -d "\r" | while read line;
	do
	echo ${line:8};
	adb uninstall ${line:8};
	done
}

function quit(){
	echo
	for pid in `ps -ef | grep QE_suite_tools.sh | awk '{print $3}'` ;
		do
			kill $pid ;
		done
}

# set an infinite loop
while :
do
        # display menu
    echo
    echo "QE TEST SUITE TOOLS"
	echo "||===============================||"
	echo "||    WHAT DO YOU WANT TO DO     ||"
	echo "||===============================||"
	echo "1. INSTALL APPS FOR TESTING THE SUITES."
	echo "2. REMOVE INSTALLED TEST APPS."
	echo "3. QUIT."
	echo
        # get input from the user
	read -p "Enter your choice :" choice
        # make decision using case..in..esac
	case $choice in
		1) 
			#Install apps for the suites
			import_apps
			change_uses-sdk
			install_to_device
			;;
		2)
			#Remove installed apps
			remove_apps
			;;
		3)
			#Quit
			quit
			;;
		*)
			#Invalid Option
			echo "Error: Invalid option..."
			echo
			;;
	esac
done