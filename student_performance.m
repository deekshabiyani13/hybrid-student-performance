%% =========================================================
% Hybrid Intelligent System: Fuzzy + Neural Network (ANFIS)
% Predicting Student Performance
%% =========================================================

clear; clc; close all;

%% ---- 1. DATASET -----------------------------------------
rng(42);
N = 300;

Attendance  = round(40 + 60 * rand(N,1));   % 40–100
AssignMarks = round(30 + 70 * rand(N,1));   % 30–100
TestMarks   = round(25 + 75 * rand(N,1));   % 25–100

% Performance score (0–1)
Score = 0.5*(TestMarks/100) + 0.3*(AssignMarks/100) + 0.2*(Attendance/100);
Score = Score + 0.04*randn(N,1);
Score = max(0.05, min(0.95, Score));

trainData = [Attendance AssignMarks TestMarks Score];

fprintf('Dataset: %d samples\n', N);

%% ---- 2. FUZZY SYSTEM ------------------------------------
fis = mamfis('Name','StudentPerformance');

% Attendance
fis = addInput(fis,[40 100],'Name','Attendance');
fis = addMF(fis,'Attendance','trapmf',[40 40 55 70],'Name','Low');
fis = addMF(fis,'Attendance','trimf',[55 72.5 90],'Name','Medium');
fis = addMF(fis,'Attendance','trapmf',[72.5 87.5 100 100],'Name','High');

% Assignment
fis = addInput(fis,[0 100],'Name','Assignment');
fis = addMF(fis,'Assignment','trapmf',[0 0 35 55],'Name','Low');
fis = addMF(fis,'Assignment','trimf',[35 60 80],'Name','Medium');
fis = addMF(fis,'Assignment','trapmf',[65 80 100 100],'Name','High');

% Test
fis = addInput(fis,[0 100],'Name','Test');
fis = addMF(fis,'Test','trapmf',[0 0 33 50],'Name','Low');
fis = addMF(fis,'Test','trimf',[33 55 75],'Name','Medium');
fis = addMF(fis,'Test','trapmf',[60 75 100 100],'Name','High');

% Output
fis = addOutput(fis,[0 1],'Name','Performance');
fis = addMF(fis,'Performance','trapmf',[0 0 0.3 0.45],'Name','Poor');
fis = addMF(fis,'Performance','trimf',[0.3 0.55 0.75],'Name','Average');
fis = addMF(fis,'Performance','trapmf',[0.6 0.8 1 1],'Name','Good');

% Rules
ruleList = [
3 3 3 3 1 1;
3 3 2 3 1 1;
3 2 3 3 1 1;
2 3 3 3 1 1;
2 2 2 2 1 1;
1 1 1 1 1 1;
];

fis = addRule(fis,ruleList);

writeFIS(fis,'student_performance_fuzzy');

%% ---- 3. ANFIS TRAINING ----------------------------------
fprintf('Training ANFIS...\n');

anfisData = [Attendance AssignMarks TestMarks Score];

opt = genfisOptions('GridPartition');
opt.NumMembershipFunctions = 2;

initFIS = genfis(anfisData(:,1:3), anfisData(:,4), opt);

trainOpt = anfisOptions('InitialFIS',initFIS,...
                        'EpochNumber',50,...
                        'DisplayANFISInformation',false);

% ✅ FIXED (only 2 outputs)
[trainedFIS, trainError] = anfis(anfisData, trainOpt);

fprintf('Training complete.\n');

%% ---- 4. EVALUATION --------------------------------------
pred = evalfis(trainedFIS, anfisData(:,1:3));

% Classification
labels = strings(N,1);
for i = 1:N
    if pred(i) < 0.4
        labels(i) = "Poor";
    elseif pred(i) < 0.7
        labels(i) = "Average";
    else
        labels(i) = "Good";
    end
end

%% ---- 5. VISUALIZATION -----------------------------------

% Membership Functions
figure;
plotmf(fis,'input',1); title('Attendance MFs');

% Training curve
figure;
plot(trainError,'LineWidth',2);
title('Training Error');

% Prediction plot
figure;
scatter(Score,pred);
xlabel('Actual'); ylabel('Predicted');
title('Prediction vs Actual');
grid on;

%% ---- 6. SAMPLE OUTPUT -----------------------------------
fprintf('\nSample Predictions:\n');
for i = 1:5
    fprintf('Attendance:%d Assignment:%d Test:%d -> Score: %.2f (%s)\n',...
        Attendance(i),AssignMarks(i),TestMarks(i),pred(i),labels(i));
end

%% ---- 7. RULE VIEWER -------------------------------------
ruleview(fis);