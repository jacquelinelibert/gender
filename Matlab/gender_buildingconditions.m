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
    % options.test.f0s  = [242, 121]; % 242 = average pitch of original female voice
    options.test.f0s = 100*2.^([0 -6 -12]/12);
    nF0 = length(options.test.f0s);
    % options.test.sers = [1, 2^(-1.8/12), 2^(3.6/12)];
    options.test.sers = 2.^([0 1.8 3.6]/12);
    nSers = length(options.test.sers);


    if is_test_machine
        options.sound_path = '~/Sounds/NVA_words/equalized';
        options.tmp_path   = '~/Sounds/NVA_words/processed';
    else
        [~, name] = system('hostname');
        if strncmp(name, '12-000-4372', 11) % PT's computer
            options.sound_path = '~/soundFiles/Sounds/NVA_words/equalized';
            options.tmp_path   = '~/soundFiles/Sounds/NVA_words/processed';
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
    word_list = {dir_waves.name};
    nWords = length(word_list);
    for word = 1 : nWords
        options.words{word} = strrep(word_list{word}, '.wav', '');
    end

    % options.n_wrd = 4;

    options.word_duration = 3000e-3; % PT adapted to words

    % options.f0_contour_step_size = 1/3; % semitones
    % options.f0_contours = [[-1 0 +1]; [+1 0 -1]; [-1 1 -1]+1/3; [1 -1 1]-1/3; [-1 -1 1]+1/3; [1 1 -1]-1/3; [-1 1 1]-1/3; [1 -1 -1]+1/3];

    % options.inter_triplet_interval = 250e-3;

    % ==================================================== Build test block
    test = struct();


    % --- stimuli pairs
    % [f0, ser, word]
    % dont know if this is the easiest way(not the shortest), but it works (as 4x4x3 design)
    %%%%% NEEDS TO BE ADJUSTED TO SER IF THIS STAYS
    options.test.stimuli_pairs = [...
        0  0    1;  % original female voice
        0  1.8  1;
        0  3.6  1;
        6  0    1;
        6  1.8  1;
        6  3.6  1;
        12 0    1;
        12 1.8  1;
        12 3.6  1;  % male f0&VTL

        0  0    2;  % original female voice
        0  1.8  2;
        0  3.6  2;
        6  0    2;
        6  1.8  2;
        6  3.6  2;
        12 0    2;
        12 1.8  2;
        12 3.6  2;  % male f0&VTL

        0  0    3;  % original female voice
        0  1.8  3;
        0  3.6  3;
        6  0    3;
        6  1.8  3;
        6  3.6  3;
        12 0    3;
        12 1.8  3;
        12 3.6  3;  % male f0&VTL

        0  0    4;  % original female voice
        0  1.8  4;
        0  3.6  4;
        6  0    4;
        6  1.8  4;
        6  3.6  4;
        12 0    4;
        12 1.8  4;
        12 3.6  4;]; % male f0&VTL

    % itrial = 0;
    % for ir = 1:options.test.n_repeat
    %     for i_sp = 1:size(options.test.stimuli_pairs, 1)
    %         itrial = itrial + 1;
    %         condition(itrial).f0 = options.test.stimuli_pairs(i_sp, 1);
    %         condition(itrial).VTL = options.test.stimuli_pairs(i_sp, 2);
    %         condition(itrial).word = options.test.stimuli_pairs(i_sp, 3);
    %         condition(itrial).wordlabel = options.test.words{options.test.stimuli_pairs(i_sp, 3)};
    %     end
    % end
    %

    for ir = 1 : options.test.n_repeat
        for f0 = 1 : 3
            for ser = 1 : 3
                for word = 1 : nWords

                    trial = struct();

                    trial.f0 = options.test.f0s(f0);
                    trial.ser = options.test.sers(ser);
                    trial.word = options.words{word};
                    % PT: ? % trial.start_with_standard = randi(2)-1;

                    % PT: ? % [trial.syllables, trial.proposed_syll] = get_syllable_sequence(options.syllables, options.n_syll, options.rep_min_index, options.rep_max_index, options.n_rows*options.n_cols);

                    % Order of the buttons
                    % PT: ? % trial.syll_order = randperm(options.n_rows*options.n_cols);

                    % PT: ? % trial.visual_feedback = 1;

                    % Do not remove these lines
                    trial.i_repeat = ir;
                    trial.done = 0;

                    if ~isfield(test,'trials')
                        test.trials = orderfields(trial);
                    else
                        test.trials(end+1) = orderfields(trial);
                    end

                end
            end
        end
    end

    % test.condition = condition(randperm(length(condition)));

    % ====================================== Create the expe structure and save

    expe.test.trials = test.trials(randperm(length(test.trials)));

    %--

    if isfield(options, 'res_filename')
        save(options.res_filename, 'options', 'expe');
    else
        warning('The test file was not saved: no filename provided.');
    end
end

