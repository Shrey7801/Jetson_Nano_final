import os
import cv2
import sys
import time
from datetime import datetime

def gstreamer_pipeline(
    sensor_id=0,
    capture_width=3840,
    capture_height=2160,
    display_width=3840,
    display_height=2160,
    framerate=5,
    flip_method=0,
):
    return (
        "nvarguscamerasrc sensor-id=%d !"
        "video/x-raw(memory:NVMM), width=(int)%d, height=(int)%d, framerate=(fraction)%d/1 ! "
        "nvvidconv flip-method=%d ! "
        "video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! "
        "videoconvert ! "
        "video/x-raw, format=(string)BGR ! appsink"
        % (
            sensor_id,
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height,
        )
    )
os.chdir("Pictures")
dir_name=datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
os.mkdir(dir_name)
os.chdir(dir_name)

duration=int(sys.argv[1])*3600
cap=cv2.VideoCapture(gstreamer_pipeline(flip_method=2), cv2.CAP_GSTREAMER)
counter=1
start_time=time.time()
while (int(time.time()-start_time)<duration):
    ret,frame=cap.read()
    if ret:
        cv2.imwrite('frame_'+str(counter)+'_'+str(datetime.now().strftime("%m-%d-%Y_%H-%M-%S"))+'.jpg',frame)
        counter+=1