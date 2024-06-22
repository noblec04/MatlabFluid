
clear
close all
clc

[X,Y] = meshgrid(linspace(0,1,64),linspace(0,1,64));

rho0 = 3;
gamma = 1.6;

mu = 1*10^(-3);
D = 1*10^(-3);

Z1 = 5*cos(12*X).*sin(13*Y - 5*X.*Y);
Z2 = 6*cos(13*Y).*sin(12*X - 5*Y);

rU = Grids.grid(rho0*Z1,[0 0],[1 1],1);
rV = Grids.grid(rho0*Z2,[0 0],[1 1],1);

dx = nanmean(diff(rU.X(1,:)));
dy = nanmean(diff(rU.Y(:,1)));

dt = 0.1*min(dy,dx)/10;

R = Grids.grid(0.01*Z1 + rho0,[0 0],[1 1],1);
Mom = Grids.vectorGrid();

Mom.Q{1} = rU;
Mom.Q{2} = rV;

E = Mom.mag();

E = E./R;

E = E.scale(0.5);


for jj = 1:300

    %[R,Mom,E] = Fluid.LaminarNSStep(R,Mom,E,gamma,mu,D,dt);

    [R,Mom,E] = Fluid.LaminarNS_RK4_Step(R,Mom,E,gamma,mu,D,dt);

    Mom.Q{1}.Q(1,:) = Mom.Q{1}.Q(2,:);
    Mom.Q{1}.Q(end,:) = Mom.Q{1}.Q(end-1,:);
    Mom.Q{1}.Q(:,1) = Mom.Q{1}.Q(:,2);
    Mom.Q{1}.Q(:,end) = Mom.Q{1}.Q(:,end-1);

    Mom.Q{2}.Q(1,:) = Mom.Q{2}.Q(2,:);
    Mom.Q{2}.Q(end,:) = Mom.Q{2}.Q(end-1,:);
    Mom.Q{2}.Q(:,1) = Mom.Q{2}.Q(:,2);
    Mom.Q{2}.Q(:,end) = Mom.Q{2}.Q(:,end-1);

    E.Q(1,:) = E.Q(2,:);
    E.Q(end,:) = E.Q(end-1,:);
    E.Q(:,1) = E.Q(:,2);
    E.Q(:,end) = E.Q(:,end-1);

    R.Q(1,:) = R.Q(2,:);
    R.Q(end,:) = R.Q(end-1,:);
    R.Q(:,1) = R.Q(:,2);
    R.Q(:,end) = R.Q(:,end-1);

    R = R.filter(20);
    E = E.filter(200);
    Mom = Mom.filter(40);

    figure(1)
    clf(1)
    Mom.pcolor()
    
end