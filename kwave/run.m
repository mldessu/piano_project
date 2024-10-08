function run(Nx, Ny, dx, dy, med, shape, ...
    sensorid, sourceid)
%RUN Summary of this function goes here
%   Detailed explanation goes here

% Definition des propriété de base du matériau de propagation
medium.sound_speed = med.SoundSpeed * ones(Nx, Ny); % Change SoundSpeed to sound_speed
medium.density = med.Density * ones(Nx, Ny); % Change Density to density

% Definition des propriétés de simulation 
% (Ne pas toucher)
medium.alpha_coeff = 0.75;              % [dB/(MHz^y cm)]
medium.alpha_power = 1.5;

airSpeed = 330;     % [m/s]
airDensity = 10;    % [kg/m^3]

kgrid = kWaveGrid(Nx, dx, Ny, dy);

%% Air autour du matériau
for i = 1:Nx
    for j = 1:Ny
        if i < 4 || i > (Nx-4) || j < 4 || j > (Ny-4)
            medium.sound_speed(i,j) = airSpeed;
            medium.density(i,j) = airDensity;
        end
    end
end

%% Définition de la géométrie selon le label shape
if shape == 1
    for i = 1:Nx
        for j = 1:Ny
            if i > 10 && i < 15 && j >= (Ny/5) && j <= (Ny/4.5)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 18 && i < 20 && j >= (Ny - (Ny/2)) && j <= (Ny - (Ny/2.2))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 0 && i < 20 && j >= (Ny - (Ny/3)) && j <= (Ny - (Ny/100))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif  j >= (15+i/1.2)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
      elseif  j <= (1+i/8)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
            end
        end
    end
elseif shape == 2
    for i = 1:Nx
        for j = 1:Ny
            if i > 12 && i < 15 && j >= (Ny/3) && j <= (Ny/2.5)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 10 && i < 14 && j >= (Ny - (Ny/3.2)) && j <= (Ny - (Ny/3.4))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
        elseif  j <= (15-i/1.5)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif  j >= (17+i/1.5)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
            end
        end
    end
elseif shape == 3
    for i = 1:Nx
        for j = 1:Ny
            if i > 10 && i < 14 && j >= (Ny/5) && j <= (Ny/3)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 10 && i < 15 && j >= (Ny - (Ny/2)) && j <= (Ny - (Ny/3))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 6 && i < 8 && j >= (Ny - (Ny/2)) && j <= (Ny - (Ny/2.5))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif  j >= (20+i/1.5)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
          
            end
        end
    end
% shape == 4 ou autre résulte en un carré plein, test de symétrie
elseif shape == 5
    for i = 1:Nx
        for j = 1:Ny 
         if (i - (Nx - 14.5))^2 + (j - (Ny - 14.5))^2 > 14.5^2 
                medium.sound_speed(i,j) = airSpeed; 
                medium.density(i,j) = airDensity;    
            end
        end
    end
elseif shape == 6
    for i = 1:Nx
        for j = 1:Ny
            if i > 0 && i < 18 && j >= 0 && j <= (Ny/2)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 0 && i < 18 && j >= (Ny - (Ny/2)) && j <= (Ny - (Ny/100))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 20 && i < 22 && j >= (Ny - (Ny/2)) && j <= (Ny - (Ny/2.2))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 20 && i < 22 && j >= (Ny - (Ny/4)) && j <= (Ny - (Ny/4.5))
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
       elseif i > 20 && i < 22 && j >= (Ny/5) && j <= (Ny/4.5)
                medium.sound_speed(i,j) = airSpeed;
                medium.density(i,j) = airDensity;
     
            end
        end
    end
end

%% Placement du sensor

sensor_loc = med.sensorlocs(sensorid, :);

sensorXGrid = [sensor_loc(1)];     % [gridPoint]
sensorYGrid = [sensor_loc(2)];     % [gridPoint]

sensor.mask = [kgrid.x_vec(sensorXGrid)'; kgrid.y_vec(sensorYGrid)'];

%% Placement de la source

source_loc = med.sourcelocs(sourceid, :);

sourceGrid = [source_loc(1), source_loc(2)];

source_x_pos = kgrid.x_vec(sourceGrid(1));         % [grid points]
source_y_pos = kgrid.y_vec(sourceGrid(2));         % [grid points]

%% Visualisation de la grille de simulation
% On peut s'assurer que tous nos paramètres sont correctement définis à
% l'aide d'un graphique.

