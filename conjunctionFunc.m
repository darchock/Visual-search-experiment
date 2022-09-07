function [rt acc] = conjunctionFunc(targetIndicator, colorVec, symbVec, N, VisualSearchExperiment)
    %@creats conjunction search type task - randomizing with\without
    %target; color of symbols; shape of symbols; locations of symbols on
    %screen
    %@@ returns rt (reaction time) and acc (accuracy) of user

    randomChoosing = randperm(2, 2);
    TargetSymbColor = colorVec(randomChoosing(1));
    TargetSymb = symbVec(randomChoosing(1));
    otherSymbColor = colorVec(randomChoosing(2));
    otherSymb = symbVec(randomChoosing(2));
    locationsOnAxisX = double((randperm(N, N))/(N + 0.01));
    locationsOnAxisY = double((randperm(N, N))/(N + 0.01));
    middle = N/2;

    ifWasTarget = mod(targetIndicator, 2);
    switch ifWasTarget
        case 0 %with target
        text(locationsOnAxisX(1:middle), locationsOnAxisY(1:middle), otherSymb, ...
              'Color', otherSymbColor, 'FontSize', 12);
        text(locationsOnAxisX(middle+1:N-1), locationsOnAxisY(middle+1:N-1), TargetSymb, ...
              'Color', TargetSymbColor, 'FontSize', 12);
        text(locationsOnAxisX(N), locationsOnAxisY(N), TargetSymb, ...
              'Color', otherSymbColor, 'FontSize', 12);
        tic;
        acc = getResponseFromUser(VisualSearchExperiment, ifWasTarget);
        rt = toc;
       case 1
        text(locationsOnAxisX(1:middle), locationsOnAxisY(1:middle), otherSymb, ...
              'Color', otherSymbColor, 'FontSize', 12);
        text(locationsOnAxisX(middle+1:N), locationsOnAxisY(middle+1:N), TargetSymb, ...
              'Color', TargetSymbColor, 'FontSize', 12);
        tic;
        acc = getResponseFromUser(VisualSearchExperiment, ifWasTarget);
        rt = toc;
    end

end
