function [dF] = forward_second_order_FD(F,dx)

n = length(F);

dF = F;

for i = 1:n-2
    dF(i) =  (-3*F(i) + 4*F(i+1) - F(i+2))/(2*dx);
end

dF(n-1) =  (F(n) - F(n-2))/dx;
dF(n) = (3*F(n) - 4*F(n-1) + F(n-2))/(2*dx);

end