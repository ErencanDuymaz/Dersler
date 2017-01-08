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

%------------------Here Jacobian Construction Starts-------------------

%First part of the Jacobian matrix is derivatives of the measurement
%voltages with respect to state vectors 
%------------------
for count = 1:n_v
    H(count,measurementdata(count,1))= measurementdata(count,1);
    % derV=dela is assumed to be zero. Therefore, no further calculation is
    % made for neither for tap ratios nor for phase angles.
end
%------------------


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
    

% In the second part, power injection derivatives will be calculated based on G
% and B values which are calculated above by considering transformar taps.

%   delPi/delVi = sum ( Vj(Gij cos thetaij + Bij sin thetaij )+ Vi Gii

for count = n_v+1:n_v+n_pi
    
    %Vi = x(measurementdata(count,1),1)
    %Vj = x(measurementdata(count,2),1)
    
    %thetaij value is calculated as follows
          
    %thetaij = theta(count)-theta(counter)
    
    
    for counter = 1:busnumber
                  
     %   delPi/delVi = sum ( Vj(Gij cos thetaij + Bij sin thetaij )+ Vi Gii
           sumdelpidelvi(counter,1) = x(counter)*(G(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter))+B(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter)));
           
                
    
    %   delPi/delVj = Vi(Gij cos thetaij + Bij sin thetaij )
    
             H(count,counter) = x(measurementdata(count,1),1)*...
        (G(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter))+B(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter)));
    

    
    %   delPi/delthetai = sum ( ViVj(-Gij sinthetaij+Bij cos thetaij)) -Vi^2 Bii
    
            sumdelpidelthetai(counter,1) = x(counter)*x(measurementdata(count,1),1)*(-G(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter))+B(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter)));
        
    %   delPi/delthetaj = ViVj(Gij sin thetaij - Bij cos thetaij )  
        
                    if counter ~= 1
             H(count,busnumber+counter-1) = x(counter)*x(measurementdata(count,1),1)*...
        (G(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter))-B(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter)));    
                    end

       
       
       H(count,measurementdata(count,1)) = sum(sumdelpidelvi)+x(measurementdata(count,1),1)*G(counter,counter);
       
                if measurementdata(count,1) ~= 1
       H(count,busnumber-1+measurementdata(count,1)) = sum(sumdelpidelthetai)-(x(measurementdata(count,1),1)^2)*B(measurementdata(count,1),measurementdata(count,1)); 
                end
                
                

    end 
                 
    
    % If there exists a delPij/dela, the it is equal to delPi/delA.
    %Therefore, this addition will be solved in next parts.
    
    
    
end
% Here reactive power injection derivatives begins:

