function [ td ] = parser( source_page )
%% Taifex Real-Time Source Page Parser Using Regular Expression.
    tr_pattern = '<tr class="custDataGridRow".*?>(.*?)</tr>';
    td_pattern = '<td.*?><font.*?>(.*?)</font></td>';
    
    tr = regexp(source_page, tr_pattern, 'tokens');
    
    tr_length = length(tr);
    td = cell(tr_length, 1);
    
    data_to_display = '';
    
    for tr_index = 1 : tr_length
        % Parse <tr>
        td{tr_index} = regexp(tr{tr_index}{1}, td_pattern, 'tokens');
                
        % Prune future's id and status
        dirty_id = td{tr_index}{1};
        dirty_status = td{tr_index}{2};
        id = regexp(dirty_id, '<a.*?>(.*)</a>', 'tokens');
        status = regexp(dirty_status, '<.*?>()</.*?>', 'tokens');
        td{tr_index}{1} = id{1}{1}{1};
        td{tr_index}{2} = status{1}{1}{1};
    end;
end

