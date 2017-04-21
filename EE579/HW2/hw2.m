clear all
clc
%Solution of Question 1
%Givens:
%F1(P1)=2200+25*P1+0.025*P1^2
%F2(P2)=1500+11*P2+0.02*P2^2
%Ploss=0.0002*P1^2+0.0001*P2^2
%Constraints:

%Pload+Ploss-(P1+P2)=phi=0
%220<=P1=>600
%350<=P2=>800
%Ploss=0.0002*P1^2+0.0001*P2^2 

%We need to perform economic dispatch for a load of 1000 MW starting from
%P1=500 MW & P2=500 MW 

P_1=500;
P_2=500;
Pload=1000;
%What we need to utilize is:
% delFi/delPi = lambda*(1-delPloss/delPi)

for k = 1:50
    
%Calculate the loss:
Ploss = 0.0002*P_1^2+0.0001*P_2^2;

delPloss_delP1=0.0004*P_1;
delPloss_delP2=0.0002*P_2;

%Solve linear derivative equations by using matrices (Ax=B and x = A-1*B) and found P1,P2 and Lambda 
sol =  inv([0.05 , 0 , (delPloss_delP1-1) ; 0, 0.04 , (delPloss_delP2-1); 1 , 1, 0 ]) *[ -25 ; -11 ; Pload+Ploss ];

%Update the P1 and P2
if abs(P_1 -sol(1,1))<1
   P_1= sol(1,1);
   P_2=sol(2,1);
   Lambda = sol(3,1);
   break;
end 
P_1= sol(1,1);
P_2=sol(2,1);
Lambda = sol(3,1);
end 
FT1= 2200+25*P_1+0.025*P_1^2;
FT2=1500+11*P_2+0.02*P_2^2;
formatSpec = 'Incremental Losses:%4.2f and %4.2f \nTotal Loss:%4.2f MW \nP1 and P2:%4.2f MW,%4.2f MW\n...Total Cost of P1:%4.2f $/MWh\nTotal Cost of P2:%4.2f $/MWh';
fprintf(formatSpec,delPloss_delP1,delPloss_delP2,Ploss,P_1,P_2,FT1,FT2)

