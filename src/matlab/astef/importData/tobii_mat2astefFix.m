function [  ] = tobii_mat2astefFix( fnamein, fnameout )
%TOBII_MAT2ASTEFFIX Summary of this function goes here
%   Detailed explanation goes here

load(fnamein);
%SV=filterout(SV,600000); % FIXME We have a problem with samples beyond the stop time. Unknown cause. This is just a workaround.
[ ~, ~, fixStats ] = tobii_gaze2fix(SV.lefteye,SV.righteye,SV.timestamp);
data = convertToAstefFIx(fixStats);

[H,V] = askForScreenResolution(data(:,2:3));

fileID = fopen(fnameout,'w');
fprintf(fileID,'%d %d\n',round(H),round(V));
fprintf(fileID,'Timestamp Fix_x Fix_y\n');
for i = 1:size(data,1)
    fprintf(fileID,'%d %d %d\n',data(i,:));
end
end

function data=convertToAstefFIx(fixStats)
data = [fixStats(:,4) fixStats(:,1) fixStats(:,2)];
end


function [H,V] = askForScreenResolution(data)

lim = [max(data(:,1)) max(data(:,2))];

disp('Insert screen resolution in pixel')
disp(['Hint: max values are: horizontal ' num2str(lim(1)) ', vertical ' num2str(lim(2)) ]);

quit = false;
while quit == false
    replyH = input('Horizontal resolution [default 1024]: ','s');
    if isempty(replyH)
        replyH = '1024';
    end
    
    replyV = input('Vertical resolution [default 768]: ','s');
    if isempty(replyV)
        replyV = '768';
    end
    
    H = str2double(replyH);
    V = str2double(replyV);
    
    quit = true;
    if H < lim(1) || V < lim(2)
        fprintf('Warning: input screen resolution (%dx%d) is smaller than fixations limits (%dx%d).\n',round([H V lim]));
        reply = input('Continue anyway? [Y/n]','s');
        if isempty(reply)
            reply = 'Y';
        end
        reply = upper(reply);
        if strcmp(reply,'N') || strcmp(reply,'NO')
            quit = false;
        end
    end
end

fprintf('Setting %dx%d for screen resolution\n',round(H),round(V));
end