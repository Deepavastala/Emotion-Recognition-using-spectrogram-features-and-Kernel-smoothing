clc;
clear;
close all;

audioFolder = 'Audio';

finalData = [];

for songNum = 2:100

    fileName = sprintf('%d.mp3',songNum);
    filePath = fullfile(audioFolder,fileName);

    if ~isfile(filePath)
        continue;
    end

    fprintf('Processing %s\n',fileName);

    [x,Fs] = audioread(filePath);

    % Stereo to Mono
    if size(x,2) > 1
        x = mean(x,2);
    end

    % DEAM Region (15s - 45s)
    startTime_ms = 15000;
    endTime_ms   = 45000;

    startSample = round(startTime_ms*Fs/1000)+1;
    endSample   = min(round(endTime_ms*Fs/1000),length(x));

    x = x(startSample:endSample);

    % 500 ms Segments
    segmentLength = round(0.5*Fs);
    numSegments = floor(length(x)/segmentLength);

    for seg = 1:numSegments

        startIdx = (seg-1)*segmentLength + 1;
        endIdx   = seg*segmentLength;

        segment = x(startIdx:endIdx);

        % Spectrogram
        windowLength  = round(0.025*Fs);   % 25 ms
        overlapLength = round(0.010*Fs);   % 10 ms

        [S,~,~] = spectrogram( ...
            segment,...
            windowLength,...
            overlapLength,...
            [],...
            Fs);

        % Log Spectrogram + Normalization
        S1 = log(abs(S));

        S1 = S1 / max(max(abs(S1(:))));

        % Convert to row vector
        specValues = S1(:)';

        currentTime_ms = startTime_ms + (seg-1)*500;

        row = [songNum currentTime_ms specValues];

        finalData = [finalData; row];

    end

end

% Headers
numFeatures = size(finalData,2) - 2;

headers = cell(1,numFeatures+2);
headers{1} = 'Song_ID';
headers{2} = 'Time_ms';

for k = 1:numFeatures
    headers{k+2} = sprintf('Spec_%d',k);
end

% Save CSV
T = array2table(finalData,'VariableNames',headers);

writetable(T,'SpectrogramValues_no.csv');

fprintf('CSV Saved Successfully\n');
fprintf('Dataset Size = %d x %d\n',size(finalData,1),size(finalData,2));
fprintf('Features per Segment = %d\n',numFeatures);