function [expe, options] = expe_build_conditions(options)

%--------------------------------------------------------------------------
% Etienne Gaudrain <etienne.gaudrain@mrc-cbu.cam.ac.uk>
% 2010-03-15, 2011-10-20
% Medical Research Council, Cognition and Brain Sciences Unit, UK
% --
% Etienne Gaudrain <e.p.c.gaudrain@umcg.nl>
% 2013-10-31
% University Medical Center Groningen, NL
%--------------------------------------------------------------------------



%----------- Signal options
options.fs = 44100;
if is_test_machine
    options.attenuation_dB = 3;  % General attenuation
else
    options.attenuation_dB = 27; % General attenuation
end
options.ear = 'both'; % right, left or both


%----------- Stimuli options
% PT: these 2 are never used
% options.test.f0s  = [242, 121, round(242*2^(5/12))]; % 242 = average pitch of original female voice
% options.test.sers = [1, 2^(-3.8/12), 2^(5/12)]; 

options.test.VTL = [0, 1.8, 3.6];
options.test.sers = 2 .^ (-options.test.VTL ./ 12);
options.test.f0s = [0, 6, 12];

options.test.voices(1).label = 'female';
options.test.voices(1).f0 = 242;
options.test.voices(1).ser = 1;

options.test.voices(2).label = 'male';
options.test.voices(2).f0 = 121;
options.test.voices(2).ser = 2^(-3.8/12);

options.test.voices(3).label = 'child';
options.test.voices(3).f0 = round(242*2^(5/12));
options.test.voices(3).ser = 2^(7/12);

options.test.voices(4).label = 'male-gpr';
options.test.voices(4).f0 = 121;
options.test.voices(4).ser = 1;

options.test.voices(5).label = 'male-vtl';
options.test.voices(5).f0 = options.test.voices(1).f0;
options.test.voices(5).ser = 2^(-3.8/12);

options.test.voices(6).label = 'child-gpr';
options.test.voices(6).f0 = round(242 * 2^(5/12));
options.test.voices(6).ser = 1;

options.test.voices(7).label = 'child-vtl';
options.test.voices(7).f0 = options.test.voices(1).f0;
options.test.voices(7).ser = 2^(7/12);

options.training.voices = options.test.voices;

%--- Voice pairs
% [ref_voice, dir_voice]
options.test.voice_pairs = [...
%     1 2;  % Female -> Male
    1 4;  % Female -> Male GPR % only these two
    1 5;  % Female -> Male VTL % only these two
%     1 3;  % Female -> Child
%     1 6;  % Female -> Child GPR
%     1 7;  % Female -> Child VTL
%     2 1;  % Male   -> Female
%     2 4;  % Male   -> Male GPR (is Female VTL)
%     2 5;  % Male   -> Male VTL (is Female GPR)
%     3 1;  % Child  -> Female
%     3 6;  % Child  -> Child GPR (is Female VTL)
%     3 7; % Child  -> Child VTL (is Female GPR)

];

options.training.voice_pairs = [...
    1 5;  % Female -> Male VTL
    1 4]; % Female -> Male GPR

if is_test_machine
    options.sound_path = '~/Sounds/Dutch_CV/equalized';
    options.tmp_path   = '~/Sounds/Dutch_CV/processed';
else
    [~, name] = system('hostname');
    if strncmp(name, '12-000-4372', 11) % PT's computer
        options.sound_path = '/home/paolot/soundFiles/Sounds/NVA_words/equalized';
        options.tmp_path = '/home/paolot/soundFiles/Sounds/NVA_words/processed';
    else
        options.sound_path = 'C:/Users/Jacqueline Libert/Documents/Sounds/NVA_words/equalized';
        options.tmp_path = 'C:/Users/Jacqueline Libert/Documents/Sounds/NVA_words/processed';
    end
end

if isempty(dir(options.sound_path))
    error('options.sound_path cannot be empty'); 
end


if ~exist(options.tmp_path, 'dir')
    mkdir(options.tmp_path);
end 

dir_waves = dir([options.sound_path, '/*.wav']);
syllable_list = {dir_waves.name};
options.n_syll = length(syllable_list);
for i = 1 : options.n_syll
    syllable_list{i} = strrep(syllable_list{i}, '.wav', '');
end

options.syllables = syllable_list;


options.inter_syllable_silence = 50e-3;
% options.syllable_duration = 200e-3;
options.syllable_duration = 3000e-3; % PT adapted to words

options.f0_contour_step_size = 1/3; % semitones
options.f0_contours = [[-1 0 +1]; [+1 0 -1]; [-1 1 -1]+1/3; [1 -1 1]-1/3; [-1 -1 1]+1/3; [1 1 -1]-1/3; [-1 1 1]-1/3; [1 -1 -1]+1/3];

options.inter_triplet_interval = 250e-3;

options.force_rebuild_sylls = 0;


%==================================================== Build test block

test = struct();

for i_vp = 1:size(options.test.voice_pairs, 1)
    
    condition = struct();
    
    condition.ref_voice = options.test.voice_pairs(i_vp, 1);
    condition.dir_voice = options.test.voice_pairs(i_vp, 2);
    
    condition.vocoder = 0;
    
    condition.visual_feedback = 1;
    
    % Do not remove these lines
    condition.done = 0;
    condition.attempts = 0;
    
    if ~isfield(test,'conditions')
        test.conditions = orderfields(condition);
    else
        test.conditions(end+1) = orderfields(condition);
    end
    
end

% Randomization of the order
%options.n_blocks = length(test.conditions)/options.test.block_size;
test.conditions = test.conditions(randperm(length(test.conditions)));

%================================================== Build training block

training = struct();

for i_vp = 1:size(options.training.voice_pairs, 1)
    
    condition = struct();
    
    condition.ref_voice = options.training.voice_pairs(i_vp, 1);
    condition.dir_voice = options.training.voice_pairs(i_vp, 2);
    
    condition.vocoder = 0;
    
    condition.visual_feedback = 1;
    
    % Do not remove these lines
    condition.done = 0;
    condition.attempts = 0;
    
    if ~isfield(training,'conditions')
        training.conditions = orderfields(condition);
    else
        training.conditions(end+1) = orderfields(condition);
    end
    
end

% Randomization of the order
%training.conditions = training.conditions(randperm(length(training.conditions)));

%====================================== Create the expe structure and save

expe.test = test;
expe.training = training;

%--
                
if isfield(options, 'res_filename')
    save(options.res_filename, 'options', 'expe');
else
    warning('The test file was not saved: no filename provided.');
end



