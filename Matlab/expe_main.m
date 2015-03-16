function expe_main(options, phase)

%--------------------------------------------------------------------------
% Etienne Gaudrain <e.p.c.gaudrain@umcg.nl> - 2013-02-24
% RuG / UMCG KNO, Groningen, NL
%--------------------------------------------------------------------------

results = struct();
load(options.res_filename); % options, expe, results

[expe, options] = gender_buildingconditions;
nbreak = 0;
starting = 0;

% autoplayer = false;
% if strcmp(options.subject_name, 'tryout');
%     autoplayer = true;
% end

%% ------------- Game
[G, bkg, TVScreen, Buttonup, Buttondown, screen2, Speaker, gameCommands, Hands] = GenderGame; 
G.onMouseRelease = @buttondownfcn;

%=============================================================== MAIN LOOP
% while mean([expe.( phase ).trials.done])~=1 % Keep going while there are some trials to do 
    
     
    % If we start, display a message
    if starting == 0
        uiwait();
    end   
%         uiwait(msg.w);
%         close(msg.w);
        
%         opt = char(questdlg(sprintf('Ready to start the %s?', strrep(phase, '_', ' ')),'','Go','Cancel','Go'));
%         switch lower(opt)
%             case 'cancel'
%                 break
%         end
        
   
%%    
    % Find first trial not done
    itrial = find([expe.( phase ).trials.done]==0, 1);
    trial = expe.( phase ).trials(itrial); 
    
    

    for itrial = 1 : options.(phase).total_ntrials        
        
        TVScreen.State = 'off';
        Buttonup.State = 'off';
        Buttondown.State = 'off';
        pause(1);
        TVScreen.State = 'noise'; 
    
    % Prepare the stimulus
    [xOut, fs] = expe_make_stim(options, trial);

    if ~autoplayer
        player = audioplayer(xOut, fs, 16);
        
        pause(.5);
        iter = 1;
        
     % Play the stimulus
        playblocking(player)
        % play (player)
        while true
            TVScreen.State = 'noise'; 
            Speaker.State = ['TVSpeaker_' sprintf('%i', mod(iter, 2)+1)];
            iter = iter + 1;
            pause(0.2);
            if ~isplaying(player)
                Speaker.State = 'off';
                break;
            end
        end
        
        for handstate = 1:2
            Hands.State = sprintf('(options.test.hands)', handstate);
            pause (0.2)
        end
        
        Hands.State = 'off';
        TVScreen.State = expe.(phase).trials(itrial).face;
        pause(0.6)
        Buttonup.State = 'on';
        Buttondown.State = 'on';
        
        tic();
        
        % Collect the response
        uiwait();
        response.response_time = toc();
        response.timestamp = now();
        response.button_clicked = randi([0, 1], 1, 1); % default in case they click somewhere else
        
        % Fill the response structure
        response.button_clicked = i_clicked;
        response.trial = trial;
        
        
        % Add the response to the results structure
        if ~isfield(results, phase)
            results.( phase ).responses = orderfields( response );
        else
            results.( phase ).responses(end+1) = orderfields( response );
        end
    end
    
    % Mark the trial as done
    expe.( phase ).trials(itrial).done = 1;
    
    % Save the response
    save(options.res_filename, 'options', 'expe', 'results')
    
        if itrial == options.(phase).total_ntrials
                gameCommands.Scale = 2; 
                gameCommands.State = 'finish';
        end
    end

%% 
function buttondownfcn(hObject, callbackdata)
        
        locClick = get(hObject,'CurrentPoint');
        
        if starting == 1
            
            response.timestamp = now();
            response.response_time = toc();
            response.button_clicked = 0; % default in case they click somewhere else
            
            if (locClick(1) >= Buttonup.clickL) && (locClick(1) <= Buttonup.clickR) && ...
                    (locClick(2) >= Buttonup.clickD) && (locClick(2) <= Buttonup.clickU)
                Buttonup.State = 'press';
                response.button_clicked = 1;
            end
            
            if (locClick(1) >= Buttondown.clickL) && (locClick(1) <= Buttondown.clickR) && ...
                    (locClick(2) >= Buttondown.clickD) && (locClick(2) <= Buttondown.clickU)
                Buttondown.State = 'press'; 
                response.button_clicked = 0;
            end
            
            pause(0.5)
            
            Buttonup.State = 'off';
            Buttondown.State = 'off';
            
            fprintf('Clicked button: %d\n', response.button_clicked);
            fprintf('Trials: %d\n', itrial);
            fprintf('Response time : %d ms\n', round(response.response_time*1000));
            
            uiresume 
            
        else
             if (locClick(1) >= gameCommands.clickL) && (locClick(1) <= gameCommands.clickR) && ...
                (locClick(2) >= gameCommands.clickD) && (locClick(2) <= gameCommands.clickU)
             starting = 1;
             gameCommands.State = 'empty';
             pause (1)
             uiresume();
             end
        end
    end
   

    rmpath(spriteKitPath);
end



% If we're out of the loop because the phase is finished, tell the subject
% if mean([expe.( phase ).trials.done])==1
%     msgbox(sprintf('The "%s" phase is finished. Thank you!', strrep(phase, '_', ' ')), '', 'warn');
% end

% close all

