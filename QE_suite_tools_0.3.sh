#!/bin/bash

function check_dir_exist_or_create(){
	a=$(ls ~/Desktop|grep "yourtests")
	echo $a
	if [ "$a" != "yourtests" ]; then
		echo
		echo  -e '\xE2\x9C\x94'  "Making a folder on the desktop to put your tests into."
		mkdir -m 755 ~/Desktop/yourtests
		echo
		echo -e '\xE2\x9C\x94'  "'yourtests' folder created."	
	else
		echo
		echo -e '\xE2\x9D\x8C'  "'yourtests' folder already exists. Skipping folder creation."
		echo
	fi
}

copy_test_apps(){
	check_dir_exist_or_create
	sleep 3
	if  [ "$(ls ~/Desktop/"yourtests"/)" == "" ]; then
		echo
		read -p "Enter the test folder name to be copied to 'yourtests' folder: " test_folder
		test_source_dir="/Users/lokeshchoudhary/Desktop/Repositories/qe-FeatureTest/$test_folder/."
		test_destination_dir="/Users/lokeshchoudhary/Desktop/yourtests"	
		echo  -e '\xE2\x9C\x94'  "Copying tests ..... "
		echo
		cp -r $test_source_dir $test_destination_dir
		echo
		echo DONE
	else
		echo
		echo -e '\xE2\x9D\x8C'  "You already have tests in the 'yourtests' folder. Install them using option '2' or delete them using option '4'."
		echo
	fi
}

function getdeviceid(){
	echo
	echo -e '\xE2\x9C\x94'  "Getting device serial no ....."
	deviceid=$(adb get-serialno)
	echo -e '\xE2\x9C\x94'  "Device serial captured :"$deviceid
	echo
}

function import_apps(){
	cd ~/Desktop/"yourtests"/

	for dir in $(find . -maxdepth 1 -type d -name "TIMOB*");
	do 
		cd $dir
		echo
		echo "***** Importing Project: "+$dir+"*****"
		appc new --import --no-services
		echo -e '\xE2\x9C\x94'  "DONE IMPORTING :"$dir
		echo
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "timob*");
	do 
		cd $dir 
		echo
		echo "***** Importing Project: "+$dir+"*****"
		appc new --import --no-services
		echo -e '\xE2\x9C\x94'  "DONE IMPORTING :"$dir
		echo
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "*module*");
	do
		cd $dir
		echo
		echo "***** Importing Project: "+$dir+"*****"
		appc new --import --no-services
		echo -e '\xE2\x9C\x94'  "DONE IMPORTING :"$dir
		echo
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "*Module*");
	do
		cd $dir
		echo
		echo "***** Importing Project: "+$dir+"*****"
		appc new --import --no-services
		echo -e '\xE2\x9C\x94'  "DONE IMPORTING :"$dir
		echo
		cd ..
	done

	echo "***** DONE IMPORTING ALL PROJECT'S *****"
	echo
}

