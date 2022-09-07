function [blocksStructure matrixTypeTaskBlocks flagDown flagUp] = savingData(blocksStructure,...
    blockReps,N,whichTypeOfTask,whichLevelOfTask,searchTypesVec,flagDown,flagUp,...
    matrixTypeTaskBlocks, totalWith, totalWithout)
    %@func for saving the data collected in our data structure for further
    %analyzing it in present_stats()
    %@@ returns our DS after saving data; matrix of task types after update;
    %@@ indicators (flags) for matrix after update

    blocksStructure(blockReps).levelOfDiff = N;
    %fill in the indicator matrix
        if flagDown
            whichTypeOfTask = whichTypeOfTask - 1;
            flagDown = false;
        elseif flagUp
            whichTypeOfTask = whichTypeOfTask + 1;
            flagUp = false;
        end
        matrixTypeTaskBlocks(whichTypeOfTask, whichLevelOfTask) = 1;
        blocksStructure(blockReps).searchTypes = searchTypesVec(whichTypeOfTask);
        blocksStructure(blockReps).structOfRT(1).totalTrials = totalWith;
        blocksStructure(blockReps).structOfRT(2).totalTrials = totalWithout;

end