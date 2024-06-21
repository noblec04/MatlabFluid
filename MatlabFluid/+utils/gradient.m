function [dudy,dudx] = gradient(u,x,y)

[ny,nx] = size(u);

for i = 1:ny
    dudx(i,:) = utils.lele_6(squeeze(u(i,:)),x);
end

for i = 1:nx
    dudy(:,i) = utils.lele_6(squeeze(u(:,i)),y);
end

%{
for i = 1:ny
    dudx(i,:) = utils.forward_second_order_FD(squeeze(u(i,:)),x);
end

for i = 1:nx
    dudy(:,i) = utils.forward_second_order_FD(squeeze(u(:,i)),y);
end
%}

end