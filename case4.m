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
n = (1:N);

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

%% filtrering af Simons målinger
% rød lampesignal
M_S_R = 40;                           % filterkoefficienter
hMA_R_S = 1/M_S_R*ones(1,M_S_R);          % MA-filter, filterkoefficienter
yMA_R_S = filter(hMA_R_S,1,RED_S);      % filtrerer inputsignal for Simons del

% IR lampesignal
M_S_IR = 3;                           % filterkoefficienter
hMA_IR_S = 1/M_S_IR*ones(1,M_S_IR);          % MA-filter, filterkoefficienter
yMA_IR_S = filter(hMA_IR_S,1,IR_S);      % filtrerer inputsignal for Simons del

c = zeros(1,N);

for i = 1:512
    c((i*16-15):(16*i)) = ones(1,16) * max(yMA_IR_S(16*i-5:16*i));
end

% IR lampesignal
M_S_IR_filtreret = 280;                           % filterkoefficienter
hMA_IR_S_filtreret = 1/M_S_IR_filtreret*ones(1,M_S_IR_filtreret);          % MA-filter, filterkoefficienter
yMA_IR_S_filtreret = filter(hMA_IR_S_filtreret,1,c);      % filtrerer inputsignal for Simons del

%for c = 1:N-2
    %if (yMA_IR_S[c]>yMA_IR_S[c-1]) && (yMA_IR_S[c]<yMA_IR_S[c+1])
        
    %end
%end


%% plotning af signal efter pålagt filter
figure

subplot(2,3,1:2)
plot(time_S,RED_S), grid, hold on
plot(time_S,yMA_R_S), grid, hold on
plot(time_S,IR_S), grid, hold on
plot(time_S,yMA_IR_S), grid, hold on
plot(time_S,c, 'r'), grid, hold on
plot(time_S,yMA_IR_S_filtreret, 'g');
lgd = legend('original rød pære respons', 'filtreret rød pære respons', 'original IR respons', '3 koefficienters IR filter', 'højeste værdi af hvert 32 sample hertil', '280 koefficienters filter på max værdi af hvert 32 sample');
title(lgd,'akser');
xlim([-5 5]);
title('Simons filter respons');
xlabel('sekunder'), ylabel('volt');