function CalculateWordVectorVariance(filename, delimiter)
    %%%%%%%%%%%%%%%%%%%%%         Description
    % Does 3 things:
    % 1) Calculate word vector variance
    % 2) Assign words and their variances to structure "WordVariances"
    % 3) Save WordVariances to WordVariances.m in current directory
    % 
    % In order to run in batch mode (all files in a directory) pass the
    % "filename" parameter a directory path (ending in "\")
    % In order to run for individual files, pass the "filename" paremeter
    % a file path (directory\filename.txt)
    % The "delimiter" parameter is the delimiter by which the file(s)'s
    % values are separated:
    %' ' or 'space'
    %'\t' or 'tab'
    %',' or 'comma'
    %';' or 'semi'
    %'|' or 'bar'
    % 
    %%%%%%%%%%%%%%%%%%%%%         File Formating
    % Make sure vector files are formatted so that the first row is all
    % headers (does not matter what the headers are named as long as they
    % don't start with numbers), the first column (not counting the first
    % row) is all words, and the rest of the cells are dimension values
    %
    %%%%%%%%%%%%%%%%%%%%%         File Naming
    % For consistancy, the current filename format for the word vector text
    % files is the MON.txt where:
    % 'M' is the model used to create the vectors,
    % 'O' designates whether it is the Original vectors or if they were
    % modified somehow (ex. 'O' can be 'original', 'scaled', etc.), and
    % 'N' is the number of dimensions used to create the vectors
    % For example, HLBLoriginal50.txt is the ORIGINAL set of word vectors
    % created by the Hierarchical log-bilinear (HLBL) model, using 50
    % dimensions
    %
    % The reason for the file naming protocol is for ease of use of the
    % structure after it is created (word/variance lists are stored in the
    % structure by file name)
    
    % load WordVariances structure
    result = input('Load WordVariances Structure? (y/n)', 's');
    if isequal(lower(result),'y') || isequal(lower(result),'yes')
        [wordVarianceFilename,wordVarianceFilepath,FilterIndex] = uigetfile('*.m');
        load([wordVarianceFilepath wordVarianceFilename], '-mat');
    end
    
    [pathstr,name,ext] = fileparts(filename);

    if isequal(ext,'') % determine if batch or individual run
        d=dir;
        filenames={d(~[d.isdir]).name};
        for i=1:length(filenames)
            filenames{i} = strcat(pathstr, '\', filenames{i});
        end
    else
        filenames={filename};
    end
    
    for a=1:length(filenames) % loop through all files passed to funciton
        wordList=struct2cell(tdfread((filenames{a}),delimiter));
        K=length(wordList);
        for i=1:length(wordList{1}) % loop through all words in file
            wordVector=[];
            for k=2:K % isolate word vector values
                wordVector(k-1)=wordList{k}(i);
            end
            word{i}=wordList{1}(i,:); % store word
            V{i}=var(wordVector); % calculate/store variance for word
        end
        % create structure
        [pathstr,name,ext] = fileparts(filenames{a});
        WordVariances.(name).words=word;
        WordVariances.(name).variances=V;

    end
    save('WordVariances.m','WordVariances')
end