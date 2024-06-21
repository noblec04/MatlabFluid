

clear
close all
clc

[X,Y] = meshgrid(linspace(0,1,64),linspace(0,0.5,64));

Z1 = 100 - (100-80)*(1-4*(Y-0.25).^2).*X;
Z2 = 0*X;

Domain = Grids.grid(0*Z1 + 1,[0 0],[1 0.5],1);

U = Grids.grid(Z1,[0 0],[1 0.5],1);
V = Grids.grid(Z2,[0 0],[1 0.5],1);

dx = nanmean(diff(U.X(1,:)));
dy = nanmean(diff(U.Y(:,1)));

dt = 0.8*min(dy,dx)/100;

%Obs = Obstacles.circle(Domain,0.2,0.25,0.005);
Obs = Obstacles.square(Domain,0.2,0.25,0.05,0.05);

Vel = Grids.vectorGrid();

Vel.Q{1} = U;
Vel.Q{2} = V;



for jj = 1:300

    
    Vel = Vel.filter(120);
    
    Vel = Obstacles.applyObstacle(Obs,Vel);

    dV = Vel.grad();

    advect = dV.dot(Vel);
    lapP = advect.div();

    lapP = lapP.filter(50);

    P2 = Fluid.pressurePoisson(lapP,Obs);
    P2 = P2.filter(50);
    P2 = Obstacles.applyObstacle(Obs,P2);

    gradP2 = P2.grad();

    RHS = advect.scale(dt);

    RHS = Obstacles.applyObstacle(Obs,RHS);
    gradP2 = Obstacles.applyObstacle(Obs,gradP2);

    Vel2 = Vel - RHS;
    Vel = Vel2 - gradP2.scale(dt);

    Vel.Q{1}.Q(:,1) = 100 + 20*sin(100*Y(:,1));
    Vel.Q{1}.Q(:,end) = Vel.Q{1}.Q(:,end-1);
    Vel.Q{1}.Q(1,:) = 0;
    Vel.Q{1}.Q(end,:) = 0;

    Vel.Q{2}.Q(:,1) = 5*cos(100*Y(:,1));
    Vel.Q{2}.Q(:,end) = Vel.Q{2}.Q(:,end-1);
    Vel.Q{2}.Q(1,:) = 0;
    Vel.Q{2}.Q(end,:) = 0;

    vort = Vel.curl();
    vort = Obstacles.applyObstacle(Obs,vort);

    figure(1)
    clf(1)
    Vel.pcolor()
    colorbar

    figure(2)
    clf(2)
    vort.pcolor()
    colorbar

    drawnow
    pause(0.001)
end