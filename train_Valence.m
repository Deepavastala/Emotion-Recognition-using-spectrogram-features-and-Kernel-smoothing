clc;
clear;
close all;

%% Load Features

Xtable = readtable('SpectrogramValues_normalized.csv');

X = table2array(Xtable(:,3:end));

%% Remove NaNs from Features

X(isnan(X)) = 0;
X(isinf(X)) = 0;

%% Load Targets

load TargetVector.mat

Y = TargetVector;

%% Remove NaN Targets

validRows = ~isnan(Y);

X = X(validRows,:);
Y = Y(validRows);

fprintf('Loaded: %d samples x %d features\n', ...
        size(X,1),size(X,2));

fprintf('Y Range: [%f , %f]\n', ...
        min(Y),max(Y));

fprintf('NaNs in X = %d\n',sum(isnan(X(:))));
fprintf('NaNs in Y = %d\n',sum(isnan(Y(:))));

%% PCA

[coeff,score,~,~,explained,mu] = pca(X);

cumVar = cumsum(explained);

numPC = find(cumVar >= 95,1);

X = score(:,1:numPC);

fprintf('\nPCA Components = %d\n',numPC);
fprintf('Variance = %.2f %%\n',cumVar(numPC));

%% Train-Test Split

rng(1);

N = size(X,1);

idx = randperm(N);

nTrain = round(0.7*N);

trainIdx = idx(1:nTrain);
testIdx  = idx(nTrain+1:end);

Xtrain = X(trainIdx,:);
Ytrain = Y(trainIdx);

Xtest = X(testIdx,:);
Ytest = Y(testIdx);

fprintf('\nTrain = %d\n',length(trainIdx));
fprintf('Test  = %d\n',length(testIdx));

%% Sigma Search

sigmaList = [0.1:0.1:1.2, 2:10, 11:10:99, 100:100:1000];

bestRMSE = inf;
bestSigma = sigmaList(1);

fprintf('\n=====================================\n');
fprintf('Testing Sigma Values\n');
fprintf('=====================================\n');

for s = 1:length(sigmaList)

    sigma = sigmaList(s);

    Ypred = zeros(length(Ytest),1);

    for i = 1:length(Ytest)

        d = sum((Xtrain - Xtest(i,:)).^2,2);

        w = exp(-d/(2*sigma^2));

        if sum(w)==0
            w = ones(size(w));
        end

        w = w ./ sum(w);

        Ypred(i) = sum(w .* Ytrain);

    end

    RMSE = sqrt(mean((Ytest-Ypred).^2));

    fprintf('Sigma = %-8g   RMSE = %.6f\n', ...
            sigma,RMSE);

    if RMSE < bestRMSE

        bestRMSE = RMSE;
        bestSigma = sigma;

    end

end

fprintf('\n=====================================\n');
fprintf('Best Sigma = %.4f\n',bestSigma);
fprintf('Best RMSE  = %.6f\n',bestRMSE);
fprintf('=====================================\n');

%% Final Prediction Using Best Sigma

sigma = bestSigma;

Ypred = zeros(length(Ytest),1);

for i = 1:length(Ytest)

    d = sum((Xtrain - Xtest(i,:)).^2,2);

    w = exp(-d/(2*sigma^2));

    if sum(w)==0
        w = ones(size(w));
    end

    w = w ./ sum(w);

    Ypred(i) = sum(w .* Ytrain);

end

%% Metrics

RMSE = sqrt(mean((Ytest-Ypred).^2));

MAE = mean(abs(Ytest-Ypred));

R = corr(Ytest,Ypred);

SSres = sum((Ytest-Ypred).^2);
SStot = sum((Ytest-mean(Ytest)).^2);

R2 = 1 - SSres/SStot;

fprintf('\nFINAL RESULTS\n');
fprintf('=============================\n');
fprintf('Best Sigma = %.4f\n',bestSigma);
fprintf('RMSE = %.6f\n',RMSE);
fprintf('MAE  = %.6f\n',MAE);
fprintf('Corr = %.6f\n',R);
fprintf('R2   = %.6f\n',R2);

%% Plot

figure;

plot(Ytest,'b','LineWidth',1.5);
hold on;

plot(Ypred,'r','LineWidth',1.5);

legend('Actual','Predicted');
xlabel('Test Sample');
ylabel('Valence');
title(sprintf('Kernel Smoothing (Sigma = %.4f)',bestSigma));

grid on;

%% Save Model

save('KernelSmoothModel.mat',...
     'bestSigma',...
     'coeff',...
     'mu',...
     'numPC',...
     'Xtrain',...
     'Ytrain');

%% Save Prediction Results

PredictionTable = table(Ytest,Ypred,...
    'VariableNames',{'Actual','Predicted'});

writetable(PredictionTable,...
          'Actual_vs_Predicted.csv');

fprintf('\nModel Saved Successfully\n');n