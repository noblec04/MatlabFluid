classdef square
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Q
    end

    methods
        function obj = square(domain,x,y,xl,yl)
            obj.Q = domain;

            obj.Q.Q = obj.Q.Q*0 + 1;

            X = obj.Q.X;
            Y = obj.Q.Y;

            R = (X-x)<xl & (X-x)>-xl & (Y-y)<yl & (Y-y)>-yl ;

            obj.Q.Q(R) = 0;

        end

        function Q = mtimes(obj,Q)

            Q1 = Q.at(obj.Q);

            Q = obj.Q*Q;
            
        end
    end
end