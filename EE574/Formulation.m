% In this file, some formulations will be created with the help of MATLAB

syms Vi Vj gij gsi Ti Tj bij bsi a

thetaij =Ti-Tj;
Pij = - (Vi*Vj*(bij*sin(thetaij)))/a;

Qij = -(Vi^2)*(bij*((1-a)/(a^2))+bij/a) - (Vi*Vj*(-bij*cos(thetaij)))/a;

Iij = sqrt(Pij^2+Qij^2)/Vi;

A = diff(Iij,a)
B = diff(Iij,Vi)
C = diff(Iij,Vj)
D = diff(Iij,thetai)
E = diff(Iij,thetaj)

