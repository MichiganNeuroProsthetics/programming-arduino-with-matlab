function [angle] = mapAngle(angles, values, val)
[~, index] = min(abs(values - val));
angle = angles(index);
end