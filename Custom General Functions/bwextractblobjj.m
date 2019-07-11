function [logicalblob, rcregion] = bwextractblobjj(indicies, sourcedata)
  [rc(:, 1), rc(:, 2)] = ind2sub(size(sourcedata), indicies);
  rcregion = [min(rc(:, 1)), min(rc(:, 2)); max(rc(:, 1)), max(rc(:, 2))];
  logicalblob = sourcedata(rcregion(1, 1):rcregion(2, 1), rcregion(1, 2):rcregion(2, 2));
  logicalblob(logicalblob ~= 0) = 1;
  end