function [VisualSearchExperiment] = creatingFullScreenFigure()
    %@returns full screen figure - this figure will stay open with the
    %participant all along the experiment

    color4figure = 'white';
    position4figure = [0 0 1 1];

    VisualSearchExperiment = figure("Color", color4figure, 'Units', 'normalized', "Position", position4figure);
    set(VisualSearchExperiment, 'MenuBar', 'none');
    axis off;

end