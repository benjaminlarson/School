%% add node to the tree/matrix
function tree = addNode(tree,parent)

%tree is a matrix, nodeValues are the children nodes, and label
%size of the tree add after
addAt = size(tree(:,1));

%nodeValues(1,2) should be the left, right children
tree(addAt+1,1) = parent; %node number 
%tree(addAt+1,2) = nodeValues(1); %children of this node
%tree(addAt+1,3) = nodeValues(2); 