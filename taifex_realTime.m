function [ ] = taifex_realTime( varargin )
%TAIFEX_REALTIME Summary of this function goes here
%   Detailed explanation goes here
    
    % Handle Arguments
    % 0: Will fetch every futures.
    % [1, 2, 3 ...]: Matrix of future's ID that user want to fetch.
    if varargin{1} == 0
        disp('Display Every Futures');
        fetch_mode = varargin{1};
    elseif ismatrix(varargin{1})
        disp('Display Specialize Futures');
        fetch_mode = varargin{1};
    end;
    
    %% Preprocess
    taifex_url = 'http://info512.taifex.com.tw/Future/FusaQuote_Norl.aspx';
    data_path = [pwd() '/data'];
    period = 1; % fetch frequent, 1 second.
    %retry = 10;
    FINISH = false;

    fprintf('Launch Crawler..\n');

    while ~FINISH
        % Fetch Data
        [data, start_time, finish_time, fetch_status] = fetch(taifex_url);

        % Output
        if fetch_status
            output(data, start_time, finish_time, data_path, fetch_mode);
        end;
        
        % Sleep
        if period
            pause(period);
        end;
    end;
end

