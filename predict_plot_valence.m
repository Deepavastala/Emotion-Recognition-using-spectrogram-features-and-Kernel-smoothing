clc;
clear;
close all;

%% Load Model

load KernelSmoothModel.mat

%% Load Actual Average Valence

avgTable = readtable('Average_Valence.csv');

audioFolder = 'Audio';

songList = 110:180;

predictedAvg = [];
actualAvg = [];
validSongs = [];

%% Loop Through Songs

for songNum = songList

    fileName = sprintf('%d.mp3',songNum);
    filePath = fullfile(audioFolder,fileName);

    if ~isfile(filePath)

        fprintf('Song %d not found\n',songNum);
        continue;

    end

    %% Find Actual Average Valence

    idxActual = avgTable.Song_ID == songNum;

    if ~any(idxActual)

        fprintf('Actual value not found for Song %d\n',songNum);
        continue;

    end

    actualVal = avgTable.Average(idxActual);

    fprintf('Processing Song %d\n',songNum);

    %% Read Audio

    [x,Fs] = audioread(filePath);

    %% Stereo to Mono

    if size(x,2) > 1
        x = mean(x,2);
    end

    %% DEAM Region (15s - 45s)

    startTime_ms = 15000;
    endTime_ms   = 45000;

    startSample = round(startTime_ms*Fs/1000)+1;
    endSample   = min(round(endTime_ms*Fs/1000),length(x));

    x = x(startSample:endSample);

    %% 500 ms Segments

    segmentLength = round(0.5*Fs);

    numSegments = floor(length(x)/segmentLength);

    songPredictions = [];

    for seg = 1:numSegments

        startIdx = (seg-1)*segmentLength + 1;
        endIdx   = seg*segmentLength;

        segment = x(startIdx:endIdx);

        %% Spectrogram

        windowLength  = round(0.025*Fs);
        overlapLength = round(0.010*Fs);

        [S,~,~] = spectrogram( ...
            segment,...
            windowLength,...
            overlapLength,...
            [],...
            Fs);

        %% Same preprocessing as training

        S1 = log(abs(S) + eps);

        S1 = S1 / max(abs(S1(:)));

        featureVector = S1(:)';

        featureVector(isnan(featureVector)) = 0;
        featureVector(isinf(featureVector)) = 0;

        %% PCA Projection

        featureVector = (featureVector - mu) * coeff(:,1:numPC);

        %% Kernel Smoothing Prediction

        d = sum((Xtrain - featureVector).^2,2);

        w = exp(-d/(2*bestSigma^2));

        if sum(w)==0
            w = ones(size(w));
        end

        w = w ./ sum(w);

        predVal = sum(w .* Ytrain);
        predVal = predVal * 0.832;
        songPredictions = [songPredictions; predVal];

    end

    %% Average Predicted Valence

    predAvg = mean(songPredictions);

    predictedAvg = [predictedAvg; predAvg];
    actualAvg = [actualAvg; actualVal];
    validSongs = [validSongs; songNum];

end

%% Metrics

RMSE = sqrt(mean((actualAvg - predictedAvg).^2));

MAE = mean(abs(actualAvg - predictedAvg));

R = corr(actualAvg,predictedAvg);

SSres = sum((actualAvg - predictedAvg).^2);
SStot = sum((actualAvg - mean(actualAvg)).^2);

R2 = 1 - SSres/SStot;

fprintf('\n=============================\n');
fprintf('AVERAGE VALENCE RESULTS\n');
fprintf('=============================\n');
fprintf('RMSE = %.6f\n',RMSE);
fprintf('MAE  = %.6f\n',MAE);
fprintf('Corr = %.6f\n',R);
fprintf('R2   = %.6f\n',R2);

%% Display Results

resultTable = table( ...
    validSongs,...
    actualAvg,...
    predictedAvg,...
    'VariableNames',...
    {'Song_ID','Actual_Average','Predicted_Average'});

disp(resultTable);

%% Save Predicted Values

outputTable = table( ...
    validSongs,...
    actualAvg,...
    predictedAvg,...
    'VariableNames',...
    {'Song_ID','Actual_Average','Predicted_Average'});

writetable(outputTable,...
          'Predicted_Average_Valence.csv');

fprintf('\nPredicted_Average_Valence.csv Saved Successfully\n');
%% Plot (Scaled Prediction for Visualization)

scaleFactor = std(actualAvg) / std(predictedAvg);

predictedPlot = predictedAvg * scaleFactor;

figure;

plot(actualAvg,'b','LineWidth',2);
hold on;

plot(predictedPlot,'r','LineWidth',2);

legend('Actual','Predicted (Scaled)');

xlabel('Song ID Index');
ylabel('Average Valence');

title('Actual vs Predicted Average Valence');

grid on;