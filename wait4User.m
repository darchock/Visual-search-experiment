function [] = wait4User(VisualSearchExperiment, spacebar)
   %@func responsible for transitions between blocks - when participant is
   %ready to continue

   while ~strcmp(VisualSearchExperiment.CurrentCharacter, spacebar)
        pause;
    end    
    
end
        