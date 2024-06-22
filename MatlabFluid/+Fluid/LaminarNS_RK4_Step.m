function [R,Mom,E] = LaminarNS_RK4_Step(R,Mom,E,gamma,mu,D,dt)

[R1,Mom1,E1] = Fluid.dLaminarNSStep(R,Mom,E,gamma,mu,D,dt);

[R2,Mom2,E2] = Fluid.dLaminarNSStep(R+R1.scale(0.5*dt),Mom+Mom1.scale(0.5*dt),E+E1.scale(0.5*dt),gamma,mu,D,dt);

[R3,Mom3,E3] = Fluid.dLaminarNSStep(R+R2.scale(0.5*dt),Mom+Mom2.scale(0.5*dt),E+E2.scale(0.5*dt),gamma,mu,D,dt);

[R4,Mom4,E4] = Fluid.dLaminarNSStep(R+R3.scale(dt),Mom+Mom3.scale(dt),E+E3.scale(dt),gamma,mu,D,dt);

RT = R1 + R2 + R3 + R4;
RT = RT.scale(dt/6);
R = R + RT;

MomT = Mom1 + Mom2 + Mom3 + Mom4;
MomT = MomT.scale(dt/6);
Mom = Mom + MomT;

ET = E1 + E2 + E3 + E4;
ET = ET.scale(dt/6);
E = E + ET;
end