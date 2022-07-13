%% Low pass filter

clc; clear; close all;

ts = 0.05;
Q = tf([1], [0.1, 1]);
Qz = c2d(Q, ts, 'tucsin');
[num, den] = tfdata(Qz, 'v');


y_1 = 0; y_2 = 0;
yd_1 = 0; yd_2 = 0;
n = 500;

for k = 1:n
    time(k) = k * ts;
    n(k) = 0.1 * rand(1);
    yd(k) = n(k) + 0.5 * sin(0.2 * 2 * pi * k * ts);
    y(k) = -den(2) * y_1 + num(1) * yd(k) + num(2) * yd_1;

    y_2 = y_1; y_1 = y(k);
    yd_2 = yd_1; yd_1 = yd(k);
end

error = sum(abs(y - yd)) / length(y);
error_percentage = error / 0.5 * 100 ;
%% Plot

figure(1)
plot(time, yd);
hold on; grid on;
plot(time, y,'-r');
figure(2)
plot(time, y);