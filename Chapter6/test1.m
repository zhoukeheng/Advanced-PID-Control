%%

clc; clear; close all;

%%

h = 0.05;
delta = 100;
r1_1 = 0;
r2_1 = 0;
vn_1 = 0;
num = 300;

for k = 1:1:num
    time(k) = k * h;
    v(k) = sin(2 * pi * k * h);
    n(k) = 0.05 * rands(1);
    vn(k) = v(k) + n(k);
    dv(k) = 2 * pi * cos(2 * pi * k * h);
    
    r1(k) = r1_1 + h * r2_1;
    r2(k) = r2_1 + h * fst(r1_1 - v(k), r2_1, delta, h);
    
    dvn_k = (vn(k) - vn_1) / h;
    vn_1 = vn(k);

    r1_1 = r1(k);
    r2_1 = r2(k);
end

%% Plot

figure(1)
plot(time, vn)
hold on; grid on;
plot(time, r1);
legend("Initial", "TD")

figure(2)
plot(time, r2)

