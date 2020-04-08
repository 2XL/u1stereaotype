%% quan tingui tots el 
% require import save2json plugin
addpath('C:\Program Files\MATLAB\R2016a\toolbox\jsonlab')
%{
MATLAB
1r preparar array dataset
2n [D, PD]alldistfit(dataset)
3r save2json('',D)
4r copy paset json to json file

IDEA
5t testFileSizeDistribution.py > json into csv file
6t translateMatlabToScipy.py > cast matlab object .csv into python scipy fitting parameters
7t compareDistribution.py > generate #(random values) by fitting parameters >> file_type_XXXX#.dat (# priority)
%}

%% convertir els json en csv per


%{

fid = fopen( 'results.txt', 'wt' );
for image = 1:N
  [a1,a2,a3,a4] = ProcessMyImage( image );
  fprintf( fid, '%f,%f,%f,%f\n', a1, a2, a3, a4);
end
fclose(fid);

%}



profile = {'b/backup', 'd/download','s/sync'};
operationOne = {'MakeResponse', 'MoveResponse','PutContentResponse','GetContentResponse','Unlink'};
operationTwo = {'MakeResponse', 'MoveResponse','PutContentResponse','GetContentResponse','Unlink'};

% filename = 'backup_GetContentResponse_GetContentResponse.mat'

idx = 0;
for n = profile
    for o1 = operationOne
        for o2 = operationTwo
            idx = idx+1;
            disp (idx)
            prefix = 'out/';
            prof = n;
            op1 = o1;
            op2 = o2;
            file_extension = '.mat';
            
            file_name = strcat(prefix, prof,'_',op1, '_', op2,file_extension);


            filename=file_name{1};
            % load the file
            load(filename)


            % convert mat variable into json
            dJSON = savejson('',D);


            % store the json variable into text file
            file_name_out = strcat('json/', prof,'_',op1, '_', op2,'.json');
            file_out = file_name_out{1}
            disp (file_out)
            fid = fopen( file_out , 'wt' );
              fprintf( fid, dJSON);
            fclose(fid);
        end
    end
end

disp('end all')




















