classdef vectorGrid
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Q
    end

    methods
        function obj = vectorGrid(Qs,lb,ub,type)

            if nargin~=0
                nQ = numel(Qs);

                for i = 1:nQ
                    obj.Q{i} = Grids.grid(Qs{i},lb,ub,type);
                end
            end

        end

        function obj = at(obj,G)
            
            [n1] = numel(obj.Q);

            for i = 1:n1
                obj.Q{i} = obj.Q{i}.at(G);  
            end

        end

        function pcolor(obj)
            nQ = numel(obj.Q);

            for i = 1:nQ
                subplot(1,nQ,i)
                pcolor(obj.Q{i}.X,obj.Q{i}.Y,obj.Q{i}.Q);
                shading flat
                axis equal
                axis tight
                box on
            end
        end

        function obj = filter(obj,lim)

            [n1] = numel(obj.Q);

            for i = 1:n1
                obj.Q{i}= obj.Q{i}.filter(lim);  
            end
            
        end

        function obj = scale(obj,S)
            

            [n1] = numel(obj.Q);

            try
            for i = 1:n1
                obj.Q{i}.Q = S*obj.Q{i}.Q;  
            end
            catch
            for i = 1:n1
                obj.Q{i} = S*obj.Q{i};  
            end
            end

        end

        function S = mag(obj)
            
            nQ = numel(obj.Q);

            S = obj.Q{1};

            A = 0*obj.Q{1}.Q;

            for i = 1:nQ
                A = A + obj.Q{i}.Q.^2;
            end

            S.Q = A;

        end

        function V2 = plus(obj,V)

            nQ = numel(obj.Q);

            V2 = obj;

            try
                for i = 1:nQ
                    V2.Q{i} = obj.Q{i}+V.Q{i};
                end
            catch
                for i = 1:nQ
                    V2.Q{i} = obj.Q{i}+V;
                end
            end

        end

        function V2 = minus(obj,V)

            nQ = numel(obj.Q);

            V2 = V;

            for i = 1:nQ
                V2.Q{i} = obj.Q{i}-V.Q{i};
            end

        end

        function S = dot(obj,V)

            nQ = numel(obj.Q);

            S = obj.Q{1}*V.Q{1};

            for i = 2:nQ
                S = S+obj.Q{i}*V.Q{i};
            end

        end

        function obj = shift(obj,V)

            [n1] = numel(obj.Q);

            for i = 1:n1
                
                obj.Q{i} = obj.Q{i}.shift(V);  

            end

        end

        function S = cross(obj,V)

            S = obj.Q{1}*V.Q{2} - obj.Q{2}*V.Q{1};

        end

        function S = curl(obj)
            
            [dQ1] = obj.Q{1}.grad();
            [dQ2] = obj.Q{2}.grad();
            
            S = dQ2.Q{1} - dQ1.Q{2};

        end

        function S = div(obj)
            
            [dQ1] = obj.Q{1}.grad();
            [dQ2] = obj.Q{2}.grad();
            
            S = dQ1.Q{1} + dQ2.Q{2};

        end

        function M = grad(obj)
            
            [dQ1] = obj.Q{1}.grad();
            [dQ2] = obj.Q{2}.grad();

            M = Grids.matrixGrid();

            M.Q{1,1} = dQ1.Q{1};
            M.Q{1,2} = dQ1.Q{2};
            M.Q{2,1} = dQ2.Q{1};
            M.Q{2,2} = dQ2.Q{2};

        end

        function V = laplace(obj)

            M = obj.grad();
            V = M.div();

        end

        function S = mtimes(obj,Q)

            S = Grids.matrixGrid();

            S.Q{1,1} = obj.Q{1}*Q.Q{1};
            S.Q{1,2} = obj.Q{1}*Q.Q{2};
            S.Q{2,1} = obj.Q{2}*Q.Q{1};
            S.Q{2,2} = obj.Q{2}*Q.Q{2};
            
        end

        function obj = rdivide(obj,S)

            [n1] = numel(obj.Q);

            for i = 1:n1
                
                obj.Q{i} = obj.Q{i}./S;  

            end

        end
    end
end