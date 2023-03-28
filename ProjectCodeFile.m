clc; clear all; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     INSTRUCTIONS                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                               %
%     1)  To run the program for Moon, set PRun =1;                             %
%     2)  To run the program for Graffiti, set PRun = 2;                        %
%     3)  Close the plot windows to continue the program everytime they appear. %
%         (or remove the waitfor() commands in every section)                   %
%     4)  Make sure MoonCrater.jpg and Graffiti,jpg are in the same folder as   %
%         this program.                                                         %
%     5)  When running the program for Graffiti, filter creation takes some     %
%         time because matrix is almost 6x times the MoonCrater matrix.         %
%                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PRun = 1;     % Either 1 or 2

if PRun ==1
  LoadImage = 'MoonCrater.jpg';
elseif PRun ==2
  LoadImage = 'Graffiti.jpg';
else
  fprintf('Invalid PRun value.');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SECTION 1: Image Loading and Plotting                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Image1] = imread(LoadImage);
[Nr Nc] = size(Image1);
graph1=figure();
imagesc(Image1);
title('Original Image')
colormap('gray');
colorbar();
waitfor(graph1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SECTION 2: Fourier Transform Calculation and Plotting                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CF = fftshift(fft2(Image1));
CF2 = log10(abs(CF));
graph2 = imagesc(CF2);
title('Spectra of Absolute Values of FT (dB Scale')
colormap('gray');
colorbar();
waitfor(graph2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       EXTRA SECTION: For Plotting Mesh of Real Matrix of Fourier Transform    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

##dumx = 1:1:Nr;
##dumy = 1:1:Nc;
##meshplot=mesh(dumy,dumx,CF2);
##colormap('gray');
##colorbar();
##waitfor(meshplot)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SECTION 3: Filter Design and Plotting                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if PRun ==1       % Filter for Moon Crater
  FW  = 2;
RS  = 6;
MyF = ones(Nr,Nc);
for i=1:Nr
  for j=1:Nc
    if( ( i<(Nr/2 -RS) ||  i>(Nr/2 + RS)) && (j >(Nc/2 - FW) && j<(Nc/2 + FW)));
      MyF(i,j) = 0;
    end
  end
end
elseif PRun ==2;  % Filter for Graffiti (Modified version of Filter for Moon Crater)
FW  = 40;
RS  = 50;
TBRS = 300;
MyF = ones(Nr,Nc);
for i=1:Nr
  for j=1:Nc
    if( ((i>TBRS && i<(Nr/2 -RS)) ||  (i>(Nr/2 + RS) && i<Nr-TBRS )) && (j >(Nc/2 - FW) && j<(Nc/2 + FW)));
      MyF(i,j) = 0;
    end
  end
end
else
fprintf('Invalid PRun value.');
end
% Filter Plotting
graph3 = imagesc(MyF);
title('Designed Filter')
colormap('gray');
colorbar();
waitfor(graph3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SECTION 4: Filter Testing and Plotting                                    %
%                Product of Filter and Real Matrix of Fourier Transform         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MyFFT = MyF.*CF2;
graph4 = imagesc(MyFFT);
title('Filter applied on Absolute Value Spectrum of FT')
colormap('gray');
colorbar();
waitfor(graph4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SECTION 4: Filter Implementation and Plotting                             %
%                Product of Filter and Complex Matrix of Fourier Transform      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ConvF   = MyF.*CF;
IFTI    = (ifft2(ifftshift(ConvF)));
igraph5 = imagesc(abs(IFTI));
title('Filtered Image')
colormap('gray');
colorbar();
waitfor(graph5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
