clc; clear all;
numNodes = 10;
totalPop = 100;
nodePos = rand(numNodes,2);
%approx distro of population
pops = rand(numNodes,1);
pops = int8((pops/sum(pops))*100);
pops = double(pops);
nodes = struct('pop', {}, ...
               'dest',       {}, ...
               'pos',        {});  
for i= 1:numNodes
    nodes(i).pop = pops(i);
    nodes(i).dest = double(int8(rand(pops(i),1)*100)/10)+1;
    nodes(i).pos = nodePos(1,:);
end

%A 2-D Delaunay triangulation ensures that the circumcircle
%associated with each triangle contains no other point in its interior. 
%tri gives the adjacency matrix for each triangle
tri = delaunay(nodePos(:,1),nodePos(:,2));


elem = ones(3)-eye(3);
for i = 1:length(tri),
A(tri(i,:),tri(i,:)) = elem;
end
A = double(A > 0);
gplot(A,nodePos,'-*')
