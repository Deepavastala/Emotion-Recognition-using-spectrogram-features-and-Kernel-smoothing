clc;
clear;
close all;

T = readtable('arousal.csv');

songID = T{:,1};

X = T{:,2:end};

rowAverage = mean(X,2,'omitnan');

OutputTable = table(songID,rowAverage,...
    'VariableNames',{'Song_ID','Average'});

writetable(OutputTable,'Average_Arousal.csv');

fprintf('Average_arousal.csv saved successfully\n');