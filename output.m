function [ output_string ] = output( data, start_time, finish_time, data_path, fetch_mode )
% Export the cell array of fetched data into text file.

    % Check whether the data folder is exist.
    if ~isequal(exist(data_path, 'dir'), 7)
        mkdir(data_path);
    end;
    
    % Format Start Time and Finish Time
    st = [num2str(start_time(1)) '/' num2str(start_time(2)) '/' num2str(start_time(3))...
        '_' num2str(start_time(4)) ':' num2str(start_time(5)) ':' num2str(start_time(6))];
    ft = [num2str(finish_time(1)) '/' num2str(finish_time(2)) '/' num2str(finish_time(3))...
        '_' num2str(finish_time(4)) ':' num2str(finish_time(5)) ':' num2str(finish_time(6))];

    current = clock;
    
    if fetch_mode == 0
        % Name of file.
        fn = sprintf('%d%d%d%s', current(1), current(2), current(3), '.txt');
        fd = fopen([data_path, '/', fn], 'a+');
        output_string = '';
        for data_index = 1 : length(data)
            data_string = '';
            for attr_index = 1 : length(data{1})
                data_string = [data_string data{data_index}{attr_index} '\t'];
            end;
            output_string = [output_string st '\t' ft '\t' data_string '\n'];
        end;
        clc;
        fprintf(cell2mat(output_string));
        fprintf(fd, cell2mat(output_string));  % export to text file.
        fclose(fd);
    else
        idn = '';
        for ID = 1 : length(fetch_mode)
            idn = [idn, '_', num2str(fetch_mode(ID))];
        end;
        fn = sprintf('%d%d%d%s%s', current(1), current(2), current(3), idn, '.txt');
        disp(fn);
        fd = fopen([data_path, '/', fn], 'a+');
        
        output_string = '';
        for sp_index = fetch_mode
            data_string = '';
            for attr_index = 1 : length(data{1})
                data_string = [data_string data{sp_index}{attr_index} '\t'];
            end;
            output_string = [output_string st '\t' ft '\t' data_string '\n'];
        end;
        clc;
        fprintf(cell2mat(output_string));
        fprintf(fd, cell2mat(output_string));  % export to text file.
        fclose(fd);
    end;
end

