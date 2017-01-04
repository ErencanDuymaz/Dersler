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

% Second part of the Jacobian is derivatives of the power injection
% measurements with respect to state vectors 
% delPij/Vi = Vi^2(gij)-Vj(gij cos theta(ij) + bij sin theta ij )

% Note that theta1 is assumed 0;
for count = 1:branchnumber
    if x(busnumber+branchdata(count,1),1) == 1
    thetaij = -x(busnumber+branchdata(count,2),1);
    else 
    thetaij = x(busnumber+branchdata(count,1),1)-x(busnumber+branchdata(count,2),1)
    end
    H(n_v+count,branchdata(count,1)) = ((2*(x(branchdata(count,1),1))))*...
        (inv(branchdata(count,1)))-(x(branchdata(count,2)))*...
        ((inv(branchdata(count,7)))*cos(thetaij)+...
        (((inv(branchdata(count,8)))*sin(thetaij))))
end 








