clear;
close all;
%%  ReadME
    %This script collects and graphs volage data over time. Before actually
    %using this code to collect data, decide on values for:
        %your voltage threshold "threshold"
        %the amount of time you want the script to record data "time_record" 
        %the amount of time between each data point "goal_iter_time"
    %Run the script once before collecting data so that the script can use
        %timeAdjust to calculate "rec_pause_time". This value represents 
        %what you should enter for "pause_time", which is the delay for  
        %each loop iteration so that your goal iteration time is met
    %if "rec_pause_time" is negative, your computer and arduino do not
        %communicate fast enough for you to have that iteration loop speed

%% Create arduino object and assign pins
a = arduino();
led_pin = 'D2';
pot_pin = 'A0';

%% Set up figure
f1 = figure('Position',[300 100 800 400]);

% create stop button on figure 1
if ~exist('stop_button','var')
    stop_button = uicontrol('Style','togglebutton', 'String', 'Stop','position',[0 0 200 25], 'Parent', f1);
end

% create voltage value label on figure 1
if ~exist("volt_label",'var')
    volt_label = uicontrol('Style','text','String','Volts: 0 V','Position', [450 100 250 25],'Parent',f1);
end

%% Collect data
%Initialize variables
threshold = 3;
time_record = 30;
goal_iter_time = 0.5;
pause_time = 0.1877;   %An optimal pause_time value is calculated each time
                       %the script runs. You must manually enter it
volt_data = zeros(ceil(time_record / goal_iter_time),1);
time_data = [0; time_record .* ones(length(volt_data) - 1,1)];
index = 0;
volt_vect = [0 0 0 0 0 0 0 0 0 0]; %Collected in a vector to remove noise
tic                                %Starts MATLAB time recording

while (get(stop_button,'value') == 0 && volt_data(end) == 0)
    pause(pause_time);
    for i = 1:10
        volt_vect(i) = (readVoltage(a, pot_pin) / 1.024);
    end

    volt_val = median(volt_vect);
    index = index + 1;
    volt_data(index) = volt_val;
    set(volt_label, 'String', ['Volts: ' num2str(volt_val) ' V']);
    
    % Turn light on if voltage is above threshold
    if threshold <= volt_val
        writeDigitalPin(a, led_pin, 1);
    elseif threshold > volt_val
        writeDigitalPin(a, led_pin, 0);
    end

    %% Plot data
    plot(time_data, volt_data, 'k');
    hold on
    grid on
    ylabel('Voltage (V)');
    xlabel('Time (s)');
    plot(threshold .* ones(length(time_record)), 'r--');
    hold off
    time_data(index + 1) = toc; %record time value for next data point
end

time_data = time_data(1:(end - 1)); %remove last time data point
rec_pause_time = timeAdjust(time_data, goal_iter_time, pause_time);
% You must manually replace "pause_time" with the value of "rec_pause_time"
% in order to have the goal iteration time be achieved

data_vector = [time_data,volt_data];
