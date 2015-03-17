function [expe, options] = gender_buildingconditions (options)

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

    % options.training.n_repeat = 0;
    % options.training.retry = 0 ;
    % options.training.total_ntrials = 5; % nr of trials of training

    %  training
    %  added training, maybe for young kids good to see if they understand

    % -------- Stimuli options
    options.test.f0s = [0 -6 -12];
    nF0 = length(options.test.f0s);
    options.test.vtls = [0 1.8 3.6];
    nVtls = length(options.test.vtls);
    
    if is_test_machine
        options.sound_path = '../Stimuli/equalized';
        options.tmp_path   = '../Stimuli/processed';
        options.straight_path = '~/Experiments/Beautiful/lib/STRAIGHTV40_006b';
    else
        [~, name] = system('hostname');
        if strncmp(name, '12-000-4372', 11) % PT's computer
            options.sound_path = '~/soundFiles/Sounds/NVA_words/equalized';
%             options.sound_path = '~/downloads/playSounds/monoEqualLength/';
            options.tmp_path   = '~/soundFiles/Sounds/NVA_words/processed';
        else
            options.sound_path = 'C:/Users/Jacqueline Libert/Documents/Github/Gender/Stimuli/equalized';
            options.tmp_path = 'C:/Users/Jacqueline Libert/Documents/Github/Gender/Stimuli/processed';
            options.straight_path = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/STRAIGHTV40_006b';
        end

    end

    if isempty(dir(options.sound_path))
        error('options.sound_path cannot be empty');
    end

    if ~exist(options.tmp_path, 'dir')
        mkdir(options.tmp_path);
    end

    dir_waves = dir([options.sound_path, '/*.wav']);
    word_list = {dir_waves.name};
    nWords = length(word_list);
    for word = 1 : nWords
        options.words{word} = strrep(word_list{word}, '.wav', '');
    end

    % options.n_wrd = 4;

    options.word_duration = 850e-3; % PT adapted to words
    options.lowpass = 4000;
    options.force_rebuild_sylls = 0;

    % options.f0_contour_step_size = 1/3; % semitones
    % options.f0_contours = [[-1 0 +1]; [+1 0 -1]; [-1 1 -1]+1/3; [1 -1 1]-1/3; [-1 -1 1]+1/3; [1 1 -1]-1/3; [-1 1 1]-1/3; [1 -1 -1]+1/3];

    % options.inter_triplet_interval = 250e-3;

    % ==================================================== Build test block

    options.test.faces = {'woman_1','woman_2','woman_3','woman_4','woman_5','woman_6','woman_7', ...
      'man_1','man_2','man_3','man_4','man_5','man_6','man_7'};
    indexes = repmat([1:7], 1, 4);
    indexes = indexes(randperm(length(indexes)));
    indexes(end) = [];
    indexesM = repmat([8:14], 1, 4);
    indexesM = indexesM(randperm(length(indexesM)));
    indexesM(end) = [];
    indexes = [indexes indexesM];
    indexes = indexes(randperm(length(indexes)));
    options.test.faces = options.test.faces(indexes);
    
    options.test.hands = {'handbang_', 'handremote_'}; % + 'handknob_%d';
    indexing = repmat ([1:2], 1, 27);
    indexing = indexing (randperm(length(indexes)));
    options.test.hands = options.test.hands(indexing);
    
    test = struct();

    counter = 1;
    for ir = 1 : options.test.n_repeat
        for f0 = 1 : length(options.test.f0s)
            for vtl = 1 : length(options.test.vtls)
                for word = 1 : nWords
                       
                    trial = struct();

                    trial.f0 = options.test.f0s(f0);
                    trial.vtl = options.test.vtls(vtl);
                    trial.word = options.words{word};
%                     trial.face = options.test.faces(randi([1,2],1,1)); 
                    % PT: ? % trial.start_with_standard = randi(2)-1;

                    % PT: ? % [trial.syllables, trial.proposed_syll] = get_syllable_sequence(options.syllables, options.n_syll, options.rep_min_index, options.rep_max_index, options.n_rows*options.n_cols);

                    % Order of the buttons
                    % PT: ? % trial.syll_order = randperm(options.n_rows*options.n_cols);

                    % PT: ? % trial.visual_feedback = 1;

                    % Do not remove these lines
                    trial.i_repeat = ir;
                    trial.done = 0;
                    trial.face = options.test.faces{counter};
                    trial.hands = options.test.hands{counter};
                    if ~isfield(test,'trials')
                        test.trials = orderfields(trial);
                    else
                        test.trials(end+1) = orderfields(trial);
                    end
                    counter = counter + 1;
                end
            end
        end
    end
    % test.condition = condition(randperm(length(condition)));

    % ====================================== Create the expe structure and save

    expe.test.trials = test.trials(randperm(length(test.trials)));
%     expe.(phase).trials(itrial).face
    %--

    if isfield(options, 'res_filename')
        save(options.res_filename, 'options', 'expe');
    else
        warning('The test file was not saved: no filename provided.');
    end
end