for count = n_v+n_pi+1:n_v+2*n_pi
    
    %Vi = x(measurementdata(count,1),1)
    %Vj = x(measurementdata(count,2),1)
    
    %thetaij value is calculated as follows
          
    %thetaij = theta(count)-theta(counter)
    
    
    for counter = 1:busnumber
                  
     %   delQi/delVi = sum ( Vj(Gij sin thetaij - Bij cos thetaij ) - Vi Bii
           sumdelqidelvi(counter,1) = x(counter)*(G(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter))-B(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter)));
           
                
    
    %   delQi/delVj = Vi(Gij sin thetaij - Bij cos thetaij )
    
             H(count,counter) = x(measurementdata(count,1),1)*...
        (G(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter))-B(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter)));
    
    %   delQi/delthetai = sum ( ViVj(Gij costhetaij+Bij sin thetaij)) -Vi^2 Gii
    
            sumdelqidelthetai(counter,1) = x(counter)*x(measurementdata(count,1),1)*(G(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter))+B(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter)));
        
    %   delQi/delthetaj = ViVj(-Gij cos thetaij - Bij sin thetaij )  
        
                    if counter ~= 1
             H(count,busnumber+counter-1) = x(counter)*x(measurementdata(count,1),1)*...
        (-G(measurementdata(count,1),counter)*cos(theta(measurementdata(count,1))-theta(counter))-B(measurementdata(count,1),counter)*sin(theta(measurementdata(count,1))-theta(counter)));    
                    end

       
       
       H(count,measurementdata(count,1)) = sum(sumdelqidelvi)-x(measurementdata(count,1),1)*B(measurementdata(count,1),measurementdata(count,1));
       
                if measurementdata(count,1) ~= 1
       H(count,busnumber-1+measurementdata(count,1)) = sum(sumdelqidelthetai)-(x(measurementdata(count,1),1)^2)*G(measurementdata(count,1),measurementdata(count,1)); 
                end
    end 
    
    
    
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
            
    % delPij/dela = (Vi*a)*(delPij/delVi)
   
    for counttap = 1:tapnumber
        if count2 == tappedbranches(counttap)


        H(count,2*busnumber-1+counttap) =H(count,measurementdata(count,1))* x(measurementdata(count,1))*x(2*busnumber-1+counttap);
        
    % How to calculate delPi/dela is as follows:
    % If there exists a delPij/dela, the it is equal to delPi/delA.
    
                for count3 = n_v+1:n_v+n_pi
                        if measurementdata(count,1) == measurementdata(count3,1)
        H(count3,2*busnumber-1+counttap) = H(count3,2*busnumber-1+counttap)+H(count,2*busnumber-1+counttap);
        
    
                        end
    
                        if measurementdata(count,2) == measurementdata(count3,1)
    
        H(count3,2*busnumber-1+counttap) = H(count3,2*busnumber-1+counttap)-H(count,2*busnumber-1+counttap);

     
                        end
  
    
    
                end
        end
    end
    
    
    
        
        end
                    if branchdata(count2,1) == 1
           
    
    % delPij/thetaj = -ViVj(gij sin theta(ij) - bij cos theta ij )     
            
     H(count,busnumber+measurementdata(count,2)-1) = (-1)* x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*sin(thetaij)-branchdata(count2,11)*cos(thetaij));
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
            
     for counttap = 1:tapnumber
         
        if count2 == tappedbranches(counttap)

        H(count,2*busnumber-1+counttap) =H(count,measurementdata(count,1))* x(measurementdata(count,1))*x(2*busnumber-1+counttap);

        
        % How to calculate delPi/dela is as follows:
        % If there exists a delPij/dela, the it is equal to delPi/delA.
    
                for count3 = n_v+n_pi+1:n_v+2*n_pi
                        if measurementdata(count,1) == measurementdata(count3,1)
        H(count3,2*busnumber-1+counttap) = H(count3,2*busnumber-1+counttap)+H(count,2*busnumber-1+counttap);
%         disp(H(count3,2*busnumber-1+tapnumber))
    
                        end
    
                        if measurementdata(count,2) == measurementdata(count3,1)
    
        H(count3,2*busnumber-1+counttap) = H(count3,2*busnumber-1+counttap)-H(count,2*busnumber-1+counttap);
%         disp(H(count3,2*busnumber-1+tapnumber))
                        end
  
    
    
                end
        end
        
        
        
     end
    
     
            if branchdata(count2,1) == 1
            

    
    % delQij/thetaj = ViVj(gij cos theta(ij) + bij sin theta ij )     
            
     H(count,busnumber+measurementdata(count,2)-1) = x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
         (branchdata(count2,10)*cos(thetaij)+branchdata(count2,11)*sin(thetaij));
            end
        end
    end
       
    
end 


% In this part, derivatives of current magnitudes are computed.

