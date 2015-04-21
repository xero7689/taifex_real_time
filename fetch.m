function [ output_args ] = fetch( record )
%FETCH Summary of this function goes here
%   Detailed explanation goes hereda
    % Opening
    current = clock;
    if current(4) < 8 || current(4) == 8 && current(5) < 35
        % sleep
        % Unfinished
        return;
    end;
    if current(4) > 13 || current(4) ==13 && current(4) > 55
        % sleep 
        % Unfinished
        return
    end;
    
    % Download Taifex source page
    start_time = clock; 
    source_page = urlread(taifex_url);
    finish_time = clock;
    fn = sprintf('%d%d%d%s', finish_time(1), finish_time(2), finish_time(3), '.txt');
    
    % Parse source Page
    data = parser(source_page);
    
    


end

