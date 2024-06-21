function P = pressurePoisson(b,obs,niter)

if nargin<2
    obs.Q.Q = 1;
end

if nargin<3
    niter = 500;
end

dx = nanmean(diff(b.X(1,:)));
dy = nanmean(diff(b.Y(:,1)));

[nx, ny] = size(b.Q);

p = 0*b.Q;

i=2:nx-1;
j=2:ny-1;
%Explicit iterative scheme with C.D in space (5-point difference)
for it=1:niter
    pn=p;
    p(i,j)=((dy^2*(pn(i+1,j)+pn(i-1,j)))+(dx^2*(pn(i,j+1)+pn(i,j-1)))-(b.Q(i,j)*dx^2*dy*2))/(2*(dx^2+dy^2));
    %Boundary conditions 
    
    p = p.*obs.Q.Q;

    p(:,1)=p(:,2);
    p(:,ny)=p(:,ny-1);
    p(1,:)=p(2,:);                  
    p(nx,:)=p(nx-1,:);
    

    % p(:,1)=0;
    % p(:,ny)=0;
    % p(1,:)=0;                  
    % p(nx,:)=0;
end

P = b;

P.Q = p;

end