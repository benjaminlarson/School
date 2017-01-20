classdef node < handle
   % dlnode A class to represent a doubly-linked list node.
   % Link multiple dlnode objects together to create linked lists.
   properties
      Data
   %end
   %properties(SetAccess = private)
      Children = containers.Map({},[]);
   end
   
   methods
      function node = node(data)
         %Construct a dlnode object.
         if nargin > 0
            node.Data = data;
            %node.keySet(att,att2) = []; 
         end
          
           
      end
      
      function insertNode(newNode, att)
         % Insert newNode after nodeBefore.
         %removeNode(newNode);
         % add key att to
         node.Children(att) = newNode; 
%          newNode.Next = nodePrev.Next;
%          newNode.Prev = nodePrev;
%          if ~isempty(nodePrev.Next)
%             nodePrev.Next.Prev = newNode;
%          end
%          nodePrev.Next = newNode;
      end
      
%       function insertLeft(newNode, nodeLeft)
%          % Insert newNode before nodeAfter.
%          removeNode(newNode);
%          newNode.Next = nodeLeft;
%          newNode.Prev = nodeLeft.Prev;
%          if ~isempty(nodeLeft.Prev)
%             nodeLeft.Prev.Next = newNode;
%          end
%          nodeLeft.Prev = newNode;
%       end
      
%       function removeNode(node)
%          % Remove a node from a linked list.
%          if ~isscalar(node)
%             error('Input must be scalar')
%          end
%          prevNode = node.Prev;
%          nextNode = node.Next;
%          if ~isempty(prevNode)
%             prevNode.Next = nextNode;
%          end
%          if ~isempty(nextNode)
%             nextNode.Prev = prevNode;
%          end
%          node.Next = dlnode.empty;
%          node.Prev = dlnode.empty;
%       end
      
%       function clearList(node)
%          % Clear the list before
%          % clearing list variable
%          prev = node.Prev;
%          next = node.Next;
%          removeNode(node)
%          while ~isempty(next)
%             node = next;
%             next = node.Next;
%             removeNode(node);
%          end
%          while ~isempty(prev)
%             node = prev;
%             prev = node.Prev;
%             removeNode(node)
%          end
%       end
   end % methods
   
%    methods (Access = private)
%       function delete(node)
%          % Delete all nodes
%          clearList(node)
%       end
%    end % private methods
end % classdef
