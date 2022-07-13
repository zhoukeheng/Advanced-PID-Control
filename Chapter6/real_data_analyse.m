%%
clc; clear; close all;

addpath("C:\Users\Administrator\Desktop\test\acf_data_collection")

%%

data = load("actual_vel_56.csv");
expect_vel = load("expect_vel_56.csv");
error_list = expect_vel - data;

len = length(data);
h = 0.05;
delta = 40;
r1 = zeros(1, len);
r2 = zeros(1, len);
time = zeros(1, len);

r1_linear = zeros(1, len);
r2_linear = zeros(1, len);
r = 8;

r1_error = zeros(1, len);
r2_error = zeros(1, len);
r_error = 11;

for i = 2 :len
    r1(i) = r1(i - 1) + h * r2(i - 1);
    r2(i) = r2(i - 1) + h * fst(r1(i - 1) - data(i), r2(i - 1), delta, h);

    r1_linear(i) = r1_linear(i - 1) + h * r2_linear(i - 1);
    r2_linear(i) = r2_linear(i - 1) + h * (- r * r  * (r1_linear(i) - data(i)) - 2 * r * r2_linear(i - 1));
    
    r1_error(i) = r1_error(i - 1) + h * r2_error(i - 1);
    r2_error(i) = r2_error(i - 1) + h * (- r_error * r_error  * (r1_error(i) - error_list(i)) - 2 * r_error * r2_error(i - 1));
    time(i) = h * (i - 1);
end


error = sum(abs(r1 - data)) / len;
error_linear = sum(abs(r1_linear - data)) / len;
error_diff = sum(abs(error_list(10:50) - r1_error(10:50))) / 40;
error_record = error_list - r1_error;
%% Plot

figure(1)
plot(time, data, '-r');
hold on; grid on;
plot(time, r2, '-b');
legend("Initial data", "Filted data");


figure(2)
plot(time, data, '-r');
hold on; grid on;
plot(time, r2_linear, '-b');
legend("Initial data", "Filted data");

% figure(3)
% plot(time, error_list, '-r')
% hold on; grid on;
% plot(time, r2_error, '-b')
% legend("Initial error", "Filted error");

figure(4)
plot(time, r2_linear, '-r');
hold on; grid on;
plot(time, r2, '-b');
legend("Linear data", "Optimal data");
