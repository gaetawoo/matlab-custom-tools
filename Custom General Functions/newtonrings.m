% NewtonRings
clear;clc;
r = (0:.1:70/2)'; 
Rp = 9626+800;
Rt = 9626;
%sagPart = rpart.^2./(2*RadiusPart);
%sagTest = rtest.^2./(2*RadiusTest);
%sagDiff = sagTest - sagPart;

wavelength = .0005461;
hw = wavelength/2;

rad = 0;
N = 0;
while rad <= 70/2
	rad = sqrt(abs((Rt*Rp/(Rp-Rt))*2*hw*N));
	N = N + 1;
end
N - 2

Dsag = max(r)^2/2*(1/Rt - 1/Rp);
rings = Dsag/hw
rings = floor(rings)