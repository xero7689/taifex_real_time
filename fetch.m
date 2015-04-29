function [ data, start_time, finish_time, fetch_success ] = fetch(taifex_url)
%   Fetch Data From taifex_url
%   Return a cell array of fetched data and a flag of fetch status.

    % The opening time of futures exchange is 8:35 ~ 13:45,
    % Sleep the process until that time.
    % 期交所的營業時間為早上8:45 ~ 13:45(其中前10分鐘為試搓階段)
    % 因此將Fetch的時間往前往後延長10分鐘避免兩邊有時間上的誤差
    % 這段時間以外開啟程序會自動睡眠到交易日
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
    try
        source_page = urlread(taifex_url);
    catch 
        disp('Catch UrlError');
    end;
    finish_time = clock;
    
    % Parse source Page
    % 用parse函式分析下載回來的網頁原始碼
    data = parse(source_page);
    
    % Return
    fetch_success = true;
end

