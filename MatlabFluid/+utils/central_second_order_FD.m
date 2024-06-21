function [dF] = central_second_order_FD(F,dx)

n = length(F);

dF = F;

for i = 2:n-1
    dF(i) =  (F(i+1) - F(i-1))/dx;
end

dF(1) = (-3*F(1) + 4*F(2) - F(3))/(2*dx);
dF(n) = (3*F(n) - 4*F(n-1) + F(n-2))/(2*dx);

end