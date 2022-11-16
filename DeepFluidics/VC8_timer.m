function VC8_timer(obj,event)


% executes upon timer start

appdata=obj.UserData;

app=appdata.app;


s=app.serial;

starttime=appdata.start;
time= appdata.time;
position=appdata.position;
type= appdata.type;
letter= appdata.letter;
avg=appdata.avg;

currentime=etime(clock,starttime)/60;

%currentime=30

for i=1:numel(time) % loop on all groups
  %  i
    t=time{i};
    
    if numel(t)==0
        continue
    end
    
    p=position{i};
    tt=type{i};
    % find correct interval
    
    pix=find( t>currentime,1,'first');
    
    if numel(pix)==0 % time is past the last sequence , so go for the last valve state
        val=[letter{i} num2str(p(end))];
        out=VC8_group_set(s,numel(time),{val});
        displayValves(app,out);
        peff=p(end);
        
         t=timerfind('Name','valvetimer');
                
                stop(t)
                delete(t);
                
    else
        
        if pix==1 % sequence has not started yet
            val=[letter{i} num2str(p(1))];
            out=VC8_group_set(s,numel(time),{val});
            displayValves(app,out);
            peff=p(1);
        else

            
            if tt(pix-1)==0 % stairs
                
                val=[letter{i} num2str(p(pix-1))];
                out=VC8_group_set(s,numel(time),{val});
                displayValves(app,out);
                peff=p(pix-1);
            else  % ramp
                
                
                val1=p(pix-1);
                val2=p(pix);
                
                t1=t(pix-1);
                t2=t(pix);
                
                r=(currentime-t1)./(t2-t1);
                
                %  aa=avg{i}==val2
                
                
                pix2=sum(avg{i}==val2)/numel(avg{i});
                if isnan(pix2)
                    pix2=1;
                end
                
                if pix2> r
                    val=[letter{i} num2str(p(pix-1))];
                    peff=p(pix-1);
                else
                    val=[letter{i} num2str(p(pix))];
                    peff=p(pix);
                end
                
                out=VC8_group_set(s,numel(time),{val});
                displayValves(app,out);
                
            end
        end
    end
    
    %peff;
    a=avg{i};
    a(end+1)=peff;
    if numel(a)>=10 % number of time points to calculate average
        a=a(2:end);
    end
   
    
    avg{i}= a;
    
end

obj.UserData.currentime=currentime;
obj.UserData.avg=avg;

displayTimer(app);


