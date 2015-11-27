function [ handles ] = update_fixplot( handles )
%UPDATE_FIXPLOT Summary of this function goes here
%   Detailed explanation goes here
ax = handles.dataAx;
axes(ax);
hold on;

fixationData = handles.fixationData;

if ~isempty(fixationData)
    start=handles.tape_play(1);
    stop=handles.tape_play(2);
    
    safe_delete('fixdata_handle',handles);
    %h =
    %plot(fixationData.FixCenterPos.Data(:,1),fixationData.FixCenterPos.Data(:,2),'-or');
    ts1 = getsampleusingtime(fixationData, start, stop);
    data= ts1.FixCenterPos.Data;
    if ~isempty(data)
        h = plot(data(:,1),data(:,2),...
            'MarkerFaceColor',[0 1 0],...
            'MarkerEdgeColor',[0 0 0],...
            'MarkerSize',12,...
            'Marker','o');
        handles.fixdata_handle = h;
    end
    
end

end

