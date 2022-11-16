function sp=VC8_connect(port,option)


freeports = serialportlist("available");

if numel(find(matches(freeports,port)))

sp=serialport(port,115200);

configureCallback(sp,"terminator",@VC8_eventmanager);

if nargin==2
    sp.UserData=option;
end

else
    disp('Proposed port is not available ');
    sp=[];
end

