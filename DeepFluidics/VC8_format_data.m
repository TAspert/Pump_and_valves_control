function [time, position, type, letter]=VC8_format_data(data)

% data are data exracted from the uitable. This function returns  numeric
% arrays to be used to plot or program the sequence of pumps

time={};
            position={};
            type={};
            letter={};
            
            cc=1;
            for i=1:3:size(data,2) % loop on all groups
                
                
                time{cc}=[];
                position{cc}=[];
                type{cc}=[];
                letter{cc}='';
                
                for j=1:size(data,1)
         
                    if numel(data{j,i})==0
                        break
                    else
                        time{cc}=[ time{cc} str2num(data{j,i})];
                        position{cc}=[ position{cc} str2num(data{j,i+1})];
                        
                        if strcmp(data{j,i+2},'stairs')
                        type{cc}=[ type{cc} 0];
                        else
                        type{cc}=[ type{cc} 1];    
                        end
                        
                        letter{cc}=char(64+cc);
                    end
                    
                end
                cc=cc+1;
    
            end