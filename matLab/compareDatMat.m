clc;
clear all;
close all;

%%

disp('CDF plot: file type by profile')


profile = {'sync', 'download','backup'};
op1 = {'GetContentResponse', 'PutContentResponse','MoveResponse', 'MakeResponse' , 'Unlink'};
op2 = {'GetContentResponse', 'PutContentResponse','MoveResponse', 'MakeResponse' , 'Unlink'};


%{
profile = {'download'};
op1 = {'PutContentResponse'};
op2 = {'MakeResponse'};
%}


%{
generar un png comparando todos los .dat generados con el .mat
correspondiente


%} 

% load file dat
file_prefix_dat = '';
file_extension_dat = '.dat';
% load file mat
file_prefix_csv = '';
file_extension_csv = '.csv'; 
 

for prof = profile
    for o1 = op1
        for o2 = op2


            disp('---- Init Looping -----')
            % Create figure
            figureCDF = figure;
            % Create axes
            axesCDF = axes('Parent',figureCDF);
            
            
            plot_title = strcat('CDF',prof, '_', o1, '_', o2);
            
            
            title(plot_title{1})
            % Set the remaining axes properties
            set(axesCDF,'XMinorTick','on','XScale','log','YMinorTick','on','YScale','linear');
            hold(axesCDF,'on');



            file_dat = strcat(file_prefix_dat,prof, '_', o1, '_', o2,file_extension_dat);
            file_csv = strcat(file_prefix_csv,prof, '_', o1, '_', o2,file_extension_csv);

            % locate the file
            % test = csvread(file_name{1}, 1, 1, );

            % filename = 'G:\trazas.csv\cdf [unicos] ficheros por formato y [perfil]\u1file_type_prob_freq_backup.csv';
            filename_dat = file_dat{1};
            filename_csv = file_csv{1};
            disp (filename_dat);
            disp (filename_csv);

            [fake_time] = importfile(filename_dat);


            %% Allocate imported array to column variable names
            [real_time] = importfile(filename_csv); % load('out/d/download_Unlink_Unlink.mat')

            %% Clear temporary variables
            % clearvars filename delimiter startRow formatSpec fileID dataArray ans;

            ecdf(fake_time)
            ecdf(real_time)

            xlabel('count');
            % Create ylabel
            ylabel('operation_time');

            legend('fake_time', 'real_time');

            legend(axesCDF,'show');
            box(axesCDF,'on');
            disp '------bundle keys-------'


            file_png = strcat('',prof,'_', o1, '_', o2,'.png');
            output_file = file_png{1};

            disp 'save as: '
            disp (output_file)
            saveas(figureCDF, output_file);

        end
    end
end





