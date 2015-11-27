%SAFE_DELETE delete a field of handles safely
%   Check if field name exists and is not 0
function safe_delete(name,handles)
if isfield(handles,name)
    h = handles.(name);
    if h~= 0
        delete(h);
    end
end

