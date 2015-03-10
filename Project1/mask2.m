function [ FPMASK ] = mask2( Field, threshold )
% exponential focal plane mask
%   Detailed explanation goes here

FPMASK = AOSegment(Field);
FPMASK.name = 'Focal Plane Mask';
fmag2 = normalize(log10(Field.mag2));
mask = ones(size(fmag2));
mask(fmag2 > threshold) = 0;
FPMASK.grid(mask);
end

