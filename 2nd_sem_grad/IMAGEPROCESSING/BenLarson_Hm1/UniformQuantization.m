function I = UniformQuantization (I,N)

L = 0:256/N:256;
p = 0.5*(L(1:N)+L(2:N+1));

% for x = 1:size(I,1)
%     for y = 1:size(I,2)
%         for j = 1:N
%             if I(x,y) < L(j+1)
%                 I(x,y) = p(j);
%                 break;
%             end;
%         end;
%     end;
% end;
                   
for j=1:N
    index=find( (I(:)>=L(j)) & (I(:)<L(j+1)) );
    I(index) = p(j);
end;