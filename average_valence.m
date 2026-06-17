clc;
clear;
close all;

T = readtable('valence.csv');

songID = T{:,1};

X = T{:,2:end};

rowAverage = mean(X,2,'omitnan');

OutputTable = table(songID,rowAverage,...
    'VariableNames',{'Song_ID','Average'});

writetable(OutputTable,'Average_Valence.csv');

fprintf('Average_Valence.csv saved successfully\n');