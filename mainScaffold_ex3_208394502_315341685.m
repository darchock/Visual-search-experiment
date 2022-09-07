%main scaffold 315341685_208394502

clear all; %clear all variables
close all; %close all figures
clc; %clear command window
%%

NewLine = char(10);
%creating figure
VisualSearchExperiment = creatingFullScreenFigure();
welcomeText = text(0.28, 0.8, ['Welcome to our experiment!'], ...
                   'FontSize', 32, 'Color', 'b');
explainingExp = text(0.20, 0.45, ['You are going to participate in Visual Search Experiment' NewLine ...
                               'There are 2 different search types: feature and conjunction' NewLine ...
                               'Feature search is characterized by 1 different trait between the symbols: by shape' NewLine ...
                               'Conjunction search is characterized by 1 different trait between the symbols: by shape and by color' NewLine ...
                               'Notice that the there are 2 modes to each search type: with or without target' NewLine ...
                               'With target means that there is a difference in the traits - when presented a trial with a target you should press A' NewLine ...
                               'Without target means there is no difference in the traits - when presented a trial without a target you shold press L'], ...
                               'FontSize', 16, 'Color', 'b');
text(0.30, 0.20, ['Be quick because your time is being recorded :)' NewLine ...
                  'To begin the experiment press spacebar'], 'FontSize', 16, 'FontWeight','bold','Color','b');
spacebar = ' ';
wait4User(VisualSearchExperiment, spacebar);
clf;
set(VisualSearchExperiment, 'MenuBar', 'none');
axis off;

%%allocating memory - crating data Structure
numOfBlocks = 1:8;
withOrWithoutFields = 1:2;
searchType1 = string('feature');
searchType2 = string('conjunction');
searchTypesVec = [string('feature'), string('conjunction')];
withOrWithoutVec = [string('with'), string('without')];

insideStruct(withOrWithoutFields) = struct('withOrWithout', string(''), 'rtOfUser', zeros(1,30), ...
                                           'totalTrials', zeros(1));
insideStruct(1).withOrWithout = "with";
insideStruct(2).withOrWithout = "without";
blocksStructure(numOfBlocks) = struct('searchTypes', zeros(1,1), 'levelOfDiff', zeros(1,1), ...
                             'structOfRT',insideStruct);

%creating variables for randomizing trials
difficultyVec = [4,8,12,16];
symbVec = ['X', 'O'];
color1 = string('red');
color2 = string('blue');
colorVec = [color1, color2];
typeOfTaskArray = randperm(8,8);
matrixTypeTaskBlocks = zeros(2,4);
flagDown = false;
flagUp = false;
blocksIndex = 9; %blocks max iterator
blockReps = 1; %blocks iterator

%allocating memory
rtVec = zeros(1,30);
accVec = zeros(1,30);
rtWith = zeros(1,30);
rtWithout = zeros(1,30);
rtWithPrev = zeros(1,30);
rtWithoutPrev = zeros(1,30);
prevRtVec = zeros(1,30);
prevCounterOfGoodRT = zeros(1,8);
counterGoodRT = 0;
repetitionBlocks = zeros(1,8);
totalWith = 0;
totalWithout = 0;

%creating permutations array for difficulty
    [permArrayOfDiff] = func4permArrayOfDiff(difficultyVec);

