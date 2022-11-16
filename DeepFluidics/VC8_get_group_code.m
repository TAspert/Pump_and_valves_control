function [out letters codes]=VC8_get_group_code(s,groupmode,val)

letters={};
codes={};

switch groupmode
    case 8
       letters={'A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2'};
       codes={[1 0],[1 1],[2 0],[2 1],[3 0],[3 1],[4 0],[4 1],[5 0],[5 1],[6 0],[6 1],[7 0],[7 1],[8 0],[8 1]};
    case 4
       letters={'A1','A2','A3','A4','B1','B2','C1','C2','C3','C4','D1','D2'};
       codes={[1 0; 5 0],[1 1; 5 0],[2 0; 5 1],[2 1; 5 1],[6 0],[6 1],[3 0; 7 0],[3 1; 7 0],[4 0; 7 1],[4 1; 7 1],[8 0],[8 1]};
    case 2
       letters={'A1','A2','A3','A4','A5','A6','A7','A8','B1','B2'};
       codes={[1 0; 5 0; 6 0],[1 1; 5 0; 6 0],[2 0; 5 1; 6 0],[2 1; 5 1; 6 0],[3 0; 7 0; 6 1],[3 1; 7 0; 6 1],[4 0; 7 1; 6 1],[4 1; 7 1; 6 1],[8 0],[8 1]};
end

out=[];
 for i=1:numel(val)

        pix=find(matches(letters,val{i}));
        
        if numel(pix)
        out= [out ; codes{pix}];
        end

 end
 
