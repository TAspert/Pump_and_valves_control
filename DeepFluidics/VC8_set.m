function VC8_set(s,value)

% value must be in the form 
%valve_number  , 0 or 1 ; 
%valve_number2 ,  0 or 1 ; 
% etc....

str=[];

s.flush();

for i=1:size(value,1)
    if value(i,1)>8
   disp(   'wrong valve number')
        continue
    else
        
     str=[str num2str(value(i,1)) ','];
     
     str=[str num2str(value(i,2)) ','];
    end
end

str=str(1:end-1); % remove trailing ',' 
str=['s' str];

if strcmp(class(s), 'internal.Serialport')
    write(s,[str char(10)],'char')
else
    disp('Serial port object is not correctly defined');
    return;
end

% get confirmation 




