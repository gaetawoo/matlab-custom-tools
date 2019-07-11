try %#ok
    % https://undocumentedmatlab.com/blog/reverting-axes-controls-in-figure-toolbar
    if ~verLessThan('matlab','9.5')
        set(groot,'defaultFigureCreateFcn',@(fig,~)addToolbarExplorationButtons(fig));
        set(groot,'defaultAxesCreateFcn',  @(ax,~)axDefaultCreateFcn(ax));
    end
end