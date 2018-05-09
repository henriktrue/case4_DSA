%% Målinger DSE opgave
%  Henrik Truelsen, Viggo Lysdahl, Simon Mylius 03/05-2018

%% Generelt setup:
clear; close all; clc; format compact

%% Indlæsning af data til step respons
sig1=csvread('data/data.csv');

time_S=sig1(:, 1);
RED_S=sig1(:, 2);
IR_S= sig1(:, 3);
% udregning af variable
Ts = time_S(2)-time_S(1);
fs = 1/Ts; %800 hertz
N = 8192;
Tdur = N/fs;
n = (1:N);


%% 1. midlingsfilter
% rødt signal
M_S_R = 40;                           % filterkoefficienter
hMA_R_S = 1/M_S_R*ones(1,M_S_R);          % MA-filter, filterkoefficienter
yMA_R_S = filter(hMA_R_S,1,RED_S);      % filtrerer inputsignal

% IR signal
M_S_IR = 3;                           % filterkoefficienter
hMA_IR_S = 1/M_S_IR*ones(1,M_S_IR);          % MA-filter, filterkoefficienter
yMA_IR_S = filter(hMA_IR_S,1,IR_S);      % filtrerer inputsignal

c = zeros(1,N);

for i = 1:512
    c((i*16-15):(16*i)) = ones(1,16) * max(yMA_IR_S(16*i-5:16*i));
end

% IR signal
M_S_IR_filtreret = 300;                          % filterkoefficienter
hMA_IR_S_filtreret = 1/M_S_IR_filtreret*ones(1,M_S_IR_filtreret);          % MA-filter, filterkoefficienter
yMA_IR_S_filtreret = filter(hMA_IR_S_filtreret,1,c);      % filtrerer inputsignal

puls = 0;
p_x = [];
for i = (M_S_IR_filtreret/8)+1:(N/8)
    if (yMA_IR_S_filtreret(i*8) >= yMA_IR_S_filtreret((i*8)-1)) && (yMA_IR_S_filtreret(i*8) >= yMA_IR_S_filtreret((i*8)+1))
        puls = puls + 1;
        p_x = ([p_x,i*8]);
    end
end

pulsfr=(60/((p_x(length(p_x))-p_x(2))/800))*puls;

%% plotning af signaler

figure
plot(time_S, IR_S, 'b'), grid, hold on
plot(time_S, RED_S, 'r'), grid;
xlabel('Tid/s'), ylabel('Spænding/V'), title('Rådata');
xlim([-5 5]), ylim([0 0.5]);
legend('IR respons', 'Rød pære respons');

figure
plot(n,RED_S), grid, hold on
plot(n,IR_S), grid, hold on
plot(n,yMA_R_S), grid, hold on
plot(n,yMA_IR_S), grid, hold on
xlabel('Samples'), ylabel('Spænding/V'), title('Rådata og 1. midlingsfilter');
legend('Rå rødt signal','Rå IR signal', ['Filtreret rødt ' ...
                    'signal'],'Filtreret IR signal');

figure
subplot(2,1,1)
plot(n,c), grid, hold on
ylim([-0.05 0.3]);
xlabel('Samples'), ylabel('Spænding/V'), title('Afgrænset spændingsvariation');

subplot(2,1,2)
hold on
plot(n,c, 'g','LineWidth', 4), grid, hold on
plot(n,yMA_R_S,'b'), grid, hold on
plot(n,yMA_IR_S,'r'), grid, hold on
xlabel('Samples'), ylabel('Spænding/V'), title(['Afgrænset ' ...
                    'spændingsvariation med filtrerede signaler']);
legend('Afgrænset spændingsvariation','Filtreret rødt signal','Filtreret IR signal');



figure
subplot(2,1,1)
plot(n,yMA_R_S), grid, hold on
plot(n,yMA_IR_S_filtreret),grid,hold on;
xlabel('Samples'), ylabel('Spænding/V'), title(['Midlingsfiltreret afgrænset ' ...
                    'spændingsvariation']);
legend('Filtreret rødt signal','Filtreret afgrænset spændingsvariation af IR signal');

subplot(2,1,2)
plot(n,c), grid, hold on
plot(n,yMA_R_S), grid, hold on
plot(n,yMA_IR_S_filtreret,'g','LineWidth', 2),grid,hold on;
xlabel('Samples'), ylabel('Spænding/V'), title(['Filtreret afgrænset ' ...
                    'spændingsvariation']);
legend('Afgrænset spændingsvariation',['Filtreret rødt signal'],['Filtreret ' ...
                    'afgrænset spændingsvariation af IR signal']);


% figure
% subplot(1,2,1:2)
% plot(n,RED_S), grid, hold on
% plot(n,yMA_R_S), grid, hold on
% plot(n,IR_S), grid, hold on
% plot(n,yMA_IR_S), grid, hold on
% plot(n,c, 'r'), grid, hold on
% plot(n,yMA_IR_S_filtreret, 'g');
% lgd = legend('original rød pære respons', 'filtreret rød pære respons', 'original IR respons', '3 koefficienters IR filter', 'højeste værdi af hvert 32 sample hertil', '280 koefficienters filter på max værdi af hvert 32 sample');
% title(lgd,'akser');
% xlim([0 N]);
% title('Simons filter respons');
% xlabel('samples'), ylabel('volt');
