% In this file, some formulations will be created with the help of MATLAB

syms Vi_value Vj_value gijtemp gsi thetai thetaj bijtemp bsi a

thetaij =thetai-thetaj;
Pij = (Vi_value^2)*(gijtemp*((1-a)/(a^2))+gijtemp/a) - (Vi_value*Vj_value*(gijtemp*cos(thetaij)+bijtemp*sin(thetaij)))/a;

Qij = -(Vi_value^2)*(bijtemp*((1-a)/(a^2))+bijtemp/a) - (Vi_value*Vj_value*(gijtemp*sin(thetaij)-bijtemp*cos(thetaij)))/a;

Iij = sqrt(Pij^2+Qij^2)/Vi_value;

A = diff(Iij,a)
B = diff(Iij,Vi_value)
C = diff(Iij,Vj_value)
D = diff(Iij,thetai)
E = diff(Iij,thetaj)

A =
 
-(2*((bij/a - (bij*(a - 1))/a^2)*Vi^2 - (Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*Vi)/a)*(Vi^2*((2*bij)/a^2 - (2*bij*(a - 1))/a^3) - (Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj)))/a^2) + 2*((gij/a - (gij*(a - 1))/a^2)*Vi^2 - (Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*Vi)/a)*(Vi^2*((2*gij)/a^2 - (2*gij*(a - 1))/a^3) - (Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj)))/a^2))/(2*Vi*((Vi^2*(bij/a - (bij*(a - 1))/a^2) - (Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj)))/a)^2 + (Vi^2*(gij/a - (gij*(a - 1))/a^2) - (Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj)))/a)^2)^(1/2))
 
 
B =
 
(2*((bij/a - (bij*(a - 1))/a^2)*Vi^2 - (Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*Vi)/a)*(2*Vi*(bij/a - (bij*(a - 1))/a^2) - (Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj)))/a) + 2*((gij/a - (gij*(a - 1))/a^2)*Vi^2 - (Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*Vi)/a)*(2*Vi*(gij/a - (gij*(a - 1))/a^2) - (Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj)))/a))/(2*Vi*((Vi^2*(bij/a - (bij*(a - 1))/a^2) - (Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj)))/a)^2 + (Vi^2*(gij/a - (gij*(a - 1))/a^2) - (Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj)))/a)^2)^(1/2)) - (((bij/a - (bij*(a - 1))/a^2)*Vi^2 - (Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*Vi)/a)^2 + ((gij/a - (gij*(a - 1))/a^2)*Vi^2 - (Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*Vi)/a)^2)^(1/2)/Vi^2
 
 
C =
 
-((2*Vi*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*((gij/a - (gij*(a - 1))/a^2)*Vi^2 - (Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*Vi)/a))/a + (2*Vi*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*((bij/a - (bij*(a - 1))/a^2)*Vi^2 - (Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*Vi)/a))/a)/(2*Vi*((Vi^2*(bij/a - (bij*(a - 1))/a^2) - (Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj)))/a)^2 + (Vi^2*(gij/a - (gij*(a - 1))/a^2) - (Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj)))/a)^2)^(1/2))
 
 
D =
 
((2*Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*((bij/a - (bij*(a - 1))/a^2)*Vi^2 - (Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*Vi)/a))/a - (2*Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*((gij/a - (gij*(a - 1))/a^2)*Vi^2 - (Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*Vi)/a))/a)/(2*Vi*((Vi^2*(bij/a - (bij*(a - 1))/a^2) - (Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj)))/a)^2 + (Vi^2*(gij/a - (gij*(a - 1))/a^2) - (Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj)))/a)^2)^(1/2))
 
 
E =
 
-((2*Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*((bij/a - (bij*(a - 1))/a^2)*Vi^2 - (Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*Vi)/a))/a - (2*Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj))*((gij/a - (gij*(a - 1))/a^2)*Vi^2 - (Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj))*Vi)/a))/a)/(2*Vi*((Vi^2*(bij/a - (bij*(a - 1))/a^2) - (Vi*Vj*(bij*cos(thetai - thetaj) - gij*sin(thetai - thetaj)))/a)^2 + (Vi^2*(gij/a - (gij*(a - 1))/a^2) - (Vi*Vj*(gij*cos(thetai - thetaj) + bij*sin(thetai - thetaj)))/a)^2)^(1/2))
 
yunuz
 
A =
 
-(2*((bijtemp/a - (bijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*Vi_value)/a)*(Vi_value^2*((2*bijtemp)/a^2 - (2*bijtemp*(a - 1))/a^3) - (Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj)))/a^2) + 2*((gijtemp/a - (gijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*Vi_value)/a)*(Vi_value^2*((2*gijtemp)/a^2 - (2*gijtemp*(a - 1))/a^3) - (Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj)))/a^2))/(2*Vi_value*((Vi_value^2*(bijtemp/a - (bijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj)))/a)^2 + (Vi_value^2*(gijtemp/a - (gijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj)))/a)^2)^(1/2))
 
 
B =
 
(2*((bijtemp/a - (bijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*Vi_value)/a)*(2*Vi_value*(bijtemp/a - (bijtemp*(a - 1))/a^2) - (Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj)))/a) + 2*((gijtemp/a - (gijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*Vi_value)/a)*(2*Vi_value*(gijtemp/a - (gijtemp*(a - 1))/a^2) - (Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj)))/a))/(2*Vi_value*((Vi_value^2*(bijtemp/a - (bijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj)))/a)^2 + (Vi_value^2*(gijtemp/a - (gijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj)))/a)^2)^(1/2)) - (((bijtemp/a - (bijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*Vi_value)/a)^2 + ((gijtemp/a - (gijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*Vi_value)/a)^2)^(1/2)/Vi_value^2
 
 
C =
 
-((2*Vi_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*((gijtemp/a - (gijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*Vi_value)/a))/a + (2*Vi_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*((bijtemp/a - (bijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*Vi_value)/a))/a)/(2*Vi_value*((Vi_value^2*(bijtemp/a - (bijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj)))/a)^2 + (Vi_value^2*(gijtemp/a - (gijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj)))/a)^2)^(1/2))
 
 
D =
 
((2*Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*((bijtemp/a - (bijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*Vi_value)/a))/a - (2*Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*((gijtemp/a - (gijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*Vi_value)/a))/a)/(2*Vi_value*((Vi_value^2*(bijtemp/a - (bijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj)))/a)^2 + (Vi_value^2*(gijtemp/a - (gijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj)))/a)^2)^(1/2))
 
 
E =
 
-((2*Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*((bijtemp/a - (bijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*Vi_value)/a))/a - (2*Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj))*((gijtemp/a - (gijtemp*(a - 1))/a^2)*Vi_value^2 - (Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj))*Vi_value)/a))/a)/(2*Vi_value*((Vi_value^2*(bijtemp/a - (bijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(bijtemp*cos(thetai - thetaj) - gijtemp*sin(thetai - thetaj)))/a)^2 + (Vi_value^2*(gijtemp/a - (gijtemp*(a - 1))/a^2) - (Vi_value*Vj_value*(gijtemp*cos(thetai - thetaj) + bijtemp*sin(thetai - thetaj)))/a)^2)^(1/2))
 
