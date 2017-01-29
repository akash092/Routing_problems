%% Topology Setup
clear all;
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

%Solving by Djikstra so assuming positive cost on all link
link_prob_loss = ones(N,N);
max_cost_for_direct_link = 20;
min_cost_for_direct_link = 1;
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
% we are now computing minimum distance from source to various nodes in
% the network
D(S) = 0;
ord_set = S;
%oredered set is the set containing permanent nodes
last_node_added = S;
% last_node_added keep track of the last node made permanent
%Use Djikstra for N-1 iterations now

for count = 1:N-1
    % In each iteration, recompute minimum distance from source to each node
    % which belongs to unordered list
    iteration_cost = [];
    iteration_node = [];
    for node = 1:N
        if (ismember(node, ord_set))
            % Don't perform any computation for nodes in Ordered set
            continue
        else
            % If node is connected to previously made permanenent node
            if link_conn(last_node_added,node) == 1
                new_cost = (D(last_node_added)/ ...
                          (1 - link_prob_loss(last_node_added,node))) ...
                            + link_eff_cost(last_node_added,node);
                % Take the mimimum of the last expected min distance and 
                % distance via last_node_added
                iteration_cost = [iteration_cost min(D(node),new_cost)];
                iteration_node = [iteration_node node];
            else
                iteration_cost = [iteration_cost D(node)];
                iteration_node = [iteration_node node];
            end
            D(node) = iteration_cost(end);
        end
    end
    % Find mimimum of the current iteration from the unordered list
    min_cost_iteration = min(iteration_cost);
    column = find(min_cost_iteration == iteration_cost);
    % add only one node in permanent list at a time even if there are
    % multiple instance of minimum distance
    last_node_added = iteration_node(column(1));
    ord_set = [ord_set last_node_added];
end
X = ['Shortest distance between ',num2str(S),'(S) and ',num2str(T),'(D) : ', num2str(D(T))];
disp(X)

%% To find the shortest path
if (D(T) < Inf)
    Path = T;
    node = T;
    while node ~= S
        min = Inf;
        for j=1:N
            if j==node
                continue
            else
                cost = (D(j)/ (1 - link_prob_loss(j,node))) ...
                       + link_eff_cost(j,node);
                if cost < min
                    prev_node = j;
                    min = cost;
                end
            end
        end
        node = prev_node;
        Path = [node Path];
    end
else
    disp('No path exists between from S and T(Dest)')
end
disp('Path is :')
disp(Path)
