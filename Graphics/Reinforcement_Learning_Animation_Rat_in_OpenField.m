function Rat_in_OpenField

% _________________________________________________________________________
% 1) Set up all of the default values
%__________________________________________________________________________
% example 1
space_size    = 12;      % how big do you want the "open field" to be?
rwd_location  = [10 10]; % where do you want the trap door to be:
learning_rate = 0.3;     % how much to incriment value (1 = no memory, small values = memory across many trials)
                         % Note that this decreases with time in my
                         % implimentation below
temperature   = 0.3;     % how much randomness do you want in the decision rule (exploration vs exploitation)
                         % Note that this decreases with time in my
                         % implimentation below
sim_num       = 800;     % how many simulated trials do you want to run?
switch_num    = 400;     % do you want the trap door location to move? (if not switch_num == inf)
exploring     = false;   % do you want to encourage exploration by starting with all values positive?
use_softmax   = false;   % use either e-greedy decision rule or softmax
                         % (note that temperature = 0.05 is good for softmax)
% % example 2
% space_size    = 36;
% rwd_location  = [30 30];
% learning_rate = 0.3;
% temperature   = 0.3;
% sim_num       = 800;
% switch_num    = inf;
% exploring     = true;
% use_softmax   = false;


% _________________________________________________________________________
% 2) Initialize representations of space, value, etc.
%__________________________________________________________________________
% initialize a representation of physical space with the location of reward
reward_space = zeros(space_size); 
reward_space(rwd_location(1),rwd_location(2)) = 1;

% initialize a representation of the value associated with each position
ExpValues  = zeros(space_size);
if exploring
    ExpValues(:,:) = 0.5; % set them all positive to encourage exploration (self-avoiding random walk)
end
ExpValues(rwd_location(1),rwd_location(2)) = 1; % (I don't know if this is strictly correct but it keeps
                                                % the reward location as
                                                % the most rewarding place
                                                % in the map.  Otherwise
                                                % other places can become
                                                % valued too highly.
                                                
% initialize a representation of the reward prediction error for plotting                                                
RPE_matrix = zeros(space_size); % this will just be used for plotting.  RPEs are single, scalars.


% _________________________________________________________________________
% 3) This is where the trials start
%__________________________________________________________________________
All_mov_num       = []; %will be used to keep track and plot optimal move percentage
temperature_1st   = temperature;
learning_rate_1st = learning_rate;
for ii = 1:sim_num
    
    % I decrease the randomness of the rats behavior slightly on every iteration
    % This is not necessary, but is often implimented in
    % reinforcement learning
    learning_rate = .99 * learning_rate;
    temperature   = .99 * temperature;
    
    if ii == switch_num % This is how I switched the trap door location
                        % Note that I also reset the randomness of the rats
                        % behavior with the learning rate and temperature.
                        % This may be cheating (but then again, you could
                        % easily imagine some other mechanism that switches
                        % back to an explore strategy once exploitation is
                        % no longer working.)
        learning_rate = learning_rate_1st;
        temperature   = temperature_1st;
        rwd_location  = [3 3];
        reward_space  = zeros(space_size);
        reward_space(rwd_location(1),rwd_location(2)) = 1;
        ExpValues(rwd_location(1),rwd_location(2)) = 1;
    end 
    
    % this little while loop just ensures that the rat doesn't start on the
    % trap door.  I set his position to the trap door just the make sure
    % the while loop runs at least once
    position(1) = rwd_location(1);
    position(2) = rwd_location(2);
    while position(1) == rwd_location(1) &&...
            position(2) == rwd_location(2)
        position(1) = ceil(rand * space_size);
        position(2) = ceil(rand * space_size);
    end
    
    % based on the rats starting positon, I want to calculate the optimal
    % number of moves to the trap door.  Note that this space is
    % not really euclidean since a diagnal move is equivelant to a straight
    % move in many cases
    dist1 = abs(position(1) - rwd_location(1));
    dist2 = abs(position(2) - rwd_location(2));
    distance = max([dist1 dist2]);
    
    % As long as the rat hasn't yet found the reward, he should continue to
    % search
    look4reward = true;
    mov_num = 0;
    while look4reward
        
        % _________________________________________________________________
        % 4) The rat must look around and get its bearings
        %__________________________________________________________________        
        bound_space  = nan(space_size + 2); 
        bound_space(2:end-1,2:end-1) = ExpValues; % this quick trick sets edges of the field equal to nan.
                                            % nans are not recognized as
                                            % legal moves below.
        
        adjacent_space = bound_space(position(1):position(1) + 2, ...
            position(2):position(2) + 2);
        
        adjacent_space(2,2) = nan; % the place where the rat already is also is not a legal move
        
        
        % _________________________________________________________________
        % 5) Basd on the location, and a decision rule, the rat chooses a
        % direction 
        %__________________________________________________________________
        if use_softmax == false
            % use the e-greedy decision rule
            if rand > learning_rate % just be greedy
                [next_y next_x] = find(adjacent_space == max(max(adjacent_space)));
                if length(next_y) > 1 % in case of a value tie flip a coin
                    next_mov_i = ceil(rand * length(next_y));
                    next_y = next_y(next_mov_i); next_x = next_x(next_mov_i);
                end
            else % choose completely at random
                [next_y next_x] = find(~isnan(adjacent_space));
                next_mov_i = ceil(rand * length(next_y));
                next_y = next_y(next_mov_i); next_x = next_x(next_mov_i);
            end            
            
        else
            % use the gibbs distribution to select action (softmax)
            numerator   = exp(adjacent_space / temperature);
            denominator = nansum(nansum(exp(adjacent_space / temperature)));
            gibbs       = numerator / denominator; % this is a weighted distribution of probabilities
            
            % sometimes we get infininty, but inf/inf = nan in matlab. this
            % corrects that problem
            gibbs(isinf(numerator)) = inf;
            
            % toss a little randomness in
            gibbs = gibbs + rand(size(gibbs));
            
            % and pick the winner
            [next_y next_x] = find(gibbs == max(max(gibbs)));
            if length(next_y) > 1 % in case of a value tie flip a coin
                next_mov_i = ceil(rand * length(next_y));
                next_y = next_y(next_mov_i); next_x = next_x(next_mov_i);
            end            
        end
        
        next_y = next_y - 2; next_x = next_x - 2;
        
        old_position = [position(1) position(2)];
        
        position(1) = position(1) + next_y;
        position(2) = position(2) + next_x;
        
        % _________________________________________________________________
        % 6) Now the rat must evaluate the outcome of the decision and
        % update it's beliefe system accordingly
        %__________________________________________________________________
        reward = (reward_space(position(1),position(2)) + ExpValues(position(1),position(2)))./2; % this is actually reward + value
        old_ExpValue = ExpValues(old_position(1),old_position(2));
        
        RPE = reward - old_ExpValue;
        new_ExpValue = old_ExpValue + (learning_rate .* (reward - old_ExpValue));
        
        ExpValues(old_position(1),old_position(2)) = new_ExpValue;
        RPE_matrix(old_position(1),old_position(2)) = RPE;
        
        mov_num = mov_num + 1;
        if reward_space(position(1),position(2))
            look4reward = 0;
        end
        
        % _________________________________________________________________
        % 7) Plot the results
        %__________________________________________________________________
        subplot(2,2,1)
        dummy_color = reward_space; dummy_color(position(1),position(2)) = 0.5;
        rew_cols = num2colormap(dummy_color,'gray',[1 0]);
        image(rew_cols);
        title('Open field')
        set(gca,'xtick',[],'ytick',[],'fontsize',20)
        
        subplot(2,2,2)
        val_cols = num2colormap(log(ExpValues),'jet',[-4 0]);
        val_cols(rwd_location(1),rwd_location(2),:) = 0;
        image(val_cols)
        title('Value representation')
        set(gca,'xtick',[],'ytick',[],'fontsize',20)
        
        subplot(2,2,3)
        RPE_colors = num2colormap(RPE_matrix,'jet',[-.4 .4]);
        RPE_colors(rwd_location(1),rwd_location(2),:) = 0;
        image(RPE_colors);
        title('Reward prediction error')
        set(gca,'xtick',[],'ytick',[],'fontsize',20)
        axis off
        drawnow
        