for count = n_v+2*n_pi+2*n_pf+1:n_v+2*n_pi+2*n_pf+n_c
    
  % Derivatives with respect to voltages and phase angles are made as follows:
  
  for counter = 1:branchnumber
  
      if (measurementdata(count,1) == branchdata(counter,1) && measurementdata(count,2) == branchdata(counter,2)) || ...
              (measurementdata(count,2) == branchdata(counter,1) && measurementdata(count,1) == branchdata(counter,2))
          
      %Pij= Vi^2(gsi+gij)-ViVj(gij cos theta ij + bij sin theta ij)
      
      Pij = (x(measurementdata(count,1),1)^2)*(branchdata(counter,10))-x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
          ((branchdata(counter,10)*cos(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
          sin((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1))));

      
      %Qij= -Vi^2(bsi+bij)-ViVj(gij sin theta ij + bij cos theta ij)
      Qij = -(x(measurementdata(count,1),1)^2)*(branchdata(counter,11))-x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
          ((branchdata(counter,10)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
          cos((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1))));
 
%       
      Iij = sqrt(Pij^2+Qij^2)/x(measurementdata(count,1),1);
            
      %delIij/delVi= ((gij+bij)^2)/Iij)*(Vi-Vj*cos(thetaij))
      
      
      H(count,measurementdata(count,1))=(((branchdata(counter,10)+branchdata(counter,11))^2)/Iij)*...
          (x(measurementdata(count,1),1)-x(measurementdata(count,2),1)*cos(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)));
      
%       disp(H(count,measurementdata(count,1)))
      
      %delIij/delVj= ((gij+bij)^2)/Iij)*(Vj-Vi*cos(thetaij))
      H(count,measurementdata(count,2))=(((branchdata(counter,10)+branchdata(counter,11))^2)/Iij)*...
          (x(measurementdata(count,2),1)-x(measurementdata(count,1),1)*cos(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)));
      
                if measurementdata(count,1) ~=1
      %delIij/delthetai= ((gij+bij)^2)/Iij)*(ViVj*sin(thetaij))
      
      H(count,measurementdata(count,1)+busnumber-1)=(((branchdata(counter,10)+branchdata(counter,11))^2)/Iij)*...
          (x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)));
                end
      
      
      %delIij/delthetaj= -((gij+bij)^2)/Iij)*(ViVj*sin(thetaij))
      
                if measurementdata(count,2) ~=1 
      H(count,measurementdata(count,2)+busnumber-1)=-(((branchdata(counter,10)+branchdata(counter,11))^2)/Iij)*...
          (x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)));
                end
      





% Same procedure will be calculated by using diff function in the
% subsection. If you use below part, select upper part as comment since
% they work on the same part of the Jacobian.
    
