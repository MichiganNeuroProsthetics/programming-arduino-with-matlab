clear;
close all;

%% Create arduino object
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
threshold = 3;
x = 0;

% this plots the median of 10 consecutive voltage values to reduce error
v_vect = [0 0 0 0 0 0 0 0 0 0];
while (get(stop_button,'value') == 0)
    for i = 1:10
        v_vect(i) = (readVoltage(a, pot_pin) / 1.024);
    end
    t = median(v_vect);
    x = [x, t];
    set(volt_label, 'String', ['Volts: ' num2str(t) ' V']);
    if threshold < t
        writeDigitalPin(a, led_pin, 1);
    elseif threshold > t
        writeDigitalPin(a, led_pin, 0);
    end

%% Plot data
plot(x, 'k');
hold on
grid on
ylabel('Voltage (V)');
xlabel('Time');
plot(threshold .* ones(length(x)), 'r--');
end
