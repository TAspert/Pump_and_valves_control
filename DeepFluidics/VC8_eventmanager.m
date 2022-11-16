function VC8_eventmanager(src,evt)


n=src.NumBytesAvailable;

if n==0
    return;
end

%disp('received information');


res=char(read(src,n,"char"));

if strcmp(res(1),'O')
    % this is an ackwoledgment of command
    return;
end

if strcmp(res(1),'S')
 % this is an update of valve status, user may have siwtched valve manually
 
p=strfind(res,':');
res=res(p+1:end-1);


if numel(src.UserData) % updates GUI display if available
    tmp=src.UserData;
    
    
    value=[];
    for i=1:numel(res)
        value(i,1)=i;
        value(i,2)=str2num(res(i));
        
    end
    displayValves(tmp,value)
    
end
end

src.flush();