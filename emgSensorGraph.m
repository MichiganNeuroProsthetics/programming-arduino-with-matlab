clear
close all
a = arduino();
emg_pin = "A0";

%% Set up figure 1
f1 = figure('Position',[50 50 500 500]);

% create stop button on figure 1
if ~exist('stop_button','var')
    stop_button = uicontrol('Style','togglebutton', 'String', 'Stop','position',[0 0 200 25], 'Parent', f1);
end

% create angle value label on figure 1
if ~exist("angle_label",'var')
    angle_label = uicontrol('Style','text','String','Angle: 0','Position', [300 20 100 25],'Parent',f1);
end

myaxes = axes('XLim', [-2, 2], 'YLim', [-2, 2], 'ZLim', [-2, 2]);
view(3);

xlabel('x');
ylabel('y');
zlabel('z');
axis equal

% create cylinder, sphere, and cone
[cylX, cylY, cylZ] = cylinder(0.7);
cylZ = cylZ .* 5;

[sphX, sphY, sphZ] = sphere();

[conX, conY, conZ] = cylinder([0.7, 0]);

% combine shapes into a single array
shapeArray(1) = surface(cylZ, cylX, cylY);
shapeArray(2) = surface(sphX - 0.6, sphY, sphZ);
shapeArray(3) = surface(conZ + 5, conX, conY);

hgTransform = hgtransform('Parent', myaxes);
set(shapeArray, 'Parent', hgTransform);

drawnow;
pause(0.25);

%% Create thresholds, angles, and corresponding sensor values
thresholds = [0, 1/6, 1/3, 0.5, 2/3, 5/6, 1];
angle1 = linspace(0, 18, 50);
value1 = linspace(thresholds(1), thresholds(2), 50);
angle2 = linspace(18, 36, 50);
value2 = linspace(thresholds(2), thresholds(3), 50);
angle3 = linspace(36, 54, 50);
value3 = linspace(thresholds(3), thresholds(4), 50);
angle4 = linspace(54, 72, 50);
value4 = linspace(thresholds(4), thresholds(5), 50);
angle5 = linspace(72, 90, 50);
value5 = linspace(thresholds(5), thresholds(6), 50);


%% Set up figure 2
f2 = figure('Position', [600 50 600 600]);
grid on
title('Signal from EMG Sensor');
xlabel('Sensor Input');
ylabel('Voltage');

angleX = 0;
angleY = 0;
angleZ = 0;
x = 0;

% this plots the median of 10 consecutive emg input values to reduce error
val_vect = [0 0 0 0 0 0 0 0 0 0];

%% Collect and display data
while (get(stop_button,'value') == 0)
    for i = 1:10
        val_vect(i) = readVoltage(a, emg_pin) / 5.12;
    end
    val = median(val_vect);

    %This following section finds the angle based on the emg input val
    if 0 <= val && val <= thresholds(1)
        angle = 0;
    elseif thresholds(1) <= val && val <= thresholds(2)
        angle = mapAngle(angle1, value1, val);
    elseif thresholds(2) <= val && val <= thresholds(3)
        angle = mapAngle(angle2, value2, val);
    elseif thresholds(3) <= val && val <= thresholds(4)
        angle = mapAngle(angle3, value3, val);
    elseif thresholds(4) <= val && val <= thresholds(5)
        angle = mapAngle(angle4, value4, val);
    elseif thresholds(5) <= val && val <= thresholds(6)
        angle = mapAngle(angle5, value5, val);
    else
        angle = 90;
    end
    
    figure(2);
    x = [x, val];
    plot(x);

    figure(1);
    set(angle_label, 'String', ['Angle: ' num2str(round(angle))]);
    R = makehgtform('yrotate', (angle .* pi ./ 180));
    set(hgTransform, 'Matrix', R);

    drawnow;
end
