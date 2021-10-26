function [rec_pause_time] = timeAdjust(time_vec, goal_iter_time, used_pause_time)
% This function takes a vector of time values, a goal iteration time, and
% the amount of time paused during each loop iteration. It calculates the
% time for each iteration of the loop using the time data, and finds a
% recommended value for a pause during each loop iteration in order to
% achieve the goal iteration time


time_vec_length = length(time_vec);
iter_time = zeros(time_vec_length - 1,1);

%% Calculate time for each iteration
for i = 1:(time_vec_length - 1)
    iter_time(i) = time_vec(i+1) - time_vec(i);
end

%% Find difference between goal iteration time and average experimental iteration time
avg_iter_step = mean(iter_time);
iter_dif = goal_iter_time - avg_iter_step;

%% Recommend change in pause_time to achieve goal iteration time
rec_pause_time = used_pause_time + iter_dif;

end