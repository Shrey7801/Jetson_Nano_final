main="main.txt"

mode='false'
echo "WARNINGS"
echo "TYPE 'sudo reboot' IN CASE OF UNFAMILIAR ERRORS"
echo "If camera error is encountered, type the following command"
echo "'systemctl restart nvargus-daemon'"
echo "Password is 123"

while [ $mode != 'e' ]
  do  
   echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : Restarting the pipeline using(nvargus-daemon service)...." >> $main
   systemctl restart nvargus-daemon  
   echo "Enter 'p' for capturing photos"
   echo "Enter 'v' for capturing videos"
   echo "Enter 't' for testing"
   echo "Enter 'e' for exit"

   read mode
   
    if [ "$mode" = "p" ] || [ "$mode" = "P" ];
    then
        echo "Enter duration(in hours) for capturing photos"
        read capture_duration
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : MODE 'p' SELECTED " >> $main
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : capturing photos at 5 frames per second for $capture_duration minutes............" >> $main
        echo "capturing photos..."
        python3 frame_capture.py $capture_duration 
        echo "------------------------------PHOTOS CAPTURED------------------------------"
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : PHOTOS CAPTURED " >> $main
    elif [ "$mode" = "v" ] || [ "$mode" = "V" ];
    then
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : MODE 'v' SELECTED " >> $main
        ./cam_capture.sh 
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : VIDEOS CAPTURED " >> $main
        echo "------------------------------VIDEOS CAPTURED------------------------------"
    elif [ "$mode" = "t" ] || [ "$mode" = "T" ];
    then
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : MODE 't' SELECTED " >> $main
        echo "testing algorithm..."
        cd Downloads/ML-Fabric-Fault/
        fuser -k 8000/tcp
        python3 main.py 
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : TESTING COMPLETED " >> $main
        cd
    elif [ "$mode" = "e" ] || [ "$mode" = "e" ];
    then
        echo "----------------------------------EXITING----------------------------------"
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : ----------------------------------------  EXITING  ----------------------------------------" >> $main
    else
        echo "$(date +'%d/%m/%Y  %H:%M:%S')  INFO : Please enter valid option" >> $main
        echo "Please enter valid option"
    fi
done
