%%
% The system is 523500 / (s^3 + 87.35s^2 + 10470s)
clc; clear; close all;
addpath("C:\Users\Administrator\Desktop\Study\Advanced PID control\Chapter6")
%%

ts = 0.001;
sys = tf (5.235e005, [1, 87.35, 10470, 0]);
dsys = c2d(sys, ts, 'z');
[num, den] = tfdata(dsys, 'v');

u_1 = 0.0; u_2 = 0.0; u_3 = 0.0;
y_1 = 0.0; y_2 = 0.0; y_3 = 0.0;

x = [0;0;0]';
error_1 = 0;
n = 500;
S = 1;

r1 = zeros(1, n);
r2 = zeros(1, n);
r_t1 =  zeros(1, n);
r_t2 =  zeros(1, n);
r = 100;
delta = 40;

for i = 1:n
    time(i) = i * ts;

    if S == 1
        kp = 0.48;
        ki = 0.001;
        kd = 0.0055;
        yd(i) = 1 + 0.01 * rand(1);

    elseif S == 2
        kp = 0.5;
        ki = 0.001;
        kd = 0.01;
        yd(i) = sign(sin(2 * 2 * pi * i * ts));
    elseif S == 3
        kp = 1.5;
        ki = 1.0;
        kd = 0.01;
        yd(i) = 0.5 * sin(2 * 2 * pi * i * ts);
    end
    
    if i ~= 1
         r1(i) = r1(i - 1) + ts * r2(i - 1);
         r2(i) = r2(i - 1) + ts * (- r * r * (r1(i) - y(i - 1)) - 2 * r * r2(i - 1));
         r_t1(i) = r_t1(i - 1) + ts * r_t2(i - 1);
         r_t2(i) = r_t2(i - 1) + ts * (- r * r * (r_t1(i) - yd(i - 1)) - 2 * r * r_t2(i - 1));

%     r1(i) = r1(i - 1) + ts * r2(i - 1);
%     r2(i) = r2(i - 1) + ts * fst(r1(i - 1) - error_1, r2(i - 1), delta, ts);
    end

    u(i) = kp * (r_t1(i) - r1(i)) + kd * (r_t2(i) - r2(i)) + ki * x(3);
%     u(i) = kp * x(1) + kd * x(2) + ki * x(3);
    if u(i) >= 10
        u(i) = 10;
    end

    if u(i) <= -10
        u(i) = -10;
    end
    
    % Linear model
    y(i) = -den(2) * y_1 - den(3) * y_2 - den(4) * y_3 + num(2) * u_1 + num(3) * u_2 + num(4) * u_3;
    y(i) = y(i);
    error(i) = yd(i) - y(i);

    % Return of parameter
    u_3 = u_2; u_2 = u_1; u_1 = u(i);
    y_3 = y_2; y_2 = y_1; y_1 = y(i);

    x(1) = error(i);
    x(2) = (error(i) - error_1) / ts;
    %x(3) = x(3) + error(i) * ts;

    error_1 = error(i);
end


%% Plot

figure(1)
plot(time, yd, '-r', 'LineWidth', 2)
hold on; grid on;
plot(time, y, '-b', 'LineWidth', 2)

figure(2)
plot(time, y, '-r', 'LineWidth', 2);
hold on; grid on;
plot(time, r1, '-b', 'LineWidth', 2);

figure(3)
plot(time, yd, '-r', 'LineWidth', 2)
hold on; grid on;
plot(time, r_t1, '-b', 'LineWidth', 2)