function [ output_string ] = output( data, data_path )
%OUTPUT Summary of this function goes here
%   Detailed explanation goes here
    if ~isequal(exist(data_path, 'dir'), 7)
        mkdir(data_path);
    end;

    current = clock;
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
    disp(output_string);
    fprintf(fd, cell2mat(output_string));
    fclose(fd);
    flag = false;
end

