function options = expe_options(options)

    if is_test_machine
        options.result_path   = '~/resultsBeautiful/Gender';
        % options.straight_path = '../lib/STRAIGHTV40_006b'; 
        options.sound_path = '../Stimuli/equalized';
        options.tmp_path   = '../Stimuli/processed';
        options.straight_path = '~/Experiments/Beautiful/lib/STRAIGHTV40_006b';
    else
        [~, name] = system('hostname');
        if strncmp(name, '12-000-4372', 11) % PT's computer
            options.result_path   = '~/results/gender';
            options.sound_path = '~/gitStuff/gender/gender/Stimuli/equalized';
            options.tmp_path   = '~/gitStuff/gender/gender/Stimuli/processed';
            options.straight_path = '/home/paolot/gitStuff/Beautiful/lib/STRAIGHTV40_006b';
        else
            options.result_path   = '../results';
            options.sound_path = 'C:/Users/Jacqueline Libert/Documents/Github/Gender/Stimuli/equalized';
            options.tmp_path = 'C:/Users/Jacqueline Libert/Documents/Github/Gender/Stimuli/processed';
            options.straight_path = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/STRAIGHTV40_006b';
        end
    end

%     options.result_prefix = 'gen_';



    options.result_prefix = 'gen_';
    
    if isempty(dir(options.sound_path))
        error('options.sound_path cannot be empty');
    end

    if ~exist(options.tmp_path, 'dir')
        mkdir(options.tmp_path);
    end
    
    
    % The current status of the experiment, number of trial and phase, is
    % written in the log file. Ideally this file should be on the network so
    % that it can be checked remotely. If the file cannot be reached, the
    % program will just continue silently.
    options.log_file = fullfile('results', 'status.txt');
    
    
end