% figure;
% imagesc(kgrid.y_vec * 1e3, kgrid.x_vec * 1e3, medium.sound_speed); axis image
% ylabel('y - position [mm]')
% xlabel('x - position [mm]')
% c = colorbar;
% c.Label.String = 'Speed of sound';
% hold on;
% plot(sensor.mask(2, :) * 1e3, sensor.mask(1, :) * 1e3, 'r.')
% plot(source_y_pos * 1e3, source_x_pos * 1e3, 'b+')
% legend('Sensor', 'Source')

%% Training
material_name = inputname(5);
filename = sprintf('train_%dx%d_%s_shape%d_sensor%d_source%d.mat', Nx, Ny, ...
    material_name, shape, sensorid, sourceid);
disp(filename)
training_data = cell(Nx, Ny);

if isfile(filename)
    disp('loading data')
    load(filename, 'training_data');
else
    for j = 1:Nx
        for i = med.trainrows
            sourceGrid = [i, j];
            if medium.sound_speed(sourceGrid(1), sourceGrid(2)) == airSpeed
                training_data{i, j} = NaN;
            else
                source_radius = floor(0.01/dx);         % [grid points] (Taille d'un doigt)
                source_magnitude = 10;                  % [Pa]
                source_1 = source_magnitude * makeDisc(Nx, Ny, sourceGrid(1), sourceGrid(2), source_radius);
    
                source.p0 = source_1;
                sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor,...
                    'PMLSize', 2, 'PMLInside', false, 'DataCast', 'single');
    
                training_data{i, j} = sensor_data / max(sensor_data);
            end
        end
    end
    save(filename, 'training_data');
end
%% Correlation
source_response = training_data{source_loc(1), source_loc(2)};
correlation_map = zeros(Nx, Ny);

for j = 1:Nx
    for i = med.trainrows
        sourceGrid = [i, j];
        if medium.sound_speed(sourceGrid(1), sourceGrid(2)) == airSpeed  
            continue
        else
            corr = xcorr(training_data{i,j}, source_response);
            correlation_map(i,j) = max(corr);
        end
    end
end

corr_in_medium=correlation_map(4:Nx-4, 4:Ny-4);
max_value = max(correlation_map(:));
correlation_map_norm = corr_in_medium / max_value;

%% Correlation map

% Create a figure with a specified size
fig1 = figure('Position', [100, 100, 1000, 500]);  % [left, bottom, width, height]

% First subplot for the sound speed visualization
subplot(1, 2, 1);  % 1 row, 2 columns, first subplot
imagesc(kgrid.y_vec * 1e3, kgrid.x_vec * 1e3, medium.sound_speed); 
axis image;
ylabel('y - position [mm]');
xlabel('x - position [mm]');
c = colorbar;
c.Label.String = 'Vitesse du son';
hold on;
plot(sensor.mask(2, :) * 1e3, sensor.mask(1, :) * 1e3, 'r.');
plot(source_y_pos * 1e3, source_x_pos * 1e3, 'b+');
legend('Sensor', 'Source');
title('Visualisation de la simulation');

% Second subplot for the correlation map
subplot(1, 2, 2);  % 1 row, 2 columns, second subplot
imagesc(correlation_map_norm);   % Create heatmap of normalized correlation values
colormap('gray');                % Use grayscale colormap
colorbar;                        % Add colorbar to visualize the intensity
xlabel('Points en X');
ylabel('Points en Y');
title("Carte de la corrélation");
axis image;

% Add a super title for the entire figure
sgtitle('Paramètres et résultats de la simulation');

fig1name  = sprintf('maps_%dx%d_%s_shape%d_sensor%d_source%d.png', Nx, Ny, ...
    material_name, shape, sensorid, sourceid);

saveas(fig1, fig1name)
%% Correlation plot
% Extract the row of interest from the correlation map
source_x_row = source_loc(1);  % The x-coordinate where the source is located

correlation_row = correlation_map_norm(source_x_row-3, :);  % Extract the row along the x-axis


% Plot the extracted correlation row
fig2 = figure;
plot(correlation_row, '-o');  % Plot the row data with markers
xlabel('Points en X');            % Label x-axis in mm
ylabel('Coefficient de corrélation normalisé');      % Label y-axis
title('Corrélation de la rangée avec le plus grand coefficient');
grid on;  % Add grid to the plot
axis tight; % Adjust axes to fit the data

fig2name  = sprintf('plot_%dx%d_%s_shape%d_sensor%d_source%d.png', Nx, Ny, ...
    material_name, shape, sensorid, sourceid);

saveas(fig2, fig2name)
%% Return
%% Clear all local variables

end
