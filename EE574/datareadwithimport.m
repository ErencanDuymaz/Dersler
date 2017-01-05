% This report explains Weighted Least Square Estimator for network whose
% data is given with two files namely ieee_cdf.dat and measure.dat

clear all;
close all;
clc;

ieee_data = importdata( 'ieee_cdf.dat');
busdata = ieee_data.data;
ieee_data_matrix_size = size(busdata);

busnumber = ieee_data_matrix_size(1,1);

measurementdata = dlmread('measure.dat');

% headerlinesOut = 34;

filename = 'ieee_cdf.dat';
headerlinesIn = busnumber+4;
delimiterIn = ' ';
A = importdata(filename,delimiterIn,headerlinesIn)
B = A.data;
C = size(B);
D = C(1,1);
B(D,:)=[];
branchdata = B;
sizebranch = size(branchdata);
branchnumber = sizebranch(1,1);

% Line impedence is given by R+jX. Therefore we should find G+jB. 
% We will write down G and B values to the 10th and 11th column.
% Line charging B should also be divided by two. It is written in 12nd
% column.

for count = 1:branchnumber
    branchdata(count,10) = real(inv(branchdata(count,7)+i*branchdata(count,8)));
    branchdata(count,11) = imag(inv(branchdata(count,7)+i*branchdata(count,8)));
    branchdata(count,12) = branchdata(count,9)/2;
end
% All data is read. Namely, busdata, measurementdata and branchdata. 

% Now, the taken measurement numbers should be read.

n_v = measurementdata(1,1); % First line indicates the voltage measurement number. 
measurementdata(1,:) = []; % Disregard this line. Voltage measurement number is known anymore.

n_pi = measurementdata(n_v+1,1); % Number of power injection measurement is found. No need to find n_qi since it is equal to n_pi.

measurementdata(n_v+1,:) = []; % Disregard this line. Power injection measurement number is known anymore.
measurementdata(n_v+n_pi+1,:) = []; % Disregard this line. Reactive power injection measurement number is known anymore.

n_pf = measurementdata(n_v+2*n_pi+1,1); % Number of power flow measurement is found. No need to find n_qf since it is equal to n_pf.

measurementdata(n_v+2*n_pi+1,:) = []; % Disregard this line. Power flow measurement number is known anymore.
measurementdata(n_v+2*n_pi+n_pf+1,:) = []; % Disregard this line. Reactive power flow measurement number is known anymore.

n_c = measurementdata(n_v+2*n_pi+2*n_pf+1,1);
measurementdata(n_v+2*n_pi+2*n_pf+1,:) = [];
measurementdata(n_v+2*n_pi+2*n_pf+n_c+1,:) = [];

% Measurement number is found as 
sizeofmeasurement = size(measurementdata);
measurementnumber = sizeofmeasurement(1,1);

tapnumber = 0;
for count = 1:branchnumber
  if branchdata(count,15) ~=0
      tapnumber = tapnumber +1;
  end 
end 


% Initiate the state vector whose size is (2*busnumber-1+tapnumber)X1 

x = zeros(2*busnumber-1+tapnumber,1);
for count = 1:busnumber
    x(count,1) = 1;
end 
for count = 2*busnumber:2*busnumber+tapnumber-1
    x(count,1) = 1;
end
    
% Initiate the Jacobian matrix  whose size is (measurementnumber)X(2*busnumber+tapnumber-1)

H = zeros(measurementnumber,2*busnumber-1+tapnumber);

%First part of the Jacobian matrix is derivatives of the measurement
%voltages with respect to state vectors 

for count = 1:n_v
    H(count,measurementdata(count,1))= measurementdata(count,1);
end

% Second part of the Jacobian is derivatives of the power flow
% measurements with respect to state vectors 
% delPij/Vi = Vi^2(gij)-Vj(gij cos theta(ij) + bij sin theta ij )

% Note that theta1 is assumed 0;
for count = 1:branchnumber
    if x(busnumber+branchdata(count,1),1) == 1
    thetaij = -x(busnumber+branchdata(count,2),1);
    else 
    thetaij = x(busnumber+branchdata(count,1),1)-x(busnumber+branchdata(count,2),1);
    end
    
    % delPij/Vi = Vi^2(gij)-Vj(gij cos theta(ij) + bij sin theta ij )

    H(n_v+2*n_pi+count,branchdata(count,1)) = (2*(x(branchdata(count,1),1)))*...
        (branchdata(count,10))-((x(branchdata(count,2),1))*...
        branchdata(count,10)*cos(thetaij)+...
        (branchdata(count,11))*sin(thetaij));
    
    % delPij/Vj = -Vi(gij cos theta(ij) + bij sin theta ij )

    H(n_v+2*n_pi+count,branchdata(count,2)) = -(x(branchdata(count,1),1))*...
        (branchdata(count,10)*cos(thetaij)+...
        (branchdata(count,11))*sin(thetaij));
    
    % delPij/thetai = Vi(gij sin theta(ij) - bij cos theta ij )
    
    if branchdata(count,1) ~= 1;
    H(n_v+count+2*n_pi,busnumber+branchdata(count,1)-1) = (x(branchdata(count,1),1))*(x(branchdata(count,2),1))*...
        (branchdata(count,10)*sin(thetaij)-...
        (branchdata(count,11))*cos(thetaij));
    end
    % delPij/thetaj = -ViVj(gij sin theta(ij) - bij cos theta ij )
    if branchdata(count,2) ~= 1;
    H(n_v+count+2*n_pi,busnumber+branchdata(count,2)-1) = -(x(branchdata(count,1),1))*(x(branchdata(count,2),1))*...
        (branchdata(count,10)*sin(thetaij)-...
        (branchdata(count,11))*cos(thetaij));
    end
end 








