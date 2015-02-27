options = [];
[expe, options] = expe_build_conditions(options);
phase = 'test';
difference = options.(phase).starting_difference;
condition = expe.(phase).conditions(1);

u_f0  = 12*log2(options.test.voices(condition.dir_voice).f0 / options.test.voices(condition.ref_voice).f0);
u_ser = 12*log2(options.test.voices(condition.dir_voice).ser / options.test.voices(condition.ref_voice).ser);
% PT: why is in options.(phase).voice only phase = test used in this case?
u = [u_f0, u_ser];
u = u / sqrt(sum(u.^2));



[response.button_correct, player, isi, response.trial] = expe_make_stim(options, difference, u, condition);
                       
