%% Taifex Real Time Crawler
clear all;
clc;

%% Preprocess
taifex_url = 'http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx';
latest_data = {};
data_path = pwd();
period = 0.001; % 1ms
retry = 10;

%% Initialize
fprintf('Launch Crawler..');
if period == 0
    while true
        fetch();
    end;
else
    fetch();
    pause(period);
end;

%% output