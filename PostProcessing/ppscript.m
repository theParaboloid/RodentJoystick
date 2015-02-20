function ppscript(working_dir)

filelist = dir(strcat(working_dir,'/*.dat'));
working_buff=[];
mkdir(strcat(working_dir,'/comb'));
open_flag=0;

     fid = fopen(strcat(working_dir,'/',filelist(1).name));
%     datenum_var = fread(fid,1,'double');
      frame_number = str2num(filelist(1).name(1:10));
      start_frame = frame_number;
%     working_buff= fread(fid,[6 11000],'double');
%     fclose(fid);
record_list =[];

for i=1:1000    
    [traj] = fscanf(fid,'%f',2);
    if numel(traj)==0
        break
    else
        for j=1:4
            state_char = fscanf(fid,'%s',1);
            states(j)=double(uint8(state_char(1))==84)*j;     
        end
         
        record_list(i,:) = [traj' states];
    end
end


working_buff = record_list;
    
for i = 2:(length(filelist))    
    fid = fopen(strcat(working_dir,'/',filelist(i).name));
    framenumber_prev = frame_number;
    frame_number = str2num(filelist(i).name(1:10));
    
    for m=1:1000
        [traj] = fscanf(fid,'%f',2);
        if numel(traj)==0
            break;
        else
            for n=1:4
                state_char = fscanf(fid,'%s',1);
                states(n)=double(uint8(state_char(1))==84)*n;
            end
        end
        
        record_list(m,:) = [traj' states ];
    end
    
    if ((framenumber_prev+1)==frame_number)
        working_buff= [working_buff;record_list];
        record_list=[];
        open_flag=0;
    else
     %working_buff = working_buff(1:6, 1:10:end);
     if numel(working_buff)>0
        save(strcat(working_dir,'/comb/',filelist(i-1).name(1:end-4),'.mat'),'start_frame','working_buff');
     end
     open_flag=1;
     working_buff=record_list;
     start_frame = frame_number;
     record_list=[];
    end
    fclose(fid);    
end

if (open_flag) && numel(working_buff)>0
    save(strcat(working_dir,'/comb/',filelist(i).name(1:end-4),'.mat'),'start_frame','working_buff');
end