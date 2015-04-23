function [ output_string ] = output( data, data_path )
%   Export the cell array of fetched data into text file.
%   
    % Check whether the data folder is exist.
    if ~isequal(exist(data_path, 'dir'), 7)
        mkdir(data_path);
    end;

    current = clock;
    % Name of file.
    fn = sprintf('%d%d%d%s', current(1), current(2), current(3), '.txt');
    fd = fopen([data_path, '/', fn], 'a+');
    output_string = '';
    for data_index = 1 : length(data)
        data_string = '';
        for attr_index = 1 : length(data{1})
            data_string = [data_string data{data_index}{attr_index} '\t'];
        end;
        output_string = [output_string data_string '\n'];
    end;
    fprintf(cell2mat(output_string));
    fprintf(fd, cell2mat(output_string));  % export to text file.
    fclose(fd);
end

