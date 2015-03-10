function expe_run(varargin)
% function expe_run(subject, phase)
% expe_run('tryout', 'testing')

    
    subject = 'tryout';
    phase = 'test';
    if nargin > 0
        subject = varargin{1};
        phase = varargin{2};
    end    
% expe_run(subject, phase)
%   phase can be: 'training', 'test'

%--------------------------------------------------------------------------
% Etienne Gaudrain <etienne.gaudrain@mrc-cbu.cam.ac.uk> - 2010-03-16
% Medical Research Council, Cognition and Brain Sciences Unit, UK
%--------------------------------------------------------------------------

options = struct();
options = expe_options(options);
options.result_path = 'C:\Users\Jacqueline Libert\Documents\GitHub\Gender\Results';

options.subject_name  = subject;

%-------------------------------------------------
% Set appropriate path

current_dir = fileparts(mfilename('fullpath'));
added_path  = {};

% added_path{end+1} = '../lib/SpriteKit';
added_path{end+1} = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/SpriteKit';
for i=1:length(added_path)
    addpath(added_path{i});
end

%-------------------------------------------------

% Create result dir if necessary
if exist(options.result_path, 'dir')
    mkdir(options.result_path);
end

res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, subject));
options.res_filename = res_filename;
opt = 'ok';
if ~exist(res_filename, 'file')
    if nargin > 1
        opt = char(questdlg(sprintf('The subject "%s" doesn''t exist. Create it?', subject),'CRM','OK','Cancel','OK'));
    end
    switch lower(opt)
        case 'ok',
            gender_buildingconditions(options);
        case 'cancel'
            return
        otherwise
            error('Unknown option: %s',opt)
    end
else
    if nargin > 1
        opt = char(questdlg(sprintf('Found "%s". Use this file?', res_filename),'CRM','OK','Cancel','OK'));
    end
    if strcmpi(opt, 'Cancel')
        return
    end
end

expe_main(options, phase);

%------------------------------------------
% Clean up the path

for i=1:length(added_path)
    rmpath(added_path{i});
end
