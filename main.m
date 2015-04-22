%% Taifex Real Time Crawler
clear all;
clc;

%% Preprocess
taifex_url = 'http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx';
latest_data = {};
data_path = pwd();
period = 0.01; % 1ms
retry = 10;

%% Initialize
fprintf('Launch Crawler..');
finish_flag = false;
if period == 0
    while ~finish_flag
        finish_flag = fetch(taifex_url, true);
    end;
else
    while ~finish_flag
        finish_flag = fetch(taifex_url, true);
        pause(period);
    end;
end;

%% output