%       
% %        Pij= Vi^2(gsi+gij)-ViVj(gij cos theta ij + bij sin theta ij)
%        
%       syms Vi
%       
%       Pij = (Vi^2)*(branchdata(counter,10))-Vi*x(measurementdata(count,2),1)*...
%           ((branchdata(counter,10)*cos(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
%           sin((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1))));
% 
% %      %Qij= -Vi^2(bsi+bij)-ViVj(gij sin theta ij + bij cos theta ij)
% 
%       Qij = -1*(Vi^2)*(branchdata(counter,11))-Vi*x(measurementdata(count,2),1)*...
%           ((branchdata(counter,10)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
%           cos((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1))));
% 
%       Iij = sqrt(Pij^2+Qij^2)/Vi;
%       
%       delIijdelVi = diff(Iij,Vi);
%       
%       H(count,measurementdata(count,1)) = subs(delIijdelVi,Vi,x(measurementdata(count,1),1));
% 
% %             disp(H(count,measurementdata(count,1))) 
%             
%             
%             
%       %delIij/delVi= ((gij+bij)^2)/Iij)*(Vi-Vj*cos(thetaij))
%       
%       
%       H(count,measurementdata(count,1))=(((branchdata(counter,10)+branchdata(counter,11))^2)/Iij)*...
%           (x(measurementdata(count,1),1)-x(measurementdata(count,2),1)*cos(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)));
%       
%       
%       
%       %delIij/delVj= ((gij+bij)^2)/Iij)*(Vj-Vi*cos(thetaij))
%       
%              %Pij= Vi^2(gsi+gij)-ViVj(gij cos theta ij + bij sin theta ij)
%       syms Vj
%       Pij = (x(measurementdata(count,2),1)^2)*(branchdata(counter,10))-x(measurementdata(count,2),1)*Vj*...
%           ((branchdata(counter,10)*cos(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
%           sin((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1))));
% 
%       
%       %Qij= -Vi^2(bsi+bij)-ViVj(gij sin theta ij + bij cos theta ij)
%       Qij = -1*(x(measurementdata(count,2),1)^2)*(branchdata(counter,11))-x(measurementdata(count,2),1)*Vj*...
%           ((branchdata(counter,10)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
%           cos((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1))));
%       
%       Iij = sqrt(Pij^2+Qij^2)/x(measurementdata(count,1),1);
%       
%       delIijdelVj = diff(Iij,Vj);
%       
%       H(count,measurementdata(count,2)) = subs(delIijdelVj,Vj,x(measurementdata(count,2),1));
% 
% %            disp(H(count,measurementdata(count,2))) 
% 
%       
%       
%                 if measurementdata(count,1) ~=1
%                     
%       %delIij/delthetai= ((gij+bij)^2)/Iij)*(ViVj*sin(thetaij))
%            
%       
%       H(count,measurementdata(count,1)+busnumber-1)=(((branchdata(counter,10)+branchdata(counter,11))^2)/Iij)*...
%           (x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)));
%   
%                 end
%       
%       
%       %delIij/delthetaj= -((gij+bij)^2)/Iij)*(ViVj*sin(thetaij))
%       
%                 if measurementdata(count,2) ~=1 
%       H(count,measurementdata(count,2)+busnumber-1)=-(((branchdata(counter,10)+branchdata(counter,11))^2)/Iij)*...
%           (x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)));
%              disp(H(count,measurementdata(count,2)+busnumber-1))     
%                 end
%                 
%                
                
                
                               
%       Now, derivatives with respect to taps will be calculated.
      
                    for tapcounter = 1:tapnumber
                    
                        if counter ==tappedbranches(tapcounter)
                         
                        syms a
                        
                        %Pij= Vi^2(gsi+gij)/a^2 - ViVj(gij cos theta ij + bij sin theta ij)
                        
                Pij = ((x(measurementdata(count,1),1)^2)*(branchdata(counter,10)))/(a^2)-(x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
          ((branchdata(counter,10)*cos(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
          sin((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))))/a;        
                                                
                        %Qij= -Vi^2(bsi+bij)/a^2-ViVj(gij sin theta ij + bij cos theta ij)/a    
                        
                Qij = ((-x(measurementdata(count,1),1)^2)*(branchdata(counter,11)))/(a^2)-(x(measurementdata(count,1),1)*x(measurementdata(count,2),1)*...
          ((branchdata(counter,10)*sin(theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))+branchdata(counter,11)*...
          cos((theta(measurementdata(count,1),1)-theta(measurementdata(count,2),1)))))/a;
   
                Iij = sqrt(Pij^2+Qij^2)/x(measurementdata(count,1),1);
                dIij = diff(Iij,a);

                H(count,2*busnumber-1+tapcounter)=subs(dIij,a,x(measurementdata(count,1)));


                        end
                              
                    
                    end
 
      end
    
      
  end
    
 
    
    
end


% Now we can calculate our gain matrix. 

% First construct R^-1 matrix whose size is measurementnumberXmeasurementnumber
%From now on R^-1 will be called R

R = zeros(measurementnumber,measurementnumber);
for count = 1:n_v+2*n_pi
R(count,count)=measurementdata(count,3)^(-1);
end

for count = n_v+2*n_pi+1:n_v+2*n_pi+2*n_pf+n_c
R(count,count)=measurementdata(count,4)^(-1);
end

% Then G can be calculated by using H and R

Gain = H'*R*H;

% Now, it is time to decompose G to its lower and upper triangular forms

% For this purpose, Cholesky decomposition can be used.

L = chol(Gain,'lower');
U = L';
Gain2=L*U;


