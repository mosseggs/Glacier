% P2 Matlab script Crawdads
% Clean up commands
clc;
clear;
close;
%% Connect to the Arduino
X = serialportlist();
P = X(end);
% If this doesn't work for you, refer to the debugging section for a solution
% Open up a serial connection to the Arduino over that port
ArduinoObj = serialport(P, 9600);
fig = uifigure("Color","#69deff");
fig.Position(3:4) = [800,600];
txt = uitextarea(fig,"Position",[0,000,800,600],'FontSize', 30);
txt.BackgroundColor = "#69deff";
txt.Value = ["";"";"Welcome to Float a Glacier!";"Press the middle button to continue"];
txt.HorizontalAlignment = "center";
timerStart = false;
trivia_time = 10;
while(1)
%% Retrieve latest message from Serial Port
   % The arduino is set up to constantly send the potentiometer
   % postion to the serial monitor so we'll need to deal with this.
   % Clear the serial port buffer
      flush(ArduinoObj); 
      disp(readline(ArduinoObj));
      letters = sscanf(readline(ArduinoObj), 'Q:%d A:%d C:%d P:%d T:%d ');
      state = letters(1);
      answered = letters(2);
      correct = letters(3);
      points = letters(4);
      time = letters(5)/1000;
      cortext = "Sadly you got it incorrect.";
      if(correct == 1)
           cortext = "You got it correct!";
      end
   
   % Now read the latest line written to the serial monitor
   % The command will wait 10 seconds before timing out so your
   % Arduino has that long to send another line of data.
   if (state == 1 && answered == 0)
       txt.BackgroundColor = "#69deff";
       txt.Value = ["";points;time;"The top 100 companies produce ___ % of the harmful gasses causing global warming produced since 1988.";"";"";
           "71     92     1"];
   elseif (state == 1 && answered == 1)
      if(correct)
           txt.BackgroundColor = "#6cf084";
      else
          txt.BackgroundColor = "#c23a3a";
      end
       txt.Value = ["";points;cortext;"According to the The Carbon Majors Database, about 100 companies have caused roughly 71% of the green house gasses since 1988";"";"";
           "The biggest producer is China Coal, with 14.3% being produced from them!"; "";""];
      
      if(timerStart == false)
          tic
          a = tic;
          timerStart = true;
      elseif (timerStart == true)
          if(int8(toc(a)) >= trivia_time)
           writeline(ArduinoObj, sprintf("a%i",state + 1));
           timerStart = false;
          end
      end
     
   elseif (state == 2 && answered == 0)
       txt.BackgroundColor = "#69deff";
       txt.Value = [""; points;time; "On average, How much has the fish population decreased in the past 100 years?"; "";"";
           "20%     4%     100%"];
   elseif (state == 2 && answered == 1)
       if(correct)
           txt.BackgroundColor = "#6cf084";
      else
          txt.BackgroundColor = "#c23a3a";
      end
       txt.Value = ["";points;cortext;"According to a 2019 study, The world's fish population has decreased by 4%.";"";"";
           "However, that's just a world average. In places like the UK, it has decreased by up to as high as 35%!"];
       if(timerStart == false)
          tic
          a = tic;
          timerStart = true;
      elseif (timerStart == true)
          if(int8(toc(a)) >= trivia_time)
           writeline(ArduinoObj, sprintf("a%i",state + 1));
           timerStart = false;
          end
      end
   elseif (state == 3 && answered == 0)
       txt.BackgroundColor = "#69deff";
       %There is some joke here about knowing your rights
       txt.Value = [""; points;time; "Why do polar bears rely on ice? "; "";"";
           "They like the cold    The ice is their wife    It helps grow cubs and find food"];
   elseif (state == 3 && answered == 1)
       if(correct)
           txt.BackgroundColor = "#6cf084";
      else
          txt.BackgroundColor = "#c23a3a";
      end
       txt.Value = [""; points;cortext;"Polar bears enjoy the ice"; "Mainly because it helps find food and help raise their young"; ""; "";
           "Without these glaciers," ; "They need to look farther for food, and possibly relocate."];
       if(timerStart == false)
          tic
          a = tic;
          timerStart = true;
      elseif (timerStart == true)
          if(int8(toc(a)) >= trivia_time)
           writeline(ArduinoObj, sprintf("a%i",state + 1));
           timerStart = false;
          end
       end
   elseif (state == 4 && answered == 0)
       txt.BackgroundColor = "#69deff";
       %There is some joke here about knowing your rights
       txt.Value = [""; points;time; "How can you help prevent climate change? "; "";"";
           "Burn plastic    Turn off the lights    Eat glue"];
   elseif (state == 4 && answered == 1)
       if(correct)
           txt.BackgroundColor = "#6cf084";
      else
          txt.BackgroundColor = "#c23a3a";
      end
       txt.Value = [""; points;cortext;"One way you can help solve climate change"; "is to make sure to turn off the lights when you aren't using them"; ""; "";
           "Other initiatives that work are" ; "Spreading the word, and following Reduce Reuse Recycle."];
       if(timerStart == false)
          tic
          a = tic;
          timerStart = true;
      elseif (timerStart == true)
          if(int8(toc(a)) >= trivia_time)
           writeline(ArduinoObj, sprintf("a%i",state + 1));
           timerStart = false;
          end
       end
   elseif (state == 5 && answered == 0)
       txt.BackgroundColor = "#69deff";
       %There is some joke here about knowing your rights
       txt.Value = [""; points;time; "How does glacier melting affect fish? "; "";"";
           "Alters their water's natural state    Gives them food    The fish grow tails"];
   elseif (state == 5 && answered == 1)
       if(correct)
           txt.BackgroundColor = "#6cf084";
      else
          txt.BackgroundColor = "#c23a3a";
      end
       txt.Value = [""; points;cortext;"Fish don't enjoy melting glaciers"; "Mainly because it changes their water's temperature, causing them to relocate"; ""; "";
           "These relocating fish then make the local predators in the area" ; "have to change diets due to the lack of fish."];
       if(timerStart == false)
          tic
          a = tic;
          timerStart = true;
      elseif (timerStart == true)
          if(int8(toc(a)) >= trivia_time)
           writeline(ArduinoObj, sprintf("a%i",state + 1));
           timerStart = false;
          end
       end
   elseif (state == 0)
       txt.BackgroundColor = "#69deff";
       txt.Value = ["";"";"Welcome to Float a Glacier!";"Press the middle button to continue"];
   end
   pause(.1); % Slow down to make output readable
end
