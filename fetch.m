function [ data, fetch_success ] = fetch(taifex_url)
%   Fetch Data From taifex_url
%   Return a cell array of fetched data and a flag of fetch status.

    % The opening time of futures exchange is 8:35 ~ 13:45,
    % Sleep the process until that time.
    current = clock;
    if current(4) < 8 || current(4) == 8 && current(5) < 35
        current_sec = current(4) * 60 * 60 + current(5) * 60 + current(6);
        open_sec = 8 * 60 * 60 + 35 * 60;
        fprintf('Pause Process..\n');
        pause(open_sec - current_sec);
        fetch_success = 0;
        data = '';
        return;
    end;
    if current(4) > 13 || current(4) ==13 && current(4) > 55
        current_sec = current(4) * 60 * 60 + current(5) * 60 + current(6);
        one_day_in_sec = 24 * 60 * 60;
        open_sec = 8 * 60 * 60 + 35 * 60;
        fprintf('Pause Process..\n');
        pause(one_day_in_sec + (open_sec - current_sec));
        fetch_success = 0;
        data = '';
        return
    end;
    
    
    % Download Taifex source page
    % Some url error occured while fetching.
    start_time = clock; 
    source_page = urlread(taifex_url, 'Timeout', 5);
    finish_time = clock;
    
    % Parse source Page
    data = parse(source_page);
    
    % Return
    fetch_success = true;
end

