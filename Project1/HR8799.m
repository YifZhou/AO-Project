function HR8799(OWA)
%% define the HR8799 system
% only consider contrast in Ks band
Ks0 = 5.24;
Ks = [17.03, 16.12, 16.09, 15.913];
contrast = 10.^((Ks0 - Ks)/2.5);

dx = [-1.528, 0.657, 0.216, 0.324];
dy = [0.798, 0.706, -0.582, -0.174]; %% in arcsec

%% using the 61inch telescope to look at this system
lambda = AOField.KBAND; % Red light.
D = 6.50;
secondary = 62.5/100;

SPACING = 0.01;            % fine spacing makes nice pupil images but is really overkill.
aa = SPACING;              % for antialiasing.
% aa = 0.04;
spider = 0.0254;
% spider = 0.01;

% Scales
THld = lambda/D * 206265; % Lambda/D in arcsecs.
FOV = 3; % arcsecs
PLATE_SCALE = THld/3;

PUPIL_DEFN = [
    0 0 D         1 aa 0 0 0 0 0
    0 0 secondary 0 aa/2 0 0 0 0 0
    0 0 spider   -2 aa 4 0 D/1.9 0 0
    ];

% Since this demo only uses one AOSegment, I will not use the AOAperture wrapper.
% I will only use AOSegment.  This is fine for simple pupils.

A = AOSegment;
A.spacing(SPACING);
A.name = 'Kuiper 61inch Primary';
A.pupils = PUPIL_DEFN;
A.make;

%create an AO field,
F = AOField(A);
F.FFTSize = 1024; % Used to compute PSFs, etc.
F.resize(F.FFTSize);
F.lambda = lambda;

F.planewave*A; % Just go through the pupil.
F.grid(F.fft/F.nx); % Go to the focal plane.

FPMASK = AOSegment(F);
FPMASK.grid(exp(-normalize(F.mag2)/0.1) ); % This is pretty ad hoc.

F.grid(F.fft/F.nx); % Go to the Lyot pupil plane.

LYOT = AOSegment(F);
% LYOT.grid(F.real); % This is a good way to bootstrap a Lyot Stop.

% This is a better way...
LYOTSTOP_DEFN = [
    0 0 (D*OWA)         1 aa 0 0 0 0 0  % undersize the Lyot stop
    0 0 (secondary*1.3) 0 aa/2 0 0 0 0 0 % oversize the secondary
    0 0 spider         -2 aa 4 0 D/1.9 0 0
    ];

LYOT.pupils = LYOTSTOP_DEFN;
LYOT.make;

%primary star pass to the ccd
F.planewave*A;
F.grid(F.fft/F.nx);% go to the focal plane
F*FPMASK
F.grid(F.fft/F.nx);% go to the lyot pupil plane
F*LYOT
[PSF0,thx,thy] = F.mkPSF(FOV,PLATE_SCALE); % PSF of the primary
PSF = PSF0;

for i=1:4
    F.planewave(1, [dx(i), dy(i)])*A;
    F.grid(F.fft/F.nx);% go to the focal plane
    F*FPMASK
    F.grid(F.fft/F.nx);% go to the lyot pupil plane
    F*LYOT
    [PSFi,thx,thy] = F.mkPSF(FOV,PLATE_SCALE);
    PSF = PSF + contrast(i) * PSFi;
end
photonPerExp = 1e12;
CCD = photonz(PSF, photonPerExp);

clf;
figure(1);
imagesc(thx, thy, log10(CCD));axis xy;axis equal;colormap(hot);colorbar;
title(sprintf('Lyot Outer Radius = %.2f', OWA));
saveas(1,sprintf('Lyot_out_%.2f.png', OWA),'png');
end






