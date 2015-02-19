function [G, bkg, TVScreen, Buttons, screen2] = GenderGame  
%      Setup Game 
   
 %-Doesn't work: does not know getScreens 
    %[~, screen2] = getScreens();
    %fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ',screen2));
    % We put the game on screen 2
    
 %G = SpriteKit.Game.instance('Title','Gender Game', 'Size', screen2(3:4), 'Location', screen2(1:2), 'ShowFPS', false);
  G = SpriteKit.Game.instance('Title','Gender Game', 'Size', [1010 365], 'Location',[300 300] , 'ShowFPS', false);

 %bkg = SpriteKit.Background(resizeBackgroundToScreenSize(screen2, '../Images/livingroom.png'));
  bkg = SpriteKit.Background ('../Images/livingroom.png');
    addBorders(G);

%       Initiate Sprites 
%       TVScreen 
    TVScreen = SpriteKit.Sprite('tvscreen');
    initState(TVScreen,'tvscreen','../Images/tvscreen_1.png',true);
    for k=1:6
        spritename = sprintf('tvscreen_%d',k);
        pngFile = ['../Images/' spritename '.png'];
        initState(TVScreen, ['tvscreen_' int2str(k)] , pngFile, true);
    end
 % TVScreen.Location = [screen2(3)/2, screen2(4)-450]; 
 % Location probably different than above, but still like screen2/..
 TVScreen.Location = [575 250];
 TVScreen.State = 'tvscreen';
 %ratioscreentvscreen = xxx * screen2(4);
 %[HeightTVScreen, ~] = size(imread ('../Images/tvscreen_1.png'));
 %TVScreen.Scale = ratioscreentvscreen/HeightTVScreen;
 TVScreen.Scale = 0.5;
         
         
%       Buttons 
%   buttons_1 just a transparent image? 
    Buttons = SpriteKit.Sprite ('buttons'); 
    initState (Buttons, 'buttons', '../Images/buttons_1.png', true);
    for k=0:1
        spritename = sprintf ('buttons_%d', k);
        pngFile = ['../Images/' spritename '.png']; 
        initState (Buttons, ['buttons_' int2str(k)] , pngFile, true);
    end
    Buttons.Location = [900 250];
    Buttons.State = 'buttons';
    %ratioscreenbuttons = xxx * screen2(4);
    %[HeightButtons, ~] = size(imread ('../Images/buttons_0.png'));
    %Buttons.Scale = ratioscreenbuttons/HeightButtons;
    Buttons.Scale = 0.2;
end
