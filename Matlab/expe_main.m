function expe_main(options, phase)

%--------------------------------------------------------------------------
% Etienne Gaudrain <e.p.c.gaudrain@umcg.nl> - 2013-02-24
% RuG / UMCG KNO, Groningen, NL
%--------------------------------------------------------------------------

results = struct();
load(options.res_filename); % options, expe, results

nbreak = 0;
starting = 1;


%=============================================================== MAIN LOOP

while mean([expe.( phase ).trials.done])~=1 % Keep going while there are some trials to do
    
    
     
    % If we start, display a message
    if starting
        
%         uiwait(msg.w);
%         close(msg.w);
        
%         opt = char(questdlg(sprintf('Ready to start the %s?', strrep(phase, '_', ' ')),'','Go','Cancel','Go'));
%         switch lower(opt)
%             case 'cancel'
%                 break
%         end
        
        starting = 0;
    end
    
    % Find first trial not done
    i = find([expe.( phase ).trials.done]==0, 1);
    trial = expe.( phase ).trials(i);
    
    % Prepare the stimulus
    [xOut, fs] = expe_make_stim(options, trial);
    player = audioplayer(xOut, fs, 16);
    
    pause(.5);
    
    % Play the stimulus
    playblocking(player);
    
    tic();
    
% Already in Main loop Temp 
    % Collect the response
%     uiwait();
%     response.response_time = toc();
%     response.timestamp = now();

    
    % Fill the response structure
    response.button_correct = find(trial.syll_order==1);
    response.button_clicked = i_clicked;
    response.syll_clicked   = trial.proposed_syll{trial.syll_order(i_clicked)};
    response.correct = (response.button_clicked == response.button_correct);
    response.trial = trial;
    
    
    % Add the response to the results structure
    if ~isfield(results, phase)
        results.( phase ).responses = orderfields( response );
    else
        results.( phase ).responses(end+1) = orderfields( response );
    end
    
    % Mark the trial as done
    expe.( phase ).trials(i).done = 1;
    
    % Save the response
    save(options.res_filename, 'options', 'expe', 'results')
    
end

% If we're out of the loop because the phase is finished, tell the subject
if mean([expe.( phase ).trials.done])==1
    msgbox(sprintf('The "%s" phase is finished. Thank you!', strrep(phase, '_', ' ')), '', 'warn');
end

% close all

