function [expe, options] = GenderConditions (options)

%----------- Signal options
options.fs = 44100;
if is_test_machine
    options.attenuation_dB = 3;  % General attenuation
else
    options.attenuation_dB = 27; % General attenuation
end
options.ear = 'both'; % right, left or both

%----------- Design specification
options.test.n_repeat = 1; % Number of repetition per condition 
options.test.retry = 1; % Number of retry if measure failed
options.test.total_ntrials = 54; % nr of trials per block 

% -------- Stimuli options 
options.test.f0s  = [201, 151, 101]; % 201 = average pitch of original female voice
options.test.sers = [1, 2^(-1.8/12), 2^(-3.6/12)];
options.test.words = {'bus', 'vaak', 'leeg', 'pen', 'hoed', 'loop'};  
% options.test.words = [1, 2, 3, 4];

options.test.voices(1).label = 'female';
options.test.voices(1).f0 = 201; 
options.test.voices(1).ser = 1; 

options.test.voices(2).label = 'male';
options.test.voices(2).f0 = 101; % 12 st
options.test.voices(2).ser = 2^(-3.6/12);

options.test.voices(3).label = 'intermediate-gpr&vtl';
options.test.voices(3).f0 = 151; % 6 st 
options.test.voices(3).ser = 2^(-1.8/12);

options.test.voices(4).label = 'female-gpr';
options.test.voices(4).f0 = 121;
options.test.voices(4).ser = 2^(-1.8/12);

options.test.voices(5).label = 'male-gpr';
options.test.voices(5).f0 = 101; % 12 st
options.test.voices(5).ser = 2^(-1.8/12);

options.test.voices(6).label = 'female-vtl';
options.test.voices(6).f0 = 151; % 6 st
options.test.voices(6).ser = 1;

options.test.voices(7).label = 'male-vtl';
options.test.voices(7).f0 = 151; % 6 st
options.test.voices(7).ser = 2^(-3.6/12);

options.test.voices(8).label = 'female-gpr-male-vtl';
options.test.voices(8).f0 = 201;
options.test.voices(8).ser = 2^(-3.6/12);

options.test.voices(9).label = 'male-gpr-female-vtl';
options.test.voices(9).f0 = 101; % 12 st
options.test.voices(9).ser = 1;

% ---- trial pairs

if is_test_machine
    options.sound_path = '~/Sounds/NVA_words/equalized';
    options.tmp_path   = '~/Sounds/NVA_words/processed';
else
    disp('-------------------------');
    disp('--- On coding machine ---');
    disp('-------------------------');
    options.sound_path = 'C:/Users/Jacqueline Libert/Documents/Sounds/NVA_words/equalized';
    options.tmp_path = 'C:/Users/Jacqueline Libert/Documents/Sounds/NVA_words/processed';
    if ~isempty(dir('../Sounds/NVA_words/equalized'))
        options.sound_path = '../Sounds/NVA_words/equalized';
        options.tmp_path = '../Sounds/NVA_words/processed';
    end

end

if isempty(dir(options.sound_path))
    error('options.sound_path cannot be empty'); 
end


if ~exist(options.tmp_path, 'dir')
    mkdir(options.tmp_path);
end

% If you leave this in, the word part above must be removed!

dir_waves = dir([options.sound_path, '/*.wav']);
word_list = {dir_waves.name};
for i= 1:length(word_list)
    word_list{i} = strrep(word_list{i}, '.wav', '');
end

options.words = word_list;
options.n_wrd = 1;

options.word_duration = 200e-3; %??
% DONT KNOW WHAT THIS DOES
options.f0_contour_step_size = 1/3; % semitones
options.f0_contours = [[-1 0 +1]; [+1 0 -1]; [-1 1 -1]+1/3; [1 -1 1]-1/3; [-1 -1 1]+1/3; [1 1 -1]-1/3; [-1 1 1]-1/3; [1 -1 -1]+1/3];

% ==================================================== Build test block
test = struct();

itrial = 0;
for ir = 1:options.test.total_ntrials 
%     condition = struct('voice', []);
        itrial = itrial + 1;
        fprintf('%i #################### %i \n', itrial, ir);
        
%         for iv = 1:size(options.test.voices,1)
        for iv = 1 : 3
            condition(itrial).voice = options.test.voices(iv);
            fprintf('%s -- %s\n', condition(itrial).voice.label, options.test.voices(iv).label);
        end
            %for iw = 1:length(options.words)
            %condition(itrial).word = options.words(iw); 
            
            % condition.i_repeat = ir;
            % end
            
end
        
%         condition.vocoder = 0;
% 
%         % Do not remove these lines
%         condition.i_repeat = ir;
%         condition.done = 0;
%         condition.attempts = 0;
% 
%         if ~isfield(test,'conditions')
%             test.conditions = orderfields(condition);
%         else
%             test.conditions(end+1) = orderfields(condition);
%         end

end

% Randomization of the order
%options.n_blocks = length(test.conditions)/options.test.block_size;
% test.conditions = test.conditions(randperm(length(test.conditions)));
% 
% % ====================================== Create the expe structure and save
% expe.test = test; 
% 
% %--
%                 
% if isfield(options, 'res_filename')
%     save(options.res_filename, 'options', 'expe');
% else
%     warning('The test file was not saved: no filename provided.');
% end
% end
% 
