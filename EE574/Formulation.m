% In this file, some formulations will be created with the help of MATLAB

syms Vi Vj gij gsi thetai thetaj bij bsi a

thetaij =thetai-thetaj;
Pij = (Vi^2)*(gij*((1-a)/(a^2))+gij/a) - (Vi*Vj*(gij*cos(thetaij)+bij*sin(thetaij)))/a;

Qij = -(Vi^2)*(bij*((1-a)/(a^2))+bij/a) - (Vi*Vj*(gij*sin(thetaij)-bij*cos(thetaij)))/a;

Iij = sqrt(Pij^2+Qij^2)/Vi;

A = diff(Iij,a)
B = diff(Iij,Vi)
C = diff(Iij,Vj)
D = diff(Iij,thetai)
E = diff(Iij,thetaj)

