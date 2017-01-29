clear all
%% Topology Setup
% Number of nodes in network N
N = 10;
%Lets pick a source S and destination T
S = randi([1,N]);
T = randi([1,N]);

% Topology is stored in link_cost
link_cost = Inf(N,N);
% link_conn will store 1/0 depending if direct connection between two nodes
%is present or absent
link_conn = randi([0 1],N,N);
%In matrix form, to get a distance for a particular link(i,j); please check
%row i and column j in the matrix
%Number of links in network L
L = sum(sum(link_conn));

link_prob_loss = ones(N,N);
max_cost_for_direct_link = 20;
min_cost_for_direct_link = 0;
%assuming cost of a link is between min_cost_for_direct_link and 
%max_cost_for_direct_link and rest all will be set to
%Infinity which would imply no direct link
for i=1:N
    for j=1:N
        if i==j
            link_conn(i,j) = 1;
            link_cost(i,j) = 0;
            link_prob_loss(i,j) = 0;
        elseif link_conn(i,j) == 1
            link_cost(i,j) = randi([min_cost_for_direct_link ...
            max_cost_for_direct_link]);
            link_prob_loss(i,j) = rand();
        end
    end
end

%% Compute effective cost on all directly connected links
link_eff_cost = link_cost ./(1-link_prob_loss);
% Distance vector D(N)
D = Inf(1,N);
D(T) = 0;
Upd_D = D;
%Use bellman ford for N iterations now
for count = 1:N
    % In each iteration, recompute minimum distance for each node
    for node = 1:N
        min = D(node);
        if node == T
            % Don't do any computation fot Dest node
            continue
        else
            for j=1:N 
                %Look for neighbor of 'node'
                if link_conn(node,j) == 1
                    % Compute cost from the node to dest via neighbor
                    cost = link_eff_cost(node,j) + D(j);
                    %If computed cost less than previous min cost, update
                    if cost < min
                        min = cost;
                    end
                end
            end
        end
        Upd_D(node) = min;
    end
    D = Upd_D;
end
min_dis = D(S);
X = ['Shortest distance between ',num2str(S),'(S) and ',num2str(T),'(D) : ', num2str(D(S))];
disp(X)

%% To find the shortest path
if (D(S) < Inf)
    Path = S;
    node = S;
    while node ~= T
        min = Inf;
        for j=1:N
            if j==node
                continue
            else
                if (link_eff_cost(node,j) + D(j)) < min
                    next_node = j;
                    min = link_eff_cost(node,j) + D(j);
                end
            end
        end
        node = next_node;
        Path = [Path node];
    end
else
    disp('No path exists between given S and T')
end
disp('Path is :')
disp(Path)
