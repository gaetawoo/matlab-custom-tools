function [val, topVals, bottomVals] = calcPercentile(x, percentile, direction)
    sortedX = sort(x, direction);
    m = int64(percentile * length(x));
    topVals = sortedX(1:m);
    bottomVals = sortedX(m + 1:end);
    val = sortedX(m);
end