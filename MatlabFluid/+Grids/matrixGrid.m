classdef matrixGrid
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Q

    end

    methods
        function obj = matrixGrid(Qs,lb,ub,type)
            
            if nargin~=0
                [n1, n2] = size(Qs);

                for i = 1:n1
                    for j = 1:n2
                        obj.Q{i,j} = Grids.grid(Qs{i,j},lb,ub,type);
                    end
                end
            end

        end

        function pcolor(obj)
            

            [n1, n2] = size(obj.Q);

            nn=0;
            for i = 1:n1
                for j = 1:n2
                    nn = nn+1;
                    subplot(n1,n2,nn)
                    pcolor(obj.Q{i,j}.X,obj.Q{i,j}.Y,obj.Q{i,j}.Q);
                    shading flat
                    axis equal
                    axis tight
                    box on
                end
            end

        end

        function obj = at(obj,G)
            
            [n1, n2] = size(obj.Q);

            for i = 1:n1
                for j = 1:n2

                    obj.Q{i,j} = obj.Q{i,j}.at(G);  

                end
            end

        end

        function obj = scale(obj,S)
            

            [n1, n2] = size(obj.Q);

            for i = 1:n1
                for j = 1:n2

                    obj.Q{i,j}.Q = S*obj.Q{i,j}.Q;  

                end
            end

        end

        function obj = filter(obj,lim)

            [n1, n2] = size(obj.Q);

            for i = 1:n1
                for j = 1:n2

                    obj.Q{i,j} = obj.Q{i,j}.filter(lim);  

                end
            end
            
        end

        function V1 = dot(obj,V)

            V1 = V;

            V1.Q{1} = obj.Q{1,1}*V.Q{1} + obj.Q{1,2}*V.Q{2};
            V1.Q{2} = obj.Q{2,1}*V.Q{1} + obj.Q{2,2}*V.Q{2};

        end

        function V = div(obj)

            [dQ11] = obj.Q{1,1}.grad();
            [dQ12] = obj.Q{1,2}.grad();
            [dQ21] = obj.Q{2,1}.grad();
            [dQ22] = obj.Q{2,2}.grad();

            V = Grids.vectorGrid();

            V.Q{1} = dQ11.Q{1} + dQ21.Q{2};
            V.Q{2} = dQ12.Q{1} + dQ22.Q{2};

        end

        function obj = shift(obj,V)

            [n1, n2] = size(obj.Q);

            for i = 1:n1
                for j = 1:n2

                    obj.Q{i,j}.Q = obj.Q{i,j}.Q.shift(V);  

                end
            end

        end

        function A = ctranspose(obj)

            [n1, n2] = size(obj.Q);

            A = obj;

            for i = 1:n1
                for j = 1:n2

                    A.Q{i,j} = obj.Q{j,i};  

                end
            end

        end

        function M2 = plus(obj, M)

            [n1, n2] = size(obj.Q);

            M2 = obj;

            try
            for i = 1:n1
                for j = 1:n2

                    M2.Q{i,j} = obj.Q{i,j} + M.Q{i,j};  

                end
            end

            catch
                for i = 1:n1
                    for j = 1:n2

                        M2.Q{i,j} = obj.Q{i,j} + M;

                    end
                end
            end

        end

        function M2 = minus(obj, S)

            [n1, n2] = size(obj.Q);

            M2 = obj;

            try
                for i = 1:n1
                    for j = 1:n2

                        M2.Q{i,j} = obj.Q{i,j} - S;

                    end
                end
            catch

                for i = 1:n1
                    for j = 1:n2

                        M2.Q{i,j} = obj.Q{i,j} - S.Q{i,j};

                    end
                end
            end

        end

    end
end