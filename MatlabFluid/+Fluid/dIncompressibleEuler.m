function [dVel] = dIncompressibleEuler(Vel, Obs)
  
    Vel = Obstacles.applyObstacle(Obs,Vel);

    dV = Vel.grad();

    advect = dV.dot(Vel);
    lapP = advect.div();

    lapP = lapP.filter(50);

    P2 = Fluid.pressurePoisson(lapP,Obs);
    P2 = P2.filter(50);
    P2 = Obstacles.applyObstacle(Obs,P2);

    gradP2 = P2.grad();

    RHS = advect;

    RHS = Obstacles.applyObstacle(Obs,RHS);
    gradP2 = Obstacles.applyObstacle(Obs,gradP2);

    dVel = RHS.scale(-1) - gradP2;

end