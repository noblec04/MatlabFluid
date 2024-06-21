function G = applyObstacle(Obstacle,G)

if iscell(G.Q)
    [n1, n2] = size(G.Q);

    for i = 1:n1
        for j = 1:n2
            G.Q{i,j} = Obstacle*G.Q{i,j};
        end
    end

else
    G = Obstacle*G;
end

end