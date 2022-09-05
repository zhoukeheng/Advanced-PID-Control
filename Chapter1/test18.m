%% Low pass filter with third order mode
clc; clear;close all;

ts = 0.001;
sys = tf(5.235e005, [1, 87.35, 1.047e004, 0]);
dsys = c2d(sys, ts, 'z');
[num, den] = tfdata(dsys, 'v');

u_1 = 0; u_2 = 0; u_3 = 0; u_4 = 0; u_5 = 0;
y_1 = 0; y_2 = 0; y_3 = 0;
yn_1 = 0;
error_1  =0; error_2 = 0;  ei = 0;

kp = 0.2; ki = 0.0; kd = 0.001;

Q = tf([1], [0.04, 1]);
Qz = c2d(Q, ts, 'tucsin');
[num1, den1] = tfdata(Qz, 'v');
f_1 = 0;


%%  Loop simulation

for k = 1:1:1000

    time(k) = k * ts;
    yd(k) = 20;  % Step signal
  
    % Linear model
    y(k) = -den(2) * y_1 - den(3) * y_2 - den(4) * y_3 + num(2) * u_1 + num(3) * u_2 + num(4) * u_3;

    n(k) = 5.0 * rand(1);
    yn(k) = y(k) + n(k);

    filted_y(k) = -den1(2) * f_1 + num1(1)*(yn(k) + yn_1);
    error(k) = yd(k) - filted_y(k);

    % I seperation
    if abs(error(k)) <=0.8
        ei = ei + error(k) * ts;
    else
        ei = 0;
    end

    % D calculation
    if (k ==1)
        ed = 0;
    else
        ed  = (error(k) - error_1) / ts;
    end
    ed_collect(k) = ed;
    u(k) = kp * error(k) + ki * ei + kd * ed;

    if (u(k) > 10)
        u(k) = 10;
    end
    if u(k) < -10
        u(k) = -10;
    end
    % Return of PID parameter
    yd_1 = yd(k);
    u_5 = u_4; u_4 = u_3; u_3 = u_2; u_2 =u_1; u_1 = u(k);
    y_3 = y_2; y_2 = y_1; y_1 = y(k);

    f_1 = filted_y(k);
    yn_1 = yn(k);

    error_2 = error_1;
    error_1 = error(k);

end


%% Plot
figure(1)
plot(time, yd, '-r');
hold on 
plot(time, filted_y, '-b' )

figure(2)
subplot(2,1,1)
plot(time, u)
subplot(2,1,2)
plot(time, ed_collect)
