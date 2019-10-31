function image = convertImgBitDepth(image, oldOrigBitDepth, oldBitShift, newOrigBitDepth, newBitShift, newDataClass)
% CONVERTIMGBITDEPTH converts source image to a new bit depth, with new bit shift, and new data
% class
%
% SYNTAX:
%    image = convertImgBitDepth(image, oldOrigBitDepth, oldBitShift, newOrigBitDepth, newBitShift, newDataClass)
%
% INPUTS:
%    source - Image to convert
%    oldOrigBitDepth - Original bit depth of image to convert (before bit shifting)
%    oldBitShift - Bit shift value of image to convert
%    newOrigBitDepth - New bit depth to convert image to (before bit shifting)
%    newBitShift - Amount to bit shift final image
%    newDataClass - Cast final converted image into new data class
%
% OUTPUTS:
%    convertedImg - Bit depth (with bit shifting) converted image with new data class
%
% EXAMPLE:
%    
%
% SEE ALSO:
%    GETBITDEPTH

% Created on: September 23, 2019
% By: Jeremiah Valenzuela

% Reduce scaled bit depth to original bit depth
image = image ./ 2^oldBitShift;

% Degrade bit depth to new bit depth
image = image ./ 2^(oldOrigBitDepth - newOrigBitDepth);

% Bit shift into new scaling
image = image .* 2^newBitShift;

% Cast into new data class
image = cast(image, newDataClass);

end