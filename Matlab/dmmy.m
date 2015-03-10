options = [];
[expe, options] = expe_build_conditions(options);
phase = 'test';
difference = 1;
nCond = length(expe.(phase).conditions);
for iCond = 1 : nCond
    condition = expe.(phase).conditions(iCond);
    
%     u_f0  = 12*log2(options.test.voices(expe.(phase).conditions(iCond).dir_voice).f0 / ...
%         options.test.voices(expe.(phase).conditions(iCond).ref_voice).f0);
%     u_ser = 12*log2(options.test.voices(expe.(phase).conditions(iCond).dir_voice).ser / ...
%         options.test.voices(expe.(phase).conditions(iCond).ref_voice).ser);
%     % PT: why is in options.(phase).voice only phase = test used in this case?
%     u = [u_f0, u_ser];
%     u = u / sqrt(sum(u.^2));
%     [response.button_correct, player, response.trial] = expe_make_stim(options, difference, u, condition);
    
    
    
    [response.button_correct, player, response.trial] = expe_make_stim(options, condition);
end                       


sndFiles = dir([options.tmp_path '/*.wav']);
nFiles = length(sndFiles);

for ifile = 1 : nFiles
    [y, Fs] = audioread([options.tmp_path '/' sndFiles(ifile).name]);
    p = audioplayer(y, Fs);
    playblocking(p);
end