function [i_correct, player, trial] = expe_make_stim_rm(options, condition)

    dir_waves = dir([options.sound_path, '/*.wav']);
    syllable_list = {dir_waves.name};
    for i= 1:length(syllable_list)
        syllable_list{i} = strrep(syllable_list{i}, '.wav', '');
    end
    
    % Prepare the trial
    trial = condition;
    
% PT: this is left over from fishy
%     % Compute test voice
%     new_voice_st = difference*u;
%     trial.f0 = options.test.voices(trial.ref_voice).f0 * [1, 2^(new_voice_st(1)/12)];
%     trial.ser = options.test.voices(trial.ref_voice).ser * [1, 2^(new_voice_st(2)/12)];
%     Compute test voice
    
    trial.f0 = options.test.voices(trial.ref_voice).f0;
    trial.ser = options.test.voices(trial.ref_voice).ser;
    
    ifc = randperm(size(options.f0_contours, 1));
    trial.f0_contours = options.f0_contours(ifc(1:3), :);
    
    isyll = randperm(length(options.syllables));
    for i_int=1:3
        trial.syllables{i_int} = options.syllables(isyll(1:options.n_syll));
    end

    xOut = {};

    f0 = [trial.f0(1), trial.f0(1), trial.f0(2)];
    % ser = [trial.ser(1), trial.ser(1), trial.ser(2)];
    % SER is defined as VTL
    
 
    for i=1:length(trial.syllables)

        sylls = trial.syllables{i};
        x = [];

        for j=1:length(sylls)


%             sf0 = f0(i)*2^(options.f0_contour_step_size*trial.f0_contours(j)/12);
% PT: not necessary anymore, but what about the function using this output then?           
            disp(sylls{j})
            
%             [y, fs] = straight_process(sylls{j}, sf0, ser(i), options); %
%             PT: this is old code lewft over from fishy

            [y, fs] = straight_process(sylls{j}, nb_st, ser(i), options);
            if fs~=options.fs
                y = resample(y, options.fs, fs);
                fs = options.fs;
            end

            dl = round(options.syllable_duration*fs) - length(y);
            if dl>0
                npad_L = floor(dl/20);
                npad_R = dl-npad_L;
                nr = floor(1e-3*fs);
                y(1:nr) = y(1:nr) .* linspace(0, 1, nr)';
                y(end-nr+1:end) = y(end-nr+1:end) .* linspace(1, 0, nr)';
                y = [zeros(npad_L,1); y; zeros(npad_R,1)];
            elseif dl<0
                y = y(1:end-dl);
                nr = floor(1e-3*fs); % 1 ms linear ramp at the end
                y(end-nr+1:end) = y(end-nr+1:end) .* linspace(1, 0, nr)';
            else
                nr = floor(1e-3*fs);
                y(1:nr) = y(1:nr) .* linspace(0, 1, nr)';
                y(end-nr+1:end) = y(end-nr+1:end) .* linspace(1, 0, nr)';
            end 

            x = [x; y];

            if j~=length(sylls)
                x = [x; zeros(floor(fs*options.inter_syllable_silence), 1)];
            end
        end

        if trial.vocoder>0
            [x, fs] = vocode(x, fs, options.vocoder(trial.vocoder).parameters);
        end

        x = x(:);

        % Apply a 1 ms ramp to avoid clicking
        nrmp = floor(fs/1000);
        x(1:nrmp) = x(1:nrmp) .* linspace(0,1,nrmp)';
        x(end-nrmp+1:end) = x(end-nrmp+1:end) .* linspace(1,0,nrmp)';

        switch options.ear
            case 'right'
                x  = [zeros(size(x)), x];
            case 'left'
                x = [x, zeros(size(x))];
            case 'both'
                x = repmat(x, 1, 2);
            otherwise
                error(sprintf('options.ear="%s" is not implemented', options.ear));
        end
        
        xOut{i} = x;
    end

    rng('shuffle');

    i_order = randperm(length(xOut));
    xOut = xOut(i_order);

    i_correct = find(i_order==3);
    player = {};
    for i=1:length(xOut)
        x = xOut{i}*10^(-options.attenuation_dB/20);
        player{i} = audioplayer([zeros(1024*3, 2); x; zeros(1024*3, 2)], fs, 16);
        fprintf('Interval %d max: %.2f\n', i, max(abs(x(:))));
    end

end        

%--------------------------------------------------------------------------
function fname = make_fname(wav, f0, vtl, d, destPath)

    [~, name, ext] = fileparts(wav);

    if isnan(d)
        fname = sprintf('%s_GPR%d_VTL%.2f', name, floor(f0), vtl);
    else
        fname = sprintf('%s_GPR%d_VTL%.2f_D%d', name, floor(f0), vtl, floor(d*1e3));
    end
    fname = fullfile(destPath, [fname, ext]);
end

%--------------------------------------------------------------------------
function [y, fs] = straight_process(syll, nb_st, vtl, options)
% nb_st should be in negative values (e.g.: 0, -6, -12) 

    wavIn = fullfile(options.sound_path, [syll, '.wav']);
%     wavOut = make_fname(wavIn, t_f0, ser, options.syllable_duration, options.tmp_path);
    wavOut = make_fname(wavIn, nb_st, vtl, NaN, options.tmp_path); % PT: modified according to EG e-mail to JL

    if ~exist(wavOut, 'file') || options.force_rebuild_sylls

        if is_test_machine()
            straight_path = '../lib/STRAIGHTV40_006b';
        else
            [~, name] = system('hostname');
            if strncmp(name, '12-000-4372', 11)
                straight_path = '/home/paolot/gitStuff/Beautiful/lib/STRAIGHTV40_006b';
            else
                straight_path = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/STRAIGHTV40_006b';
            end
        end
        addpath(straight_path);

        mat = strrep(wavIn, '.wav', '.straight.mat');

        if exist(mat, 'file')
            load(mat);
        else
            [x, fs] = audioread(wavIn);
            % remove the stereo channel if present the files for gender are
            % mono anyway, the second channel is empty
            x(:, 2) = [];
            x = squeeze(x); % PT: just to make sure
            
            [f0, ap] = exstraightsource(x, fs);
            %old_f0 = f0;
            %f0(f0<80) = 0;

            sp = exstraightspec(x, f0, fs);
            x_rms = rms(x);

            save(mat, 'fs', 'f0', 'sp', 'ap', 'x_rms');
        end

%         mf0 = exp(mean(log(f0(f0~=0))));

        % f0(f0~=0) = f0(f0~=0) / mf0 * t_f0;
        f0(f0~=0) = f0(f0~=0) * 2^(nb_st/12);
        %p.timeAxisMappingTable = (d*1e3)/length(f0);
        ser = 2 ^ -(vtl/12);
        p.frequencyAxisMappingTable = ser;
        y = exstraightsynth(f0, sp, ap, fs, p);

        y = y/rms(y)*x_rms;
        if max(abs(y))>1
            warning('Output was renormalized for "%s".', wavOut);
            y = 0.98*y/max(abs(y));
        end

        %     wavwrite(y, fs, wavOut);
        audiowrite(wavOut, y, fs);

        rmpath(straight_path);
    else
        %     [y, fs] = wavread(wavOut);
        [y, fs] = audioread(wavOut);
    end
end
