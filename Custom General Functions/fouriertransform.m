%script fouriertransform.m

clear
clc
format short
format compact

[pic,map] = imread('C:\Documents and Settings\Jeremiah\Desktop\cat','jpg');
colormap(gray);
imagesc(pic)

FT = fftshift(fft2(pic));

for q = 1:10
    figure
    IFT = abs(FT)/10^(q/2);
    colormap(gray)
    image(IFT)
end