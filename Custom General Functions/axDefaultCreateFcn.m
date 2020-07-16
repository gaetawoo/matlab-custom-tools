function axDefaultCreateFcn(hAxes, ~)
  % https://undocumentedmatlab.com/blog/improving-graphics-interactivity#more-8723
    try
        hAxes.Interactions = [zoomInteraction regionZoomInteraction rulerPanInteraction];
        hAxes.Toolbar = [];
    catch
        % ignore - old Matlab release
    end
end