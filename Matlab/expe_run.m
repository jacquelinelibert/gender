function expe_run(varargin)
%   function expe_run(subject, phase)
%   phase can be: 'training', 'test'
%   expe_run('tryout', 'testing')


    subject = 'tryout';
    phase = 'test';
    if nargin > 0
        subject = varargin{1};
        phase = varargin{2};
    end


    options = struct();
    options = expe_options(options);

    options.subject_name  = subject;
    options.result_prefix = 'gen_';

    %-------------------------------------------------
    added_path  = {};
    for i=1:length(added_path)
        addpath(added_path{i});
    end
    %-------------------------------------------------

    if exist(options.result_path, 'dir')
        mkdir(options.result_path);
    end

    res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, subject));
    options.res_filename = res_filename;
    opt = 'OK';
    if ~exist(res_filename, 'file')
        if nargin > 1
            opt = char(questdlg(sprintf('The subject "%s" doesn''t exist. Create it?', subject),'CRM','OK','Cancel','OK'));
        end
        switch opt
            case 'OK',
                [expe, options] = gender_buildingconditions(options);
            case 'Cancel'
                return
        end
    else
        if nargin > 1
            opt = char(questdlg(sprintf('Found "%s". Use this file?', res_filename),'CRM','OK','Cancel','OK'));
            switch opt
                case 'OK',
                    load(options.res_filename); % options, expe, results
                case 'Cancel'
                    return
            end
        end
        
    end

    expe_main(expe, options, phase);

    %-------------------------------------------------
    for i=1:length(added_path)
        rmpath(added_path{i});
    end
end