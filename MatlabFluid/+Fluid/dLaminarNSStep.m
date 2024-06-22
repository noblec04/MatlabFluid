function [dR,dMom,dE] = dLaminarNSStep(R,Mom,E,gamma,mu,D,dt)

    gradR = R.grad();
    gradR = gradR.scale(D);

    dR = Mom - gradR;
    dR = dR.div();

    Vel = Mom./R;

    divVel = Vel.div();
    divVel = divVel.scale((2/3)*mu);

    gradVel = Vel.grad();

    S = gradVel + gradVel';
    S = S.scale(mu);

    tau = S - divVel;

    Vmag = Vel.dot(Vel);
    Vmag = Vmag.scale(0.5*(gamma-1));

    P = E.scale(gamma - 1) - R*Vmag;

    dMom = Mom*Vel;
    dMom = dMom + P;
    dMom = dMom - tau;
    dMom = dMom.div();

    dE = E+P;
    dE = Vel.scale(dE);

    tauU = tau.dot(Vel);

    dE = dE + tauU;
    dE = dE.div();

    dE = dE.filter(10^5);
    dR = dR.filter(10^5);
    dMom = dMom.filter(10^5);

    % dE = dE.scale(dt);
    % dR = dR.scale(dt);
    % dMom = dMom.scale(dt);

end