%         pause(0.03)       
        
        % this allows the RPE plot to fade out gradually over time
        RPE_matrix = RPE_matrix .* .9;
        RPE_matrix(abs(RPE_matrix) < 0.01) = 0;
        
    end
    
    subplot(2,2,4)
    hold off
    All_mov_num(ii) = (distance / mov_num) * 100;
    plot(All_mov_num,'k','linewidth',2)
    hold on
    set(gca,'fontsize',20)
    title('Percent optimal move #')
    ylim([0 110])
    hold on
    plot(xlim,[100 100],'b','linewidth',2)
    
end



function RGB_values = num2colormap(data,map,limits)
%RGB_values = num2colormap(data,map,limits)
%
%Given a vector or array "data", num2colormap returns RGB_values on a 256
%color scale similar to those that would be used to construct the figure
%output of "image(data)" given a specific colormap.
%
%Type HELP GRAPH3D to see a number of useful colormaps.
%
%Written by david.c.godlove@vanderbilt.edu and john.haitas@vanderbilt.edu
%
%
% INPUT:
%     data       = vector or array of numbers
% 
% OPTIONAL INPUT:
%     map        = string denoting a built in colormap (default = 'jet')
%     limits     = vector containing min and max values for scale.  (for 
%                   example [-100 100]. default behavior is to auto scale.)
%
% OUTPUT:
%     RGB_values = uint8 data suitable for creating an image
%
% See also colormap, graph3d, rgb2hsv, image, and imwrite

if nargin < 2, map = 'jet'; end

%get rgb_data from selected map
eval(sprintf('map = %s(256);',map))
map = uint8(round(map * 255));

%scale data to 0-255 and change to uint8
if nargin < 3
    data = data - min(min(data));
    data = data ./ max(max(data));
else
    data = data - limits(1);
    limits(2) = limits(2) - limits(1);
    data = data ./ limits(2);
end
data = data * 255;
data = uint8(round(data));

%get red green and blue info from lookup tables
red   = intlut(data,map(:,1));
green = intlut(data,map(:,2));
blue  = intlut(data,map(:,3));

%combine into RGB data
RGB_values(:,:,1) = red;
RGB_values(:,:,2) = green;
RGB_values(:,:,3) = blue;



