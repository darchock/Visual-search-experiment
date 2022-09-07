function UserResponse = getResponseFromUser(VisualSearchExperiment, ifWasTarget)
    %@func responsible for getting user response and returning if his
    %response matches whether there was target or not

    %ifWasTarget can be 0 which means it was with target
    %or 1 which means it was without target
    pause;
    keyUserClicked = VisualSearchExperiment.CurrentCharacter;
    clf;

    if ifWasTarget ~= strcmp(keyUserClicked, 'A') %there was target && user clicked 'A'
            UserResponse = 1;
    else %there was no target && user click 'A' - false positive
            UserResponse = 0;
    end
    
end