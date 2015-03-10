function [ FPMASK ] = mask2( Field, maskPara )
% exponential focal plane mask
%   Detailed explanation goes here

FPMASK = AOSegment(Field);
FPMASK.name = 'Focal Plane Mask';
FPMASK.grid(exp(-normalize(Field.mag2)/maskPara) );
end
