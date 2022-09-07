function [rt acc] = featureFunc(targetIndicator, colorVec, symbVec, N, VisualSearchExperiment)
    %@creats feature search type task - randomizing with\without
    %target; color of symbols; shape of symbols; locations of symbols on
    %screen
    %@@ returns rt (reaction time) and acc (accuracy) of user

    randomChoosing = randperm(2,2);
    symbColor = colorVec(randi(2));
    locationsOnAxisX = double((randperm(N, N))/(N + 0.01));
    locationsOnAxisY = double((randperm(N, N))/(N + 0.01));

    ifWasTarget = mod(targetIndicator, 2);
    switch ifWasTarget
        case 0 %with target
            targetedSymbol = symbVec(randomChoosing(1));
            otherSymbol = symbVec(randomChoosing(2));
            text(locationsOnAxisX(1:N-1), locationsOnAxisY(1:N-1), otherSymbol, ...
                'Color', symbColor, 'FontSize', 12);
            text(locationsOnAxisX(N), locationsOnAxisY(N), targetedSymbol, ...
                'Color', symbColor, 'FontSize', 12);
            tic;
            acc = getResponseFromUser(VisualSearchExperiment, ifWasTarget);
            rt = toc;
        case 1 %without target
            symb2disp = symbVec(randomChoosing(randi(2)));
            text(locationsOnAxisX, locationsOnAxisY, symb2disp, ...
                'Color', symbColor, 'FontSize', 12);
            tic;
            acc = getResponseFromUser(VisualSearchExperiment, ifWasTarget);
            rt = toc;
    end

end