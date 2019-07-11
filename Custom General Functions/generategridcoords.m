function coordinates = generategridcoords(xVector, yVector, limitDiameter, flagRandomize)
  %GENERATEGRIDCOORDS  generates [X, Y] coordinates between xVector and yVector.
  %
  %   GENERATEGRIDCOORDS(xVector, yVector, limitDiameter, flagRandomize) 
  %     outputs a Nx2 matrix arranged in [X, Y] form for values from 
  %     xVector and yVector. This can be limited by a diameter for a 
  %     circular-bounded rectangular-grid pattern. The points can also be
  %     randomized slightly from their starting grid point or randomized 
  %     completely anywhere in the valid range.
  %
  %   Optional:
  %     limitDiamter, flagRandomize
  %
  %   FLAGRANDOMIZE valid options:
  %     'none'        : (default) No randomization
  %     'gridbased'   : Slight randomization starting from grid point 
  %                     and not exceeding halfway to next gridpoint
  %     'total'       : Completely random, no basis on the starting grid point
  %
  
  %   By Jeremiah Valenzuela
  %   2019
  if ~exist('limitDiameter', 'var')
    limitDiameter = Inf;
  end
  if ~exist('flagRandomize', 'var')
    flagRandomize = 'none';
  end
  
  coordinates = zeros(max(size(xVector)), 2);
  counter = 1;
  for ii = xVector
    
    for jj = yVector
      
      % Assign initial grid points
      xx = ii;
      yy = jj;
      if strcmpi(flagRandomize, 'gridbased')
        rxx = rand;
        ryy = rand;
        % General equation to scale a random number between MAX and MIN when random number is between
        % 0 and 1: 2*rand*MAX - rand*(MAX + MIN) + MIN. Simplifies to rand*(MAX - MIN) + MIN
        
        % The first diff() / 2.05 expression says where to limit where the point extends out to, so
        % 2.05 would be just under half way from the starting point based on an even grid
        % separation.  The second diff() * 0.05 says how far away from the original point to keep
        % the new point, so it can't over lap. It has to be a little bit away.
        xx = xx + (rxx * 2 - 1) * diff(xVector(1:2)) / 2.05 + sign(rxx) * diff(xVector(1:2)) * 0.05;
        yy = yy + (ryy * 2 - 1) * diff(yVector(1:2)) / 2.05 + sign(ryy) * diff(yVector(1:2)) * 0.05;
      elseif strcmpi(flagRandomize, 'total')
        % Could also use randbetween()
        xx = rand * (2 * max(xVector) - (max(xVector) + min(xVector))) + min(xVector);
        yy = rand * (2 * max(yVector) - (max(yVector) + min(yVector))) + min(yVector);
      end
      
      
      if sqrt(xx^2 + yy^2) <= limitDiameter / 2 && ...
          xx >= min(xVector) && xx <= max(xVector) && ...
          yy >= min(yVector) && yy <= max(yVector)
        
        % Assign valid coordinates rounded to common precision
        coordinates(counter, 1) = round(xx * 100000) / 100000;
        coordinates(counter, 2) = round(yy * 100000) / 100000;
        
        counter = counter + 1;
      end
      
    end
    % Flip y direction so sequential order makes a lawnmower path instead of sawtooth
    yVector = -yVector;
  end
  fprintf('Number of points = %d\n', size(coordinates, 1))
end