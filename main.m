% Taifex Real Time Crawler
% author:xero7689
% email:volleyp7689@gmail.com

clear all;
clc;

% Preprocess
taifex_url = 'http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx';
latest_data = {};
data_path = [pwd() '/data'];
<<<<<<< HEAD
period = 0.5; % 1ms
retry = 10;
=======
period = 1; % 1 second
%retry = 10;
FINISH = false;
>>>>>>> origin/master

fprintf('Launch Crawler..');

while ~FINISH
    % Fetch Data
    [data, fetch_status] = fetch(taifex_url);

    % Output
<<<<<<< HEAD
    os = output(data, data_path);

    % sleep period
=======
    if fetch_status
        output(data, data_path);
    end;
    
    % Sleep
>>>>>>> origin/master
    if period
        pause(period);
    end;
end;
