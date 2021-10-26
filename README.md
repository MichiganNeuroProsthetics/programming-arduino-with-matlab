# programming-arduino-with-matlab
Matlab programs that can give and collect data as well as give commands to an arduino board

voltGraph receives voltage data and graphs it. It also turns an LED light on if a voltage threshold is crossed
    
voltGraphTime is an updated version of voltGraph that has added features such as:
    
   -graphing data over time (instead of over data indices)
   
   -recording data at an essentially constant rate 
   
   -assessing computer-arduino communication speed in order to recommend a delay in each loop iteration to achieve consistently a given loop iteration time

timeAdjust is a support function for voltGraphTime

emgSensorGraph takes data from an emg sensor and graphs it. It also creates a 3D representation of a wrist and depicts the motion of that wrist based on the emg data

mapAngle is a support function for emgSensorGraph
    
The MATLAB support package for arduino hardware is required to run these programs
