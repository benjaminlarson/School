classdef lnode < handle
   properties
     Data
   end
   properties(SetAccess = private)
    Children = containers.Map();
   end
   
   methods
      function node = lnode(data)
         %Construct a dlnode object.
         if nargin > 0
            node.Data = data;
         end
      end
      
      function insertNodeT(curNode, newNode)
         curNode.Children('T') = newNode.Data;
      end
      
      function insertNodeF(curNode, newNode)
         curNode.Children('F') = newNode.Data;
      end
   end 
end % classdef
