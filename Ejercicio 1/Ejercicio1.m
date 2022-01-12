%% Start

%%% Ejercicio 1
%%%% Portar a Matlab el Ejercicio 3 de la Hoja de Problemas de python+opencv: análisis del rendimiento de un algoritmo de reconstrucción 3D.

%% Leer dato
g_data = readtable('./datasets/groundtruth.csv');
d_data = readtable('./datasets/detection.csv');
s1 = size(g_data);

%% Máscara de unos donde hay NaN y eliminar esas filas
idx = ismissing(d_data(:,{'Area2D','Area3D','Complexity'}));
toDelete = idx(:,1)>0;
d_data(toDelete,:) = [];
g_data(toDelete,:) = [];

%% Matriz con el nuevo tamaño de los datos
s2 = size(g_data);
r = zeros(s2);

%% Como tabla no es convertible a double, pasamos a array
g_data = table2array(g_data);
d_data = table2array(d_data);

%% En la matriz nueva, colocamos el valor absoluto de la resta entre detecciones y ground truth
r(:, 1) = g_data(:, 1); % el Id (primera columna) no es una medición
r(:, 2) = abs(d_data(:, 2) - g_data(:, 2));
r(:, 3) = abs(d_data(:, 3) - g_data(:, 3));
r(:, 4) = abs(d_data(:, 4) - g_data(:, 4));

%% Contemplamos los rangos que se van a representar
v1 = idx; % si sum nº de errores: solo columnas 'Area2D','Area3D','Complexity'
v2 = (r >= 0) & (r < 50);
v3 = (r >= 50) & (r < 100);
v4 = (r >= 100) & (r < 150);
v5 = (r >= 150) & (r < 200);
v6 = (r >= 200) & (r < 250);
v7 = (r>=250);

w1 = idx; % si sum nº de errores: solo columnas 'Area2D','Area3D','Complexity'
w2 = (r == 0);
w3 = (r == 1);
w4 = (r == 2);
w5 = (r == 3);
w6 = (r >= 4);

%% Plot con bar
x = 1:1:7;
name = {'errors'; '[0-50]'; '[50-100]'; '[100-150]'; '[150-200]'; '[200-250]'; '>250'};
p = 100/s1(1);
rep = [sum(v1(:,1))*p sum(v2(:,2))*p sum(v3(:,2))*p sum(v4(:,2))*p sum(v5(:,2))*p sum(v6(:,2))*p sum(v7(:,2))*p];
b = bar(x,rep,'r');
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 0]; % primera barra de color negro
f = gcf;
title('Error 2D')
xlabel('Range Errors')
ylabel('Number of errors')
ylim([0 100])
set(gca,'xticklabel',name)
exportgraphics(f,'error2D.png','Resolution',300)
grid on

%%
name = {'errors'; '[0-50]'; '[50-100]'; '[100-150]'; '[150-200]'; '[200-250]'; '>250'};
rep1 = [sum(v1(:,2))*p sum(v2(:,3))*p sum(v3(:,3))*p sum(v4(:,3))*p sum(v5(:,3))*p sum(v6(:,3))*p sum(v7(:,3))*p];
b1 = bar(x,rep1,'r');
b1.FaceColor = 'flat';
b1.CData(1,:) = [0 0 0];
f1 = gcf;
title('Error 3D')
xlabel('Range Errors')
ylabel('Number of errors')
ylim([0 100])
set(gca,'xticklabel',name)
exportgraphics(f1,'error3D.png','Resolution',300)
grid on

%%
x = 1:1:6;
name = {'errors'; '0'; '1'; '2'; '3'; '>=4'};
rep2 = [sum(w1(:,3))*p sum(w2(:,4))*p sum(w3(:,4))*p sum(w4(:,4))*p sum(w5(:,4))*p sum(w6(:,4))*p];
b2 = bar(x,rep2,'r');
b2.FaceColor = 'flat';
b2.CData(1,:) = [0 0 0];
f2 = gcf;
title('Error Complexity')
xlabel('Range Errors')
ylabel('Number of errors')
ylim([0 100])
set(gca,'xticklabel',name)
exportgraphics(f2,'errorcomplexity.png','Resolution',300)
grid on