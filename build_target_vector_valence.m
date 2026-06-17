% build_target_vector_arousal.m

clc;
clear;
close all;

specTable = readtable('SpectrogramValues_normalized.csv');
valTable  = readtable('Normalized_File_Valence.csv');

Y = [];

for i = 1:height(specTable)

    songID = specTable.Song_ID(i);
    timeMS = specTable.Time_ms(i);

    rowIdx = find(valTable.song_id == songID);

    colName = sprintf('sample_%dms',timeMS);

    if ~isempty(rowIdx) && ismember(colName,valTable.Properties.VariableNames)

        val = valTable{rowIdx,colName};

        Y = [Y; val];

    else

        Y = [Y; NaN];

    end

end

TargetVector = Y;

save('TargetVector.mat','TargetVector');

fprintf('Target Size = %d x %d\n',...
        size(TargetVector,1),...
        size(TargetVector,2));

fprintf('NaNs = %d\n',...
        sum(isnan(TargetVector)));

TargetTable = table(TargetVector,...
    'VariableNames',{'Arousal'});

writetable(TargetTable,...
          'TargetVector.csv');

fprintf('Target Size = %d x %d\n',...
        size(TargetVector,1),...
        size(TargetVector,2));

fprintf('NaNs = %d\n',...
        sum(isnan(TargetVector)));

fprintf('TargetVector.csv Saved Successfully\n');