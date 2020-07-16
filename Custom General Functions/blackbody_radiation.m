 clc
clear

% Constants
c1 = 3.741771e-4;
c1q = 1.8836516e9;
c2 = 14388;
c = 3*10^8;
h = 6.626*10^-34;
k = 1.38*10^-23;
n = 1;
T = 500;
A = pi*.01^2;
omega = .001256;


% Power in watts
OUTwatts = 0;
for n = 1:10000
    lambda(n) = (n*10^-6)/1000;
    x(n) = lambda(n)*10^6;
    Lwatts(n) = (2*h*c^2/(lambda(n))^5)*(1/(exp(h*c/(lambda(n)*k*T))-1));
    Pwatts(n) = Lwatts(n)*omega*A;
    OUTwatts = Pwatts(n)*lambda(n)/1.48 + OUTwatts;
end
OUTwatts

% Power in photons
OUTphot = 0;
for n = 1:10000
    lambda(n) = (n*10^-6)/1000;
    x(n) = lambda(n)*10^6;
    Lphot(n) = (c1q/(pi*(lambda(n))^4))*(1/(exp(h*c/(lambda(n)*k*T))-1));
    Pphot(n) = Lphot(n)*omega*A;
    OUTphot = Pphot(n)*lambda(n)/(7.450498*10^18) + OUTphot;
end
OUTphot

plot(x,Pwatts)
xlabel('wavelength (um)')
ylabel('Power (W)')
title('Power vs. wavelength')
legend('T=500K')

figure
plot(x,Pphot)
xlabel('wavelength (um)')
ylabel('Power (photons/sec)')
title('Power vs. wavelength')
legend('T=500K')