%%
clc; clear; close all;

%%

h = 0.001;

beta1 = 20; beta2 = 1.0;
kp = beta1; kd = beta2;

alfa1 = 0.75; alfa2 = 1.5;
delta = 2 * h;

xk = zeros(2, 1);
u_1 = 0;
num = 1000;

r1_error = zeros(1, num);
r2_error = zeros(1, num);
% r1_error(1) = 1;
r_error = 300;

for i = 1 : num
    time(i) = i * h;

    p1 = u_1;
    p2 = time(i);

    tspan = [0 h];
    [t, x] = ode45('second_order_model', tspan, xk, [], p1, p2);
    xk = x(end, :);
    
    y(i) = xk(1);
    dy(i) = xk(2);
    yd(i) = 1.0;
    dyd(i) = 0;

    e1(i) = yd(i) - y(i);
    e2(i) = dyd(i) - dy(i);
    
    if i ~= 1
         r1_error(i) = r1_error(i - 1) + h * r2_error(i - 1);
         r2_error(i) = r2_error(i - 1) + h * (- r_error * r_error  * (r1_error(i) - y(i)) - 2 * r_error * r2_error(i - 1));
    end 
%     e2(i) = dyd(i) - r2_error(i);

    M = 1;
    if M == 1
        u(i) = kp * fal(e1(i), alfa1, delta) + kd * fal(e2(i), alfa2, delta);
        kd_val(i) = kd * fal(e2(i), alfa2, delta);
        kp_val(i) = kp * fal(e1(i), alfa1, delta);
    end

    u_1 = u(i);
end

%% Plot

figure(1)
subplot(211);
plot(time, yd, '-r')
hold on; grid on;
plot(time, y, '-b')

subplot(212)
plot(time, kd_val);

figure(2)
plot(time, -dy, '-r');
hold on
plot(time, -r2_error, '-b');