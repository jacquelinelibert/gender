function MainLoop_temp 
[expe, options] = gender_buildingconditions;

phase = 'test';
starting = 0; 

% ------------- Game 
[G, bkg, TVScreen, Buttonup, Buttondown, screen2, Speaker, gameCommands, Hands] = GenderGame; 
G.onMouseRelease = @buttondownfcn;

% ----------- Main Loop 
for itrial = 1 : options.(phase).total_ntrials 
        
         
        if ~simulateSubj
            while starting == 0
                uiwait();
            end
        end       
        
        TVScreen.State = 'off';
        Buttonup.State = 'off';
        Buttondown.State = 'off';
        pause(1);
        TVScreen.State = 'noise'; 
       
% ------ play random one of stimuli from list 

        player = audioplayer(y, Fs);
        iter = 1;
        play(player)
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

        
        TVScreen.State = expe.(phase).trials(itrial).face;
        pause(0.6)
        Buttonup.State = 'on';
        Buttondown.State = 'on';

        tic();
        if ~simulateSubj
            uiwait();
        else
            response.timestamp = now();
            response.response_time = toc();
            response.button_clicked = randi([0, 1], 1, 1); % default in case they click somewhere else
        end
        
        resp(itrial).response = response;
        resp(itrial).condition = expe.(phase).condition(itrial);
        resp(itrial).phase = phase;
        
        save (options.res_filename, 'options', 'expe', 'results');
        
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
   
end


     
% response_accuracy = [response_accuracy, response.correct]; 
% resp = repmat(struct(response.button_clicked, 0), 1);
