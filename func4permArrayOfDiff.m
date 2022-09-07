%% function for making permutation array indicated num of elements in figure
function [permArrayOfDiff] = func4permArrayOfDiff(difficultyVec)
    %@returns permutation vector for the difficulty levels of the blocks 

    permArrayOfDiff = zeros(8,1);

    permDiffVec = perms(difficultyVec);
    randomDist = randperm(24,24);
    
    numOfVec = randomDist(1);
    numOfVec2 = randomDist(2);
    thisVec = permDiffVec(numOfVec, : );
    thisVec2 = permDiffVec(numOfVec2, : );
    permArrayOfDiff = [thisVec, thisVec2];
    
end

