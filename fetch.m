function [ data, finish_flag ] = fetch(taifex_url, fetch_flag)
%FETCH Summary of this function goes here
%   Detailed explanation goes hereda
    %
    if ~fetch_flag
        return
    end;
    
    % Opening
    current = clock;
    if current(4) < 8 || current(4) == 8 && current(5) < 35
        current_sec = current(4) * 60 * 60 + current(5) * 60 + current(6);
        open_sec = 8 * 60 * 60 + 35 * 60;
        disp('Zzz..');
        %pause(open_sec - current_sec);
        %finish_flag = false;
        %data = 0;
        %return;
    end;
    if current(4) > 13 || current(4) ==13 && current(4) > 55
        current_sec = current(4) * 60 * 60 + current(5) * 60 + current(6);
        one_day_in_sec = 24 * 60 * 60;
        open_sec = 8 * 60 * 60 + 35 * 60;
        disp('Zzz..');
        %pause(one_day_in_sec + (open_sec - current_sec));
        %finish_flag = false;
        %data = 0;
        %return
    end;
    
    % Download Taifex source page
    start_time = clock; 
    source_page = urlread(taifex_url);
    finish_time = clock;
    
    % Parse source Page
    data = parser(source_page);
    
    % Return
    finish_flag = false;
end

