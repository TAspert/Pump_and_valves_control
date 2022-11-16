function out=VC8_group_set(s,groupmode,values)

% group mode = 8, 4 or 2
% values = {'A4','B2'} for example 


[out,~,~]=VC8_get_group_code(s,groupmode,values);

VC8_set(s,out);
 
