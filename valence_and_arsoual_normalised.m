clc;
clear;
close all;

% Read CSV
T = readtable('valence.csv');

data = table2array(T);

% Keep first column unchanged
col1 = data(:,1);

% Remaining columns
X = data(:,2:end);

% Print before normalization
fprintf('Before Normalization:\n');
fprintf('Min = %f\n', min(X(:),[],'omitnan'));
fprintf('Max = %f\n', max(X(:),[],'omitnan'));

% Normalize exactly like S1=S1/max(max(abs(S1)))


Xnorm = X / max(max(abs(X(:))));

% Print after normalization
fprintf('\nAfter Normalization:\n');
fprintf('Min = %f\n', min(Xnorm(:),[],'omitnan'));
fprintf('Max = %f\n', max(Xnorm(:),[],'omitnan'));

% Combine back
finalData = [col1 Xnorm];

% Save
Tnorm = array2table(finalData,...
    'VariableNames',T.Properties.VariableNames);

writetable(Tnorm,'Normalized_File_Valence.csv');

fprintf('\nCSV Saved Successfully\n');