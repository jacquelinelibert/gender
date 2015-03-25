
fileID = fopen('allResults.txt', 'wt');
fprintf(fileID,'subID\tphase\tf0\tvtl\tface\tword\thands\tbutton\tRT \n');

cd('/home/paolot/results/gender/');

files = dir('*.mat');
nFiles = length(files);
for ifiles = 1:nFiles
    load(files(ifiles).name);
    [~, startIndex] = regexp(files(ifiles).name,'gen_');
    [endIndex, ~] = regexp(files(ifiles).name,'.mat');
    ppID = files(ifiles).name(startIndex+1 : endIndex-1);
    phases = fieldnames(results);
    nPhases = length(phases);
    for iphase = 1 : nPhases
        nResponses = length(results.(phases{iphase}).responses);
        for iresp = 1 : nResponses
            % ntrials = length(results.(phases{iphase}).conditions(iCond).att(iAttempt).differences);
            fprintf(fileID,'%s\t', ppID);
            fprintf(fileID,'%s\t', phases{iphase});
            fprintf(fileID,'%i\t', results.(phases{iphase}).responses(iresp).trial.f0);
            fprintf(fileID,'%1.1f\t', results.(phases{iphase}).responses(iresp).trial.vtl);
            fprintf(fileID,'%s\t', results.(phases{iphase}).responses(iresp).trial.face);
            fprintf(fileID,'%s\t', results.(phases{iphase}).responses(iresp).trial.word);
            fprintf(fileID,'%s\t', results.(phases{iphase}).responses(iresp).trial.hands);
            
            fprintf(fileID,'%i\t', results.(phases{iphase}).responses(iresp).button_clicked);
            fprintf(fileID,'%02.3f\t', results.(phases{iphase}).responses(iresp).response_time);
            fprintf(fileID,'\n');
        end
    end
end

fclose(fileID);