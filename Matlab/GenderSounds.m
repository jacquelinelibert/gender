soundDir = '../Stimuli/Gender/';
gendervoices = ClassifyGenderFiles(soundDir);
options = [];
[expe, options] = gender_buildingconditions(options);

phase = 'test';
options.(phase).total_ntrials
  
for iTrial = 1 : options.(phase).total_ntrials
    
    emotionVect = strcmp({gendervoices.emotion}, expe.(phase).condition(iTrial).voicelabel);
    phaseVect = strcmp({gendervoices.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    indexes = 1:length(possibleFiles);
    indexes = indexes(possibleFiles);
    %this works
    %this should store all names of possibleFiles 
    toPlay = randperm(length(gendervoices(indexes)),1);
    
    [y, Fs] = audioread(gendervoices(indexes(toPlay)).name);
    disp (gendervoices(indexes(toPlay)).name)
    player = audioplayer (y, Fs);
    playblocking (player); 
    
    % remove just played file from list of possible sound files
    gendervoices(indexes(toPlay)) = [];
    
end
    
