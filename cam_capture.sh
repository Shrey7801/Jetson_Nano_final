mode=0
systemctl restart nvargus-daemon
while [ $mode != 'false' ]
do
    echo "Select any mode(Enter mode number): "
    echo "mode 1: resolution : 1080p fps: 30"
    echo "mode 2: resolution : 1080p fps: 60"
    echo "mode 3: resolution : 4k fps: 15"
    echo "mode 4: resolution : 4k fps: 30"

    read mode

    if [ $mode = 1 ];
    then    
        height='1080'
        width='1920'
        fps=30
        echo "You've selected mode $mode (width: $width height: $height fps: $fps)"
        break
    elif [ $mode = 2 ];
    then    
        height='1080'
        width='1920'
        fps=60
        echo "You've selected mode $mode (width: $width height: $height fps: $fps)"   
        break 
    elif [ $mode = 3 ];
    then    
        height='2160'
        width='3840'
        fps=15
        echo "You've selected mode $mode (width: $width height: $height fps: $fps)" 
        break
    elif [ $mode = 4 ];
    then    
        height='2160'
        width='3840'
        fps=30
        echo "You've selected mode $mode (width: $width height: $height fps: $fps)" 
        break
    else
        echo "Please select from the given modes"
    fi
done

# directory name is according to the timestamp
dir_name="$(date +'%d-%m-%Y__%H-%M-%S')"
mkdir Videos/"$dir_name"
log=Videos/"$dir_name"/log.txt

echo "Enter time duration(in hours) of video to be captured: "
read hours

echo "Enter time interval(in minutes) at which videos will be saved: "
read interval

echo "recording video for $hours hours..."
clear

echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : You've selected mode $mode (width: $width height: $height fps: $fps)" >> $log 
echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : Time duration(in hours) for video: $capture_time" >> $log
echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : Time interval(in minutes) for saving videos: $capture_time" >> $log

echo "You've selected mode $mode (width: $width height: $height fps: $fps)"
echo "Time duration(in hours) for video: $hours" 
echo "Time interval(in minutes) for saving videos: $interval" 

val=$(((hours*60+interval-1)/interval))

CPU_temp=$(cat /sys/class/thermal/thermal_zone1/temp)
GPU_temp=$(cat /sys/class/thermal/thermal_zone2/temp)
 
echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone1/type) : $(($CPU_temp/1000))" >> $log
echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone2/type) : $(($GPU_temp/1000))" >> $log

echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone1/type) : $(($CPU_temp/1000))" 
echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone2/type) : $(($GPU_temp/1000))"

echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : storing $val videos of interval $interval minutes......." >> $log

for i in $(seq $val); do

    if [ $i -eq $val ];
    then
        num_buffers=$(((($hours*60)-($interval*($val-1)))*fps*60))
        echo "num_buffers   :  "$num_buffers
    else
        num_buffers=$(($interval*$fps*60))
        echo "num_buffers   :  "$num_buffers
    fi

    vid_name="$(date +'%d-%m-%Y__%H-%M-%S')_duration-""$(($num_buffers/($fps*60)))""m_res-"$width"X"$height"_fps-"$fps".mp4"

    echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : Creating video with name $vid_name........................"  >> $log

    # command to capture video and saving it at specified location with specified name
    # num-buffers   = total frames to be captured
    # width,height  = resolution
    # framerate     = fps at which the video is recorded

    systemctl restart nvargus-daemon 
    gst-launch-1.0 nvarguscamerasrc sensor-id=0 num-buffers=$num_buffers ! 'video/x-raw(memory:NVMM), width='$width', height='$height', framerate='$fps'/1' ! nvvidconv flip-method=2 ! nvtee ! omxh264enc bitrate=20000000 ! qtmux ! filesink location=Videos/"$dir_name"/"$vid_name" >> $log

    echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : Storing video with name $vid_name ........................"  >> $log
    
    echo "-------------------------------------- Videos stored : $i --------------------------------------" 
    echo "-------------------------------------- Videos stored : $i --------------------------------------" >> $log

    CPU_temp=$(cat /sys/class/thermal/thermal_zone1/temp)
    GPU_temp=$(cat /sys/class/thermal/thermal_zone2/temp)
 
    echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone1/type) : $(($CPU_temp/1000))" >> $log
    echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone2/type) : $(($GPU_temp/1000))" >> $log

    echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone1/type) : $(($CPU_temp/1000))" 
    echo "$(date +'%d/%m/%Y  %H:%M:%S') INFO : $(cat /sys/devices/virtual/thermal/thermal_zone2/type) : $(($GPU_temp/1000))"
done
