function [ td ] = parser( source_page )
%% Taifex Real-Time Source Page Parser Using Regular Expression.
    tr_pattern = '<tr class="custDataGridRow".*?>(.*?)</tr>';
    td_pattern = '<td.*?><.*?>(.*?)</.*?></td>';
    
    tr = regexp(source_page, tr_pattern, 'tokens');
    
    tr_length = length(tr);
    td = cell(tr_length, 1);
    
    for tr_index = 1 : tr_length
        % Parse <tr>
        td{tr_index} = regexp(tr{tr_index}{1}, td_pattern, 'tokens');
                
        % Prune future's id
        dirty_id = td{tr_index, 1}{1, 1};
        id = regexp(dirty_id, '(?<=<.*?>)(.*)', 'match');
        td{tr_index, 1}{1, 1} = id{1, 1};
    end;
end

