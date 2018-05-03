%% Målinger DSE opgave
%  Henrik Truelsen, Viggo Lysdahl, Simon Mylius 03/05-2018

%% Generelt setup:
clear; close all; clc; format compact

%% Indlæsning af data til step respons
sig2=csvread('data/IR_Henrik.csv');
sig1=csvread('data/Simon.csv');

%signal 1
time_S=sig1(:, 1);
RED_S=sig1(:, 2);
IR_S= sig1(:, 3);

%signal 2
time_H=sig2(:, 1);
IR_H= sig2(:, 2);

% udregning af variabler
Ts = time_S(2)-time_S(1);
fs = 1/Ts; %800 hertz
N = 8192;
Tdur = N/fs;

%% plot af målinger uredigeret
figure
subplot(2,2,1:2)
plot(time_S, IR_S, 'b'), grid, hold on
plot(time_S, RED_S, 'r'), grid;
xlabel('tid i s'), ylabel('volt'), title('Simons uredigerede målinger');
xlim([-5 5]), ylim([0 0.5]);
lgd = legend('IR respons', 'Rød pære respons');
title(lgd,'akser');

subplot(2,2,3:4)
plot(time_H, IR_H, 'b'), grid, hold on
%plot(time_H, RED_S, 'r'), grid;
xlabel('tid i s'), ylabel('volt'), title('Henriks uredigerede målinger');
xlim([-5 5]), ylim([0 0.5]);
lgd = legend('IR respons');
title(lgd,'akser');

%% filtrering af signaler
