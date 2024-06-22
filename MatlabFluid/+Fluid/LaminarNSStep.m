function [R,Mom,E] = LaminarNSStep(R,Mom,E,gamma,mu,D,dt)

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

    E = E - dE.scale(dt);
    R = R - dR.scale(dt);
    Mom = Mom - dMom.scale(dt);

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

end