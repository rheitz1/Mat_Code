% These parameters are used when DEBUG = 2.
clear tempo_simulation;
start = GetSecs; % Defines the start time of videoTempoNet.
i = 1; % Start i = 1 and increment for as many uncommented lines below.  Easier than always changign the indexing.
if (0) % Just for convenience, make it "if (1)" to do rf_mac simulation, and make it "if (0)" to do calibeye_mac simulation.
    tempo_simulation(i) = struct('command','return_main_loop_mac;','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','background_color_mac(127,127,127);','start',2.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rf_mac;','start',3.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','clear_screen_mac;','start',8.0,'flag',0); i = i + 1;
elseif (0)
    tempo_simulation(i) = struct('command','background_color_mac(127,127,127);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''T'',200,100);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''Y'',400,100);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''U'',600,100);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''G'',200,300);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''H'',400,300);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''J'',600,300);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''B'',200,500);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''N'',400,500);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''M'',600,500);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','T;','start',3.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','Y;','start',3.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','U;','start',4.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','G;','start',4.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','H;','start',5.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',5.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',6.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','N;','start',6.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','M;','start',7.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','erase_all_mac;','start',8.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','clear_screen_mac;','start',8.0,'flag',0); i = i + 1;
elseif (0)
    tempo_simulation(i) = struct('command','erase_all_mac;','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','fixation_color_mac(175,175,175);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','background_color_mac(103,103,103);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sp(200,300);','start',1.2,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sw(100);','start',1.2,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''I'',103);','start',1.2,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''B'',90);','start',1.2,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''J'',75);','start',1.2,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',3.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',3.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',3.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',4.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',4.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',4.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',5.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',5.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',5.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',6.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',6.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',6.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',7.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',7.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',7.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',8.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',8.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',8.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',9.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',10.1,'flag',0); i = i + 1;
elseif (0)
    tempo_simulation(i) = struct('command','return_main_loop_mac;','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','erase_all_mac;','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','background_color_mac(127,127,127);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rf_mac;','start',3.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','clear_screen_mac;','start',8.0,'flag',0); i = i + 1;

    tempo_simulation(i) = struct('command','return_main_loop_mac;','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','erase_all_mac;','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','background_color_mac(127,127,127);','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''T'',200,100);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''Y'',400,100);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''U'',600,100);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''G'',200,300);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''H'',400,300);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''J'',600,300);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''B'',200,500);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''N'',400,500);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','calibeye_mac(''M'',600,500);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','T;','start',13.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','Y;','start',13.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','U;','start',14.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','G;','start',14.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','H;','start',15.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',15.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',16.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','N;','start',16.5,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','M;','start',17.0,'flag',0); i = i + 1;

    tempo_simulation(i) = struct('command','return_main_loop_mac;','start',18.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','erase_all_mac;','start',18.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','background_color_mac(103,103,103);','start',18.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','fixation_color_mac(175,175,175);','start',19.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sp(200,300);','start',20,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sw(100);','start',20,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''I'',103);','start',21.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''B'',90);','start',21.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''J'',75);','start',21.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',23.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',23.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',23.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',24.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',24.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',24.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',25.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',25.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',25.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',26.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',26.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',26.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',27.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',27.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',27.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',28.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',28.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',28.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',29.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',29.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',29.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',30.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',30.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',30.1,'flag',0); i = i + 1;

    tempo_simulation(i) = struct('command','clear_screen_mac;','start',31.0,'flag',0); i = i + 1;
elseif (1)
    tempo_simulation(i) = struct('command','return_main_loop_mac;','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','erase_all_mac;','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','background_color_mac(127,127,127);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rf_mac;','start',3.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','clear_screen_mac;','start',8.0,'flag',0); i = i + 1;

    tempo_simulation(i) = struct('command','return_main_loop_mac;','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','erase_all_mac;','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','background_color_mac(103,103,103);','start',9.0,'flag',0); i = i + 1;
    % tempo_simulation(i) = struct('command','fixation_position_mac(200,100);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','fixation_color_mac(175,175,175);','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sp(200,300);','start',11,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sw(100);','start',11,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''I'',103);','start',12.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''B'',90);','start',12.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','rflocate_mac(''J'',75);','start',12.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',13.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',13.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',13.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',14.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',14.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',14.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',15.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',15.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',15.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',16.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',16.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',16.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',17.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',17.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',17.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',18.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',18.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','B;','start',18.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp0;','start',19.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy0;','start',19.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','I;','start',19.1,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','bp1;','start',20.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','sy1;','start',20.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','J;','start',20.1,'flag',0); i = i + 1;

    tempo_simulation(i) = struct('command','clear_screen_mac;','start',21.0,'flag',0); i = i + 1;
end
