% future improvements: no overlapping points, manually place points
fieldsize = 500;    % assume 10um per pixel
cellsize = 16;
borderwidth = 2;
ncells = 30;
fname = 'wavebioCells.ima';

% generate field
field = zeros(fieldsize,fieldsize);

% determine locations of cells
pts = round(0.5*cellsize + (fieldsize-2-cellsize)*rand(2,ncells));

% create prototype cell
x = round((1:cellsize) - 0.5*cellsize);
[Y,X] = meshgrid(x,x);
r = sqrt(X.^2 + Y.^2);
cell = double(r<=0.5*cellsize);


% place cells in grid
for n = 1:ncells
    field(x+pts(1,n),x+pts(2,n)) = cell;
end

% create border
field(2:borderwidth,2:(fieldsize-1)) = 1;
field((fieldsize+1-borderwidth):(fieldsize-1),2:(fieldsize-1)) = 1;
field(2:(fieldsize-1),2:borderwidth) = 1;
field(2:(fieldsize-1),(fieldsize+1-borderwidth):(fieldsize-1)) = 1;

figure; imagesc(field)

dlmwrite(fname,fieldsize,'newline','pc');
dlmwrite(fname,field,'-append', 'delimiter','','newline','pc');