function [] = present_stats()
    %@void function; anaylzing data loaded from mainScaffold; visual search
    %experiment

    clear all; %clear all variables
    close all; %close all figures
    clc; %clear command window
    %%
    
    %loading data-base
    TempResultsStructure = load("VSresults.mat");
    resultsStructure = TempResultsStructure.blocksStructure;

    %allocating memory
    featureWithYaxis = zeros(1,4);
    featureWithoutYaxis = zeros(1,4);
    conjWithYaxis = zeros(1,4);
    conjWithoutYaxis = zeros(1,4);
    stdVecFeatWith = zeros(1,4);
    stdVecFeatWithout = zeros(1,4);
    stdVecConjWith = zeros(1,4);
    stdVecConjWithout = zeros(1,4);
    rtWith = zeros(1,30);
    rtWithout = zeros(1,30);
    xAxis = [4 8 12 16];

    %matrix's for With target and for Without target
    %2 of matrix 8x4 dim
    %col1 is std, col2 is mean, col3 is setSize
    %col4 is which search Type in binary indicators; 0 means "with", 1 means "without"
    matrixWith = zeros(8,4);
    matrixWithout = zeros(8,4);
    meanCol = 1;
    stdCol = 2;
    setSizeCol = 3;
    searchTypeCol = 4;
    
    %need to adjust the set size in the vectors conjWith etc.
    for blockLoop = 1 : 8
        rtWith = resultsStructure(blockLoop).structOfRT(1).rtOfUser;
        rtWithout = resultsStructure(blockLoop).structOfRT(2).rtOfUser;

        meanRTWith = mean(nonzeros(rtWith));
        meanRTWithout = mean(nonzeros(rtWithout));
        stdRTWith = std(nonzeros(rtWith));
        stdRTWithout = std(nonzeros(rtWithout));

        setSize = resultsStructure(blockLoop).levelOfDiff;
        str = resultsStructure(blockLoop).searchTypes;
        if strcmp(str, 'feature')
            whichSearchType = 0;
        else
            whichSearchType = 1;
        end

        matrixWith(blockLoop, meanCol) = meanRTWith;
        matrixWith(blockLoop, stdCol) = stdRTWith;
        matrixWith(blockLoop, setSizeCol) = setSize;
        matrixWith(blockLoop, searchTypeCol) = whichSearchType;

        matrixWithout(blockLoop, meanCol) = meanRTWithout;
        matrixWithout(blockLoop, stdCol) = stdRTWithout;
        matrixWithout(blockLoop, setSizeCol) = setSize;
        matrixWithout(blockLoop, searchTypeCol) = whichSearchType;

        switch whichSearchType
            case 0
                featureWithYaxis(setSize/4) = meanRTWith;
                featureWithoutYaxis(setSize/4) = meanRTWithout;
                stdVecFeatWith(setSize/4) = stdRTWith;
                stdVecFeatWithout(setSize/4) = stdRTWithout;
            case 1
                conjWithYaxis(setSize/4) = meanRTWith;
                conjWithoutYaxis(setSize/4) = meanRTWithout;
                stdVecConjWith(setSize/4) = stdRTWith;
                stdVecConjWithout(setSize/4) = stdRTWithout;
        end

    end

    y = zeros(1,4);
    Curve4plotWith = zeros(2,4);
    %plotting mean & std of rt of good trials as a function of set size;
    %assessing the polyfit and computing the fit using polyval and adding
    %it to the 2 figures
    f1 = figure("Color", 'w', 'Units','normalized','Position',[0 0 0.9 0.9]);
    hold on;
    plot(xAxis, featureWithYaxis, 'Color', 'b', 'LineStyle', '-', 'LineWidth', 0.5);
    plot(xAxis, conjWithYaxis, 'Color', 'r', 'LineStyle', '-', 'LineWidth', 0.5);
    xlabel('Set Size', 'FontSize', 14);
    ylabel('Mean Reaction Time [sec]', 'FontSize', 14);
    xticks(xAxis);
    title('Correctly identified presence of Target', 'FontSize', 14);
    errorbar(xAxis, featureWithYaxis, stdVecFeatWith, 'vertical','s','Color', 'm', 'LineWidth', 0.7);
    errorbar(xAxis, conjWithYaxis, stdVecConjWith, 'vertical','o','Color', 'g', 'LineWidth', 0.7);
    fittypes1 = [featureWithYaxis; conjWithYaxis];
    for i = 1 : length(fittypes1)/2
        y(:) = fittypes1(i,:);
        pWith = polyfit(xAxis, y, 1);
        Curve4plotWith(i, :) = polyval(pWith, xAxis);
        plot(xAxis, Curve4plotWith(i,:), "LineStyle", "--");
    end
    legend('feature search', 'conjunction search', 'feature error', 'conjunction error', ...
           'polyfit feature', 'polyfit conjunction', 'FontSize', 12, 'Location', 'northwest');
    hold off;

    y1 = zeros(1,4);
    Curve4plotWithout = zeros(2,4);
    f2 = figure("Color", 'w', 'Units','normalized','Position',[0 0 0.9 0.9]);
    hold on;
    plot(xAxis, featureWithoutYaxis, 'Color', 'b', 'LineStyle', '-', 'LineWidth', 0.5);
    plot(xAxis, conjWithoutYaxis, 'Color', 'r', 'LineStyle', '-', 'LineWidth', 0.5);
    xlabel('Set Size', 'FontSize', 14);
    ylabel('Mean Reaction Time [sec]', 'FontSize', 14);
    xticks(xAxis);
    title('Correctly identified the absence of Target', 'FontSize', 14);
    errorbar(xAxis, featureWithoutYaxis, stdVecFeatWithout, 'vertical','s','Color', 'm', 'LineWidth', 0.7);
    errorbar(xAxis, conjWithoutYaxis, stdVecConjWithout, 'vertical','o','Color', 'g', 'LineWidth', 0.7);
    fittypes2 = [featureWithoutYaxis; conjWithoutYaxis];
    for j = 1 : length(fittypes2)/2
        y1(:) = fittypes2(j,:);
        pWithout = polyfit(xAxis, y1, 1);
        Curve4plotWithout(j, :) = polyval(pWithout, xAxis);
        plot(xAxis, Curve4plotWithout(j,:), "LineStyle", "--");
    end
    legend('feature search', 'conjunction search', 'feature error', 'conjunction error', ...
           'polyfit feature', 'polyfit conjunction', 'FontSize', 12, 'Location', 'northwest');
    hold off;
    
    numOfMatrixes = 1:4;
    matrixStruct(numOfMatrixes) = struct('correlationMatrix', zeros(2,2), ...
                                         'pValueMatrix', zeros(2,2), ...
                                         'whichSearchType', string(''), ...
                                         'withOrWithout', string(''));
    vec4correlation = [featureWithYaxis; conjWithYaxis; ...
                       featureWithoutYaxis; conjWithoutYaxis];
    featIndex = 1;
    conjIndex = 1;
    withOrWithoutVec = [string('with'), string('without')];

    for matrixIdx = 1 : 4
        [corrMatrix pValue] = corrcoef(vec4correlation(matrixIdx,:), xAxis);
        matrixStruct(matrixIdx).correlationMatrix = corrMatrix;
        matrixStruct(matrixIdx).pValueMatrix = pValue;

        if mod(matrixIdx,2) == 0
            matrixStruct(matrixIdx).whichSearchType = 'conjunction';
            matrixStruct(matrixIdx).withOrWithout = withOrWithoutVec(conjIndex);
            conjIndex = conjIndex + 1;
        else
            matrixStruct(matrixIdx).whichSearchType = 'feature';
            matrixStruct(matrixIdx).withOrWithout = withOrWithoutVec(featIndex);
            featIndex = featIndex + 1;
        end
    end
    %%
    %displaying data;
    
    %displaying total trials anaylzed
    for l = 1 : 8
        disp('search type: '); disp(resultsStructure(l).searchTypes);
        disp('set size: '); disp(resultsStructure(l).levelOfDiff);
        disp('with\without target: '); disp(resultsStructure(l).structOfRT(1).withOrWithout);
        disp('total trials analayzed: '); disp(resultsStructure(l).structOfRT(1).totalTrials);
        disp('with\without target: '); disp(resultsStructure(l).structOfRT(2).withOrWithout);
        disp('total trials analayzed: '); disp(resultsStructure(l).structOfRT(2).totalTrials);
    end

    disp('------------------');

    %displaying pearson matrix and p.value matrix
    for k = 1 : 4
        disp('search type: '); disp(matrixStruct(k).whichSearchType);
        disp('with\without target: '); disp(matrixStruct(k).withOrWithout);
        disp('correlation matrix: ');
        disp(matrixStruct(k).correlationMatrix);
        disp('p.value matrix: ');
        disp(matrixStruct(k).pValueMatrix);
    end

end

