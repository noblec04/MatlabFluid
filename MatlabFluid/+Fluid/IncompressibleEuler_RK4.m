function [Vel] = IncompressibleEuler_RK4(Vel, Obs, dt)

[Vel1] = Fluid.dIncompressibleEuler(Vel, Obs);

[Vel2] = Fluid.dIncompressibleEuler(Vel+Vel1.scale(0.5*dt), Obs);

[Vel3] = Fluid.dIncompressibleEuler(Vel+Vel2.scale(0.5*dt), Obs);

[Vel4] = Fluid.dIncompressibleEuler(Vel+Vel3.scale(dt), Obs);

VelT = Vel1 + Vel2 + Vel3 + Vel4;
VelT = VelT.scale(dt/6);
Vel = Vel + VelT;

Vel = Obstacles.applyObstacle(Obs,Vel);

end