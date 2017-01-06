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
Br = A.data;
C = size(Br);
D = C(1,1);
Br(D,:)=[];
fclose('all');
branchdata = Br;
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
      tappedbranches(tapnumber+1,1)=count;
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

%For power injection matrices, we need to find G and B matrices 
%Initiate the matrices:
    G = zeros(busnumber,busnumber);
    B = zeros(busnumber,busnumber);
    
%For considering tapping in the branches 
branchdata2 = branchdata;
for count = 1:tapnumber
    branchdata2(tappedbranches(tapnumber),11)=branchdata2(tappedbranches(tapnumber),11)/x(2*busnumber-1+tapnumber,1);
    branchdata2(tappedbranches(tapnumber),12)=(branchdata2(tappedbranches(tapnumber),12)*(1-x(2*busnumber-1+tapnumber,1)))/x(2*busnumber-1+tapnumber,1)^2;
        
end   
for count = 1:busnumber

    G(count,count)=busdata(count,15);
    B(count,count)=busdata(count,16);
end
   for counter = 1:branchnumber 
     
    G(branchdata2(counter,1),branchdata2(counter,2))=G(branchdata2(counter,1),branchdata2(counter,2))-branchdata2(counter,10);
    B(branchdata2(counter,1),branchdata2(counter,2))=B(branchdata2(counter,1),branchdata2(counter,2))-branchdata2(counter,11);
    
    G(branchdata2(counter,1),branchdata2(counter,1))=G(branchdata2(counter,1),branchdata2(counter,1))+branchdata2(counter,10);
    B(branchdata2(counter,1),branchdata2(counter,1))=B(branchdata2(counter,1),branchdata2(counter,1))+branchdata2(counter,11);
    
    G(branchdata2(counter,2),branchdata2(counter,2))=G(branchdata2(counter,2),branchdata2(counter,2))+branchdata2(counter,10);
    B(branchdata2(counter,2),branchdata2(counter,2))=B(branchdata2(counter,2),branchdata2(counter,2))+branchdata2(counter,11)+branchdata2(counter,12);   
        
   end
   % Upper part of the G matrix have been calculated above. Actual matrices
   % are calculated below.
G = G +G'-tril(G,0);
B = B +B'-tril(B,0);

    for thetacounter = 2:busnumber   
                theta = zeros(busnumber,1);
                theta(thetacounter,1)=x(busnumber+thetacounter-1,1);
    end
    

% In this part, power injection derivatives will be calculated based on G
% and B values which are calculated above by considering transformar taps.

%   delPi/delVi = sum ( Vj(Gij cos thetaij + Bij sin thetaij )+ Vi Gii

for count = n_v+1:n_v+n_pi
    
    %Vi = x(measurementdata(count,1),1)
    %Vj = x(measurementdata(count,2),1)
    
    %thetaij value is calculated as follows
          
    
    
    
    for counter = 1:busnumber
       if count~=counter
           
           
     %   delPi/delVi = sum ( Vj(Gij cos thetaij + Bij sin thetaij )+ Vi Gii
           sumdelpidelvi(counter,1) = x(counter)*(G(measurementdata(count,1),counter)*cos(theta(count)-theta(counter))+B(measurementdata(count,1),counter)*sin(theta(count)-theta(counter)));
           
                
    
    %   delPi/delVj = Vi(Gij cos thetaij + Bij sin thetaij )
    
             H(count,counter) = x(measurementdata(count,1),1)*...
        (G(measurementdata(count,1),counter)*cos(theta(count)-theta(counter))+B(measurementdata(count,1),counter)*sin(theta(count)-theta(counter)));
    
    %   delPi/delthetai = sum ( ViVj(-Gij sinthetaij+Bij cos thetaij)) -Vi^2 Bii
    
            sumdelpidelthetai(counter,1) = x(counter)*x(measurementdata(count,1),1)*(-G(measurementdata(count,1),counter)*sin(theta(count)-theta(counter))+B(measurementdata(count,1),counter)*cos(theta(count)-theta(counter)));
        
    %   delPi/delthetaj = ViVj(Gij sin thetaij - Bij cos thetaij )  
        
                    if counter ~= 1
             H(count,busnumber+counter-1) = x(counter)*x(measurementdata(count,1),1)*...
        (G(measurementdata(count,1),counter)*sin(theta(count)-theta(counter))-B(measurementdata(count,1),counter)*cos(theta(count)-theta(counter)));    
                    end
       end
       
       
       H(count,measurementdata(count,1)) = sum(sumdelpidelvi)+x(measurementdata(count,1),1)*G(counter,counter);
       
                if measurementdata(count,1) ~= 1
       H(count,busnumber-1+measurementdata(count,1)) = sum(sumdelpidelthetai)-(x(measurementdata(count,1),1)^2)*B(measurementdata(count,1),measurementdata(count,1)); 
                end
    end 
    
    
    
   
    
end


