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
A = importdata(filename,delimiterIn,headerlinesIn);
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

% Third part of the Jacobian is derivatives of the power flow
% measurements with respect to state vectors 

% delPij/Vi = Vi^2(gij)-Vj(gij cos theta(ij) + bij sin theta ij )

% Note that theta1 is assumed 0;

for count = n_v+2*n_pi+1:n_v+2*n_pi+n_pf
    
    %thetaij value is calculated as follows
    
    if measurementdata(count,1) == 1
    thetaij = -x(busnumber+measurementdata(count,2)-1,1);
    else 
    thetaij = x(busnumber+measurementdata(count,1),1)-x(busnumber+measurementdata(count,2),1);
    end
    

    
    for count2 = 1:branchnumber
        if measurementdata(count,1) == branchdata(count2,1) && measurementdata(count,2) == branchdata(count2,2) || ...
                measurementdata(count,2) == branchdata(count2,1) && measurementdata(count,1) == branchdata(count2,2)
                
    %Vi = x(measurementdata(count,1),1)
    %Vj = x(measurementdata(count,2),1)
    %gij = branchdata(count2,10)
    %bij = branchdata(count2,11)    
    
    % delPij/Vi = 2*Vi(gij)-Vj(gij cos theta(ij) + bij sin theta ij ) 
    
    H(count,measurementdata(count,1)) = (2*x(measurementdata(count,1),1))*...
        branchdata(count2,10)-((x(measurementdata(count,2),1))*...
        branchdata(count2,10)*cos(thetaij)+...
        (branchdata(count2,11))*sin(thetaij));
    
    
    % delPij/Vj = -Vi(gij cos theta(ij) + bij sin theta ij )

    H(count,measurementdata(count,2)) = -(x(measurementdata(count,1),1))*...
        (branchdata(count2,10)*cos(thetaij)+...
        (branchdata(count2,11))*sin(thetaij));   
    
        
            if branchdata(count2,1) ~= 1
            
    % delPij/thetai = ViVj(gij sin theta(ij) - bij cos theta ij )     
            
     H(count,busnumber+measurementdata(count,1)-1) = x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*sin(thetaij)-branchdata(count2,11)*cos(thetaij));
    
    % delPij/thetaj = -ViVj(gij sin theta(ij) - bij cos theta ij )     
            
     H(count,busnumber+measurementdata(count,2)-1) = (-1)* x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*sin(thetaij)-branchdata(count2,11)*cos(thetaij));
            end
            
            
            if branchdata(count2,1) == 1
            

    
    % delPij/thetaj = -ViVj(gij sin theta(ij) - bij cos theta ij )     
            
     H(count,busnumber+measurementdata(count,2)-1) = (-1)* x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*sin(thetaij)-branchdata(count2,11)*cos(thetaij));
            end
        end
    end
    
    
end 

% The reactive power flow derivatives are calculated in a similar manner. 

for count = n_v+2*n_pi+n_pf+1:n_v+2*n_pi+2*n_pf
    
    %thetaij value is calculated as follows
    
    if measurementdata(count,1) == 1
    thetaij = -x(busnumber+measurementdata(count,2)-1,1);
    else 
    thetaij = x(busnumber+measurementdata(count,1),1)-x(busnumber+measurementdata(count,2),1);
    end
    

    
    for count2 = 1:branchnumber
        if measurementdata(count,1) == branchdata(count2,1) && measurementdata(count,2) == branchdata(count2,2) || ...
                measurementdata(count,2) == branchdata(count2,1) && measurementdata(count,1) == branchdata(count2,2)
                
    %Vi = x(measurementdata(count,1),1)
    %Vj = x(measurementdata(count,2),1)
    %gij = branchdata(count2,10)
    %bij = branchdata(count2,11)    
    %bsi = branchdata(count2,12) 
    
    % delQij/Vi = -Vj(gij sin theta(ij) - bij cos theta ij ) - 2*Vi(bij+bsi)
    
    H(count,measurementdata(count,1)) = (-1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*sin(thetaij)-branchdata(count2,11)*cos(thetaij))...
         - (2)*(x(measurementdata(count,1),1))*(branchdata(count2,11)+branchdata(count2,12));
    
    
    % delQij/Vj = -Vi(gij sin theta(ij) - bij cos theta ij )

    H(count,measurementdata(count,2)) = (-1)*x(measurementdata(count,1),1)*...
         (branchdata(count2,10)*sin(thetaij)-branchdata(count2,11)*cos(thetaij));   
    
        
            if branchdata(count2,1) ~= 1
            
    % delQij/thetai = -ViVj(gij cos theta(ij) - bij sin theta ij )     
            
     H(count,busnumber+measurementdata(count,1)-1) = (-1)*x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*cos(thetaij)-branchdata(count2,11)*sin(thetaij));
    
    % delQij/thetaj = ViVj(gij cos theta(ij) + bij sin theta ij )     
            
     H(count,busnumber+measurementdata(count,2)-1) =  x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*cos(thetaij)+branchdata(count2,11)*sin(thetaij));
            end
            
            
            if branchdata(count2,1) == 1
            

    
    % delQij/thetaj = ViVj(gij cos theta(ij) + bij sin theta ij )     
            
     H(count,busnumber+measurementdata(count,2)-1) = x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*cos(thetaij)+branchdata(count2,11)*sin(thetaij));
            end
        end
    end
       
    
end 







