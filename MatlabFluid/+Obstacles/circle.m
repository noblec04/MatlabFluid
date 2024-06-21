classdef circle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Q
    end

    methods
        function obj = circle(domain,x,y,radius)
            obj.Q = domain;

            obj.Q.Q = obj.Q.Q*0 + 1;

            X = obj.Q.X;
            Y = obj.Q.Y;

            R = (X - x).^2 + (Y-y).^2;

            obj.Q.Q(R<=radius) = 0;

        end

        function Q = mtimes(obj,Q)

            Q1 = Q.at(obj.Q);

            Q = obj.Q*Q;
            
        end
    end
end