function [ FPMASK ] = mask1(field, angular_size, FOV)
%Generate an AOSegment act like a focal plane mask
%   Detailed explanation goes here

FPMASK = AOSegment(field);
FPMASK.name = 'Focal Plane Mask';
% This mask is defined in angle. The maximum Diameter needs to be larger
% than the full angular size of the PSF. The obscuration is also in angle,
% and should be defined in terms of the diffraction angle.
Angular_Extent = 2*FOV;
% Define FPM Diameter
SPACING = 0.01
SMOOTHING = SPACING;
PUPIL_DEFFPM = [0 0 Angular_Extent 1 SMOOTHING 0 0 0 0 0
              0 0 angular_size 0 SMOOTHING/2 0 0 0 0 0];
FPMASK.spacing(SPACING);
FPMASK.pupils = PUPIL_DEFFPM;
FPMASK.make;
end