function change_uses-sdk(){
	if  [ "$(ls ~/Desktop/"yourtests"/)" ]; then
		echo -e '\xE2\x9C\x94'  "Tests exists in the 'yourtests' folder, continuing with changing <sdk-version> ....."
		echo
		read -p "Enter the SDK to change <uses-sdk> too :" sdk
		cd ~/Desktop/"yourtests"/
		for dir in $(find . -maxdepth 1 -type d -name "TIMOB*");
			do 
				cd $dir
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo -e '\xE2\x9C\x94'  "DONE CHANGING SDK"
				echo
				cd ..
			done

		for dir in $(find . -maxdepth 1 -type d -name "timob*");
			do 
				cd $dir
				echo 
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo -e '\xE2\x9C\x94'  "DONE CHANGING SDK IN :"$dir
				echo
				cd ..
			done

		for dir in $(find . -maxdepth 1 -type d -name "*module*");
			do
				cd $dir
				echo
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo -e '\xE2\x9C\x94'  "DONE CHANGING SDK IN :"$dir
				echo
				cd ..
			done

		for dir in $(find . -maxdepth 1 -type d -name "*Module*");
			do
				cd $dir
				echo
				echo "***** Changing <uses-sdk> in: "$dir"*****"
				xml ed -L -u ti:app/sdk-version -v $sdk tiapp.xml
				echo -e '\xE2\x9C\x94'  "DONE CHANGING SDK IN :"$dir
				echo
				cd ..
			done

			echo
			echo "***** DONE CHANGING <sdk-version> IN ALL PROJECT'S ***** "
			echo
	else
		copy_test_apps
		echo
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
		echo
		echo -e '\xE2\x9C\x94'  "DONE INSTALLING PROJECT :"$dir
		echo
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "timob*");
	do 
		cd $dir 
		echo
		echo "***** Installing Project: "+$dir+"*****"
		appc ti clean
		appc run -p android -T device --device-id $deviceid --no-launch
		echo
		echo -e '\xE2\x9C\x94'  "DONE INSTALLING PROJECT :"$dir
		echo
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "*module*");
	do
		cd $dir
		echo
		echo "***** Installing Project: "+$dir+"******"
		appc ti clean 
		appc run -p android -T device --device-id $deviceid --no-launch
		echo
		echo -e '\xE2\x9C\x94'  "DONE INSTALLING PROJECT :"$dir
		echo
		cd ..
	done

	for dir in $(find . -maxdepth 1 -type d -name "*Module*");
	do
		cd $dir
		echo
		echo "***** Installing Project: "+$dir+"*****"
		appc ti clean 
		appc run -p android -T device --device-id $deviceid --no-launch
		echo
		echo -e '\xE2\x9C\x94'  "DONE INSTALLING PROJECT :"$dir
		echo
		cd ..
	done

	echo "***** DONE INSTALLING ALL PROJECTS *****"
	echo
}

function install_individual_app(){
	echo -e '\xE2\x9C\x94'  "Make sure the app is in the 'yourtests' folder ....."
	echo
	read -p "Enter the name of the test app to install individually :" indi_app_name
	getdeviceid
	cd "/Users/lokeshchoudhary/Desktop/yourtests/$indi_app_name"
	echo " ***** Installing Project :$indi_app_name *****"
	echo
	appc run -p android -T device --device-id $deviceid --no-launch
	echo 
	echo -e '\xE2\x9C\x94'  "DONE INSTALLING PROJECT :$indi_app_name"
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

delete_test_apps(){
	echo
	rm -rf /Users/lokeshchoudhary/Desktop/yourtests
	echo -e '\xE2\x9C\x94'  "Deleting tests ..... "
	echo
	echo -e '\xE2\x9C\x94'  "DONE DELETING APPS"
	echo
}

function quit(){
	echo
	for pid in `ps -ef | grep dummy.sh | awk '{print $3}'` ;
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
	echo "1. COPY TEST APPS TO 'YOURTESTS' FOLDER."
	echo "2. INSTALL APPS FOR TESTING THE SUITES."
	echo "3. INSTALL INDIVIDUAL APP (which failed during automated install i.e step 2)."
	echo "4. REMOVE INSTALLED TEST APPS FROM DEVICE."
	echo "5. DELETE TEST APPS FROM 'YOURTESTS' FOLDER."
	echo "6. QUIT."
	echo
        # get input from the user
	read -p "Enter your choice :" choice
        # make decision using case..in..esac
	case $choice in
		1) 
			#Copy apps for the suites
			copy_test_apps
			;;
		2)
			#Install apps
			import_apps
			change_uses-sdk
			install_to_device
			;;
		3)  #Install individual app
			install_individual_app
			;;
		4)  #Remove installed apps from device
			remove_apps
			;;
		5)  #Delete test apps
			delete_test_apps
			;;
		6)
			#Quit
			quit
			;;
		*)
			#Invalid Option
			echo -e '\xE2\x9D\x8C'  "Error: Invalid option..."
			echo
			;;
	esac
done