clc;
clear;
close all;

%% Load Predicted Valence

valTable = readtable('Predicted_Average_Valence.csv');

%% Load Predicted Arousal

aruTable = readtable('Predicted_Average_Arousal.csv');

%% Extract Data

songID  = valTable.Song_ID;

valence = valTable.Predicted_Average;
arousal = aruTable.Predicted_Average;

%% Mood Centroids

Happy   = [ 0.5  0.5];
Angry   = [-0.5  0.5];
Sad     = [-0.5 -0.5];
Relaxed = [ 0.5 -0.5];

Mood = strings(length(songID),1);

%% Euclidean Distance Classification

for i = 1:length(songID)

    V = valence(i);
    A = arousal(i);

    dHappy = sqrt((V-Happy(1))^2 + (A-Happy(2))^2);

    dAngry = sqrt((V-Angry(1))^2 + (A-Angry(2))^2);

    dSad = sqrt((V-Sad(1))^2 + (A-Sad(2))^2);

    dRelaxed = sqrt((V-Relaxed(1))^2 + (A-Relaxed(2))^2);

    distances = [dHappy dAngry dSad dRelaxed];

    [~,idx] = min(distances);

    switch idx

        case 1
            Mood(i) = "Happy";

        case 2
            Mood(i) = "Angry";

        case 3
            Mood(i) = "Sad";

        case 4
            Mood(i) = "Relaxed";

    end

end

%% Result Table

ResultTable = table( ...
    songID,...
    valence,...
    arousal,...
    Mood,...
    'VariableNames',...
    {'Song_ID',...
     'Valence',...
     'Arousal',...
     'Mood'});

disp(ResultTable);

%% Save CSV

writetable(ResultTable,...
          'Song_Mood_Classification_Euclidean.csv');

fprintf('\nSong_Mood_Classification_Euclidean.csv Saved Successfully\n');

%% Plot

figure;

gscatter(valence,...
         arousal,...
         Mood);

hold on;

plot(0.5,0.5,'kp','MarkerSize',15,'LineWidth',2);
plot(-0.5,0.5,'kp','MarkerSize',15,'LineWidth',2);
plot(-0.5,-0.5,'kp','MarkerSize',15,'LineWidth',2);
plot(0.5,-0.5,'kp','MarkerSize',15,'LineWidth',2);

text(0.5,0.5,' Happy');
text(-0.5,0.5,' Angry');
text(-0.5,-0.5,' Sad');
text(0.5,-0.5,' Relaxed');

xlabel('Valence');
ylabel('Arousal');

title('Mood Classification using Euclidean Distance');

grid on;