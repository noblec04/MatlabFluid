
clear 
close all
clc

[X,Y] = meshgrid(linspace(0,1,20),linspace(0,0.5,25));
Z1 = X.^2 + X.*cos(5*Y);
Z2 = X.*Y + Y.*cos(5*X);

Q1 = Grids.grid(Z1,[0 0],[1 0.5],1);
Q2 = Grids.grid(Z2,[0 0],[1 0.5],2);

Q3 = Q1.at(Q2);

figure
Q1.pcolor()

figure
Q2.pcolor()

figure
Q3.pcolor()

Q4 = Q1*Q2;

figure
Q4.pcolor()

tic
Q5 = Q4.grad();
toc

figure()
Q5.pcolor()

%%

Zs{1} = Z1;
Zs{2} = Z2;

Qv1 = Grids.vectorGrid(Zs,[0 0],[1 0.5],1);

Qs1 = Qv1.dot(Qv1);

figure
Qs1.pcolor()

figure
Qv1.pcolor()

%%

Qm1 = Qv1.grad()

figure
Qm1.pcolor()

%%

Qv2 = Qm1.dot(Qv1);

figure
Qv2.pcolor()