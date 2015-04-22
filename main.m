%% Taifex Real Time Crawler
clear all;
clc;

%% Preprocess
taifex_url = 'http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx';
latest_data = {};
data_path = [pwd() '/data'];
period = 1; % 1ms
retry = 10;

%% Initialize
fprintf('Launch Crawler..');
finish_flag = false;

while ~finish_flag
    % Fetch Data
    [data finish_flag] = fetch(taifex_url, true);

    % Output
    os = output(data, data_path);

    % Sleep
    if period
        pause(period);
    end;
end;
