clc;
clear;
close all;

%% Load Files

specTable = readtable('SpectrogramValues_normalized.csv');
aroTable  = readtable('Normalized_File_arousal.csv');

%% Initialize Target Vector

Y = NaN(height(specTable),1);

%% Build Target Vector

for i = 1:height(specTable)

    songID = specTable.Song_ID(i);
    timeMS = specTable.Time_ms(i);

    rowIdx = find(aroTable.song_id == songID);

    colName = sprintf('sample_%dms',timeMS);

    if ~isempty(rowIdx) && ...
       ismember(colName,aroTable.Properties.VariableNames)

        Y(i) = aroTable{rowIdx,colName};

    end

end

%% Save MAT File

TargetVector = Y;

save('TargetVector_arousal.mat','TargetVector');

%% Save CSV

TargetTable = table(TargetVector,...
    'VariableNames',{'Arousal'});

writetable(TargetTable,...
          'TargetVector_arousal.csv');

%% Display Information

fprintf('\n=================================\n');
fprintf('Target Vector Created\n');
fprintf('=================================\n');

fprintf('Target Size = %d x %d\n',...
        size(TargetVector,1),...
        size(TargetVector,2));

fprintf('NaNs = %d\n',...
        sum(isnan(TargetVector)));

fprintf('Min = %.6f\n',...
        min(TargetVector(~isnan(TargetVector))));

fprintf('Max = %.6f\n',...
        max(TargetVector(~isnan(TargetVector))));

fprintf('Mean = %.6f\n',...
        mean(TargetVector(~isnan(TargetVector))));

fprintf('\nTargetVector_arousal.mat Saved\n');
fprintf('TargetVector_arousal.csv Saved\n');