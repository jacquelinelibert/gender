function [G, bkg, TVScreen, Buttonup, Buttondown, screen2, Speaker, gameCommands, Hands] = GenderGame  
%      Setup Game 

[~, name] = system('hostname');
%     if strncmp(name, '12-000-4372', 11)
%         %spriteKitPath = '/home/paolot/gitStuff/Beautiful/lib/SpriteKit';
%         spriteKitPath = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/SpriteKit';
%      else
%          spriteKitPath = '/Users/laptopKno/Github/Beautiful/lib/Spritekit'; 
%     end
    spriteKitPath = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/SpriteKit';
    addpath(spriteKitPath);

[~, screen2] = getScreens();
fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ',screen2));
% We put the game on screen 2

% [HeightBackground, WidthBackground] = size(imread('../Images/genderbackground3_unscaled.png'));

G = SpriteKit.Game.instance('Title','Gender Game', 'Size', [screen2(3)/1.3, screen2(4)/1.2], 'Location', screen2(1:2), 'ShowFPS', false);

% bkg = SpriteKit.Background(resizeBackgroundToScreenSize(screen2, '../Images/genderbackground1_unscaled.png'));
bkg = SpriteKit.Background('../Images/genderbackground3_unscaled.png');
% addBorders(G);

%-----  Initiate Sprites -----%

%       TVScreen 
 TVScreen = SpriteKit.Sprite('tvscreen');
 TVScreen.initState('off', ones(1,1,3),true); % whole screen green
 TVScreen.initState ('noise', '../Images/TVScreen_noise.png', true);
 for iwoman=1:3
     spritename = sprintf('TVwoman_%d',iwoman);
     pngFile = ['../Images/' spritename '.png'];
     TVScreen.initState(spritename , pngFile, true);
 end
 for iman = 1:2
      spritename = sprintf('TVman_%d', iman);
      pngFile = ['../Images/' spritename '.png'];
      TVScreen.initState (spritename, pngFile, true);
  end
 TVScreen.Location = [screen2(3)/2.58, screen2(4)/2.15];
 TVScreen.State = 'TVman_2';
%  TVScreen.Scale = 1.2
%  ratioscreentvscreen = 0.81 * screen2(3);
%  [~, WidthTVScreen] = size(imread ('../Images/TVwoman_1.png'));
%  [HeightBackground, WidthBackground] = size (imread ('../Images/genderbackground1_unscaled.png')); 
%  TVScreen.Scale = ratioscreentvscreen/WidthTVScreen;

 %      Speaker
 Speaker = SpriteKit.Sprite ('speaker');
 Speaker.initState ('off', ones(1,1,3), true);
 Speaker.initState ('small', ['../Images/' 'TVSpeaker_1' '.png'], true);
 Speaker.initState ('big', ['../Images/' 'TVSpeaker_2' '.png'], true);
 Speaker.Location = [screen2(3)/2.06, screen2(4)/2.47];
 Speaker.State = 'small';
 
 %       Buttons 
 Buttonup = SpriteKit.Sprite ('buttonup');
 Buttonup.initState ('on','../Images/buttonup_1.png', true);
 Buttonup.initState('press', '../Images/buttonuppress_1.png', true)
 Buttonup.initState ('off', ones(1,1,3), true);
 Buttonup.Location = [screen2(3)/1.65, screen2(4)/5.5];
 Buttonup.State = 'on';
 [HeightButtonup, WidthButtonup] = size(imread ('../Images/buttonup_1.png'));
 
 addprop(Buttonup, 'clickL');
 addprop(Buttonup, 'clickR');
 addprop(Buttonup, 'clickD');
 addprop(Buttonup, 'clickU');
 Buttonup.clickL = round(Buttonup.Location(1) - round(HeightButtonup/2));
 Buttonup.clickR = round(Buttonup.Location(1) + round(HeightButtonup/2));
 Buttonup.clickD = round(Buttonup.Location(2) - round(WidthButtonup/2));
 Buttonup.clickU = round(Buttonup.Location(2) + round(WidthButtonup/2));
 Buttonup.Depth = 2;
 
 Buttondown = SpriteKit.Sprite ('buttondown');
 Buttondown.initState ('on','../Images/buttondown_1.png', true);
 Buttondown.initState ('press', '../Images/buttondownpress_1.png', true);
 Buttondown.initState ('off', ones(1,1,3), true);
 Buttondown.Location = [screen2(3)/1.40, screen2(4)/5.5];
 Buttondown.State = 'on';
 [HeightButtondown, WidthButtondown] = size(imread ('../Images/buttondown_1.png'));
 
 addprop(Buttondown, 'clickL');
 addprop(Buttondown, 'clickR');
 addprop(Buttondown, 'clickD');
 addprop(Buttondown, 'clickU');
 Buttondown.clickL = round(Buttondown.Location(1) - round(HeightButtondown/2));
 Buttondown.clickR = round(Buttondown.Location(1) + round(HeightButtondown/2));
 Buttondown.clickD = round(Buttondown.Location(2) - round(WidthButtondown/2));
 Buttondown.clickU = round(Buttondown.Location(2) + round(WidthButtondown/2));
 Buttondown.Depth = 2;
 
 %      Start and finish     
 gameCommands = SpriteKit.Sprite('controls');
 initState(gameCommands, 'begin','../Images/start.png' , true);
 initState(gameCommands, 'finish','../Images/finish.png' , true);
 initState(gameCommands, 'empty', ones(1,1,3), true); % to replace the images, 'none' will give an annoying warning
 gameCommands.State = 'empty';
 gameCommands.Location = [screen2(3)/2, screen2(4)/2];
 gameCommands.Scale = 1.3; % make it bigger to cover fishy
 % define clicking areas
 clickArea = size(imread('../Images/start.png'));
 addprop(gameCommands, 'clickL');
 addprop(gameCommands, 'clickR');
 addprop(gameCommands, 'clickD');
 addprop(gameCommands, 'clickU');
 gameCommands.clickL = round(gameCommands.Location(1) - round(clickArea(1)/2));
 gameCommands.clickR = round(gameCommands.Location(1) + round(clickArea(1)/2));
 gameCommands.clickD = round(gameCommands.Location(2) - round(clickArea(2)/4));
 gameCommands.clickU = round(gameCommands.Location(2) + round(clickArea(2)/4));
 clear clickArea
 gameCommands.Depth = 10;
    
  %     Hands 
  Hands = SpriteKit.Sprite ('hands');
  Hands.initState ('off', ones (1,1,3), true);
  for ihandbang = 2:3
      spritename = sprintf('handbang_%d',ihandbang);
      pngFile = ['../Images/' spritename '.png'];
      Hands.initState(spritename , pngFile, true);
      Hands.Location = [screen2(3)/1.6, screen2(4)/1.4];
  end
%   for ihandknob = 1:3
%       spritename = sprintf('handknob_%d',ihandknob);
%       pngFile = ['../Images/' spritename '.png'];
%       Hands.initState(spritename , pngFile, true);
%       Hands.Location = [screen2(3)/1.75, screen2(4)/1.55]; % for handknob
%   end
  for ihandremote = 1:2
      spritename = sprintf('handremote_%d', ihandremote);
      pngFile = ['../Images/' spritename '.png'];
      Hands.initState (spritename, pngFile, true);
      Hands.Location = [screen2(3)/4.5, screen2(4)/6.5]; % for handremote
  end
  Hands.State = 'handremote_2';
  Hands.Location = [screen2(3)/6.5, screen2(4)/4.5]; % for handremote
end
