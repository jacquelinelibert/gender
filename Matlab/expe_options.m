function options = expe_options(options)

    if is_test_machine
        options.result_path   = '~/resultsBeautiful/Gender';
        options.straight_path = '../lib/STRAIGHTV40_006b';
    else
        [~, name] = system('hostname');
        if strncmp(name, '12-000-4372', 11) % PT's computer
            options.result_path   = '~/results/gender';
            options.straight_path = '/home/paolot/gitStuff/Beautiful/lib/STRAIGHTV40_006b';
        else
            options.sound_path = 'C:/Users/Jacqueline Libert/Documents/Github/Gender/Stimuli/equalized';
            options.tmp_path = 'C:/Users/Jacqueline Libert/Documents/Github/Gender/Stimuli/processed';
            options.straight_path = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/STRAIGHTV40_006b';
        end
    end

    options.result_prefix = 'gen_';

    
    % The current status of the experiment, number of trial and phase, is
    % written in the log file. Ideally this file should be on the network so
    % that it can be checked remotely. If the file cannot be reached, the
    % program will just continue silently.
    options.log_file = fullfile('results', 'status.txt');