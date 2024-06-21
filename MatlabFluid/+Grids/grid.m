classdef grid
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        X
        Y
        Q
    end

    methods
        function obj = grid(Q,lb,ub,type)

            [ny,nx] = size(Q);

           switch type
               case 1
                    
                    xx = linspace(lb(1),ub(1),nx);
                    yy = linspace(lb(2),ub(2),ny);

                    [obj.X, obj.Y]= meshgrid(xx,yy);

                    obj.Q = Q;

               case 2

                   range = ub-lb;

                    xx = linspace(lb(1),ub(1),nx);
                    yy = linspace(lb(2),ub(2),ny);

                    [X1, Y1]= meshgrid(xx,yy);

                    xx = linspace(lb(1)-0.5*range(1)/nx,ub(1)+0.5*range(1)/nx,nx+2);
                    yy = linspace(lb(2)-0.5*range(2)/ny,ub(2)+0.5*range(2)/ny,ny+2);

                    [obj.X, obj.Y]= meshgrid(xx,yy);

                    F = griddedInterpolant(X1',Y1',Q');
                    
                    obj.Q = F(obj.X',obj.Y')';

           end
        end

        function obj = at(obj,G)
            
            F = griddedInterpolant(obj.X',obj.Y',obj.Q');

            obj.X = G.X;
            obj.Y = G.Y;
            obj.Q = F(G.X',G.Y')';

        end

        function obj = shift(obj,V)

            F = griddedInterpolant(obj.X',obj.Y',obj.Q');

            obj.X = obj.X + V.Q{1};
            obj.Y = obj.Y + V.Q{2};
            obj.Q = F(obj.X',obj.Y')';

        end

        function obj = filter(obj,lim)

            obj.Q(obj.Q>lim) = lim;
            obj.Q(obj.Q<-lim) = -lim;
            obj.Q = imgaussfilt(obj.Q,0.8);
            
        end

        function pcolor(obj)

            pcolor(obj.X,obj.Y,obj.Q);
            shading flat
            axis equal
            axis tight
            box on

        end

        function V = grad(obj)

            dx = nanmean(diff(obj.X(1,:)));
            dy = nanmean(diff(obj.Y(:,1)));

            [dQy,dQx] = utils.gradient(obj.Q,dy,dx);

            Q1 = obj;
            Q2 = obj;

            V = Grids.vectorGrid();

            V.Q{1} = Q1;
            V.Q{2} = Q2;

            V.Q{1}.Q = dQx;
            V.Q{2}.Q = dQy;

        end

        function obj = plus(obj,Q)

            Q1 = Q.at(obj);

            obj.Q = obj.Q + Q1.Q;

        end

        function S = laplace(obj)

            V = obj.grad();
            S = V.div();

        end

        function obj = minus(obj,Q)

            Q1 = Q.at(obj);

            obj.Q = obj.Q - Q1.Q;

        end

        function obj = rdivide(obj,Q)

            Q1 = Q.at(obj);

            obj.Q = obj.Q./Q1.Q;

            obj.Q(Q1.Q==0)=0;

        end

        function obj = mtimes(obj,Q)

            Q1 = Q.at(obj);

            obj.Q = obj.Q.*Q1.Q;
            
        end

    end
end