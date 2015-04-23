% Taifex Real Time Crawler
% author:xero7689
% email:volleyp7689@gmail.com

clear all;
clc;

% Preprocess
taifex_url = 'http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx';
latest_data = {};
data_path = [pwd() '/data'];
period = 1; % 1 second
%retry = 10;
FINISH = false;

fprintf('Launch Crawler..');

while ~FINISH
    % Fetch Data
    [data, fetch_status] = fetch(taifex_url);

    % Output
    if fetch_status
        output(data, data_path);
    end;
    
    % Sleep
    if period
        pause(period);
    end;
end;
