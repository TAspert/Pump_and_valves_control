function out=VC8_get(s)

out=[];

if strcmp(class(s), 'internal.Serialport')
    write(s,['g' char(10)],'char')
else
    disp('Serial port object is not correctly defined');
    return;
end

t0=clock;
while(s.NumBytesAvailable<16) && etime(clock,t0)<5
    
end

n=s.NumBytesAvailable;

if n==0 % time out
    disp('Request timed out!')
    return;
end
    

res=char(read(s,n,"char"));

p=strfind(res,':');
res=res(p+1:end-1);

out=str2num(res);

s.flush();