while blockReps ~= blocksIndex
    clf;
    set(VisualSearchExperiment, 'MenuBar', 'none');
    axis off;
    
    N = permArrayOfDiff(blockReps);
    TaskIndicator = typeOfTaskArray(blockReps);
    %creating binary permutations indicating with or without target trial
    %and binary permutation indicating which color & symbol is used in trial 
    withOrWithout = randperm(30, 30);
    %indexes of the matrix indicates wether we exhausted all of the options
    %-- 4 difficulty levels for each search type exactly!
    whichTypeOfTask = mod(TaskIndicator, 2) + 1;
    whichLevelOfTask = N/4;

    if mod(TaskIndicator, 2) == 0
        if matrixTypeTaskBlocks(whichTypeOfTask,whichLevelOfTask) == 1
            currentTask = 'conjunction task';
        else
            currentTask = 'feature task';
        end
    else
        if matrixTypeTaskBlocks(whichTypeOfTask,whichLevelOfTask) == 1
            currentTask = 'feature task';
        else
            currentTask = 'conjunction task';
        end
    end

    text(0.30, 0.50, ['in upcoming block you are to going to do a ', currentTask NewLine ...
                      'with ', num2str(N), ' elements' NewLine ...
                      'press spacebar to continue'], 'FontSize', 16, 'Color', 'b');
    pause;
    wait4User(VisualSearchExperiment, spacebar);
    clf;
    set(VisualSearchExperiment, 'MenuBar', 'none');
    axis off;

    for trial = 1 : 30
        targetIndicator = withOrWithout(trial);

        %deciding which task is next depending on matrix indicator
        %individual functions for each search type
        if whichTypeOfTask == 1 && matrixTypeTaskBlocks(whichTypeOfTask, whichLevelOfTask) == 0
            [rtVec(trial) accVec(trial)] = featureFunc(targetIndicator, colorVec, symbVec, N, VisualSearchExperiment);
        elseif whichTypeOfTask == 2 && matrixTypeTaskBlocks(whichTypeOfTask, whichLevelOfTask) == 0
            [rtVec(trial) accVec(trial)] = conjunctionFunc(targetIndicator, colorVec, symbVec, N, VisualSearchExperiment);
        elseif whichTypeOfTask ~= 1
            [rtVec(trial) accVec(trial)] = featureFunc(targetIndicator, colorVec, symbVec, N, VisualSearchExperiment);
            flagDown = true;
        else
            [rtVec(trial) accVec(trial)] = conjunctionFunc(targetIndicator, colorVec, symbVec, N, VisualSearchExperiment);
            flagUp = true;
        end

        if (rtVec(trial) <= 3 && accVec(trial) == 1)
            wasTarget = mod(targetIndicator, 2) + 1;% if 1 it's with, else it's 2 and it's without

            switch wasTarget %just for reading purposes
                case 1 %means we add to rt vector with target
                    blocksStructure(blockReps).structOfRT(wasTarget).rtOfUser(trial) = rtVec(trial);
                    rtWith(trial) = rtVec(trial);
                    totalWith = totalWith + 1;
                case 2 %means we add to rt vector without target
                    blocksStructure(blockReps).structOfRT(wasTarget).rtOfUser(trial) = rtVec(trial);
                    rtWithout(trial) = rtVec(trial);
                    totalWithout = totalWithout + 1;
            end
            counterGoodRT = counterGoodRT + 1;
        end
        
        %clear figure
        clf;
        set(VisualSearchExperiment, 'MenuBar', 'none');
        axis off;
    end
    
    %check if block is good
    if(counterGoodRT >= 20)
        [blocksStructure matrixTypeTaskBlocks flagDown flagUp] = savingData(blocksStructure, ...
                                                                 blockReps,N,whichTypeOfTask,...
                                                                 whichLevelOfTask,searchTypesVec,...
                                                                 flagDown,flagUp, matrixTypeTaskBlocks, ...
                                                                 totalWith, totalWithout);
        %continue in the while loop
        blockReps = blockReps + 1;
        totalWith = 0;
        totalWithout = 0;
        prevTotalWith = 0;
        prevTotalWithout = 0;
        rtWithPrev = zeros(1,30);
        rtWithoutPrev = zeros(1,30);
        %after successful block - off to the next block
        text(0.25, 0.5, 'In between blocks - u can freshen up in the meanwhile, to continue press spacebar', ...
             'FontSize', 14, 'Color', 'b');
        wait4User(VisualSearchExperiment, spacebar);
        clf;

    else %current block wasn't good, and need to be reapeted
        if repetitionBlocks(blockReps) == 1 %indicates this the reapeted block
            %case 1 - prev block was better then current block - both under
            % 20 correct responses
            if prevCounterOfGoodRT > counterGoodRT
                %saving previous block result - beacuse they are better
                blocksStructure(blockReps).structOfRT(1).rtOfUser(:) = rtWithPrev(:);
                blocksStructure(blockReps).structOfRT(2).rtOfUser(:) = rtWithoutPrev(:);
                totalWith = prevTotalWith;
                totalWithout = prevTotalWithout;
                prevTotalWith = 0;
                prevTotalWithout = 0;
            %else - case 2 - if current block > prevBlock - both under 20
            %correct responses; we save current data -
            %the data is already stored in the correct variables -
            %thus no need for changing anything
            end

            [blocksStructure matrixTypeTaskBlocks flagDown flagUp] = savingData(blocksStructure, ...
                                                                 blockReps,N,whichTypeOfTask,...
                                                                 whichLevelOfTask,searchTypesVec,...
                                                                 flagDown,flagUp, matrixTypeTaskBlocks, ...
                                                                 totalWith, totalWithout);
            prevCounterOfGoodRT = 0;
            totalWith = 0;
            totalWithout = 0;
            rtWithPrev = zeros(1,30);
            rtWithoutPrev = zeros(1,30);
            blockReps = blockReps + 1;
            %after successful block - off to the next block
            text(0.25, 0.5, 'In between blocks - u can freshen up in the meanwhile, to continue press spacebar', ...
                'FontSize', 14, 'Color', 'b');
            wait4User(VisualSearchExperiment, spacebar);
            clf;
        else
            repetitionBlocks(blockReps) = 1;
            rtWithPrev(:) = rtWith(:);
            rtWithoutPrev(:) = rtWithout(:);
            prevCounterOfGoodRT = counterGoodRT;
            prevTotalWith = totalWith;
            prevTotalWithout = totalWithout;
            totalWith = 0;
            totalWithout = 0;
        end

        text(0.25, 0.5, ['Block wasnt good enough, too many mistakes :(' NewLine ...
                         'please be focused and try to answer quickly but accurate' NewLine ...
                         'press spacebar to continue'], ...
                         'FontSize', 14, 'Color', 'b');
        wait4User(VisualSearchExperiment, spacebar);
        clf;
    end
    rtWith = zeros(1,30);
    rtWithout = zeros(1,30);
    counterGoodRT = 0;
end

%closing text for ending experiment and closing figure
clf;
set(VisualSearchExperiment, 'MenuBar', 'none');
axis off;
text(0.25, 0.5, ['End of blocks, thank you for participating in our Visual Search Experiment' NewLine ...
                 'press spacebar to finish and close the figure, Hope you had fun :)'], 'FontSize', 18, 'Color', 'b');
pause;
wait4User(VisualSearchExperiment, spacebar);
close;

%%
%saving the results
save("VSresults.mat", 'blocksStructure');

%%
%calling statistic analayze of the data
present_stats();
