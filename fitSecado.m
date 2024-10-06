load('datos.mat')
% Ecuaciones de los modelos a probar
fits = ["SD_eq-(SD_eq-%f)*exp(-k*x)"
    "SD_eq-(SD_eq-%f)*exp(-k*x^m)"
    "SD_eq-(SD_eq-%f)*exp((-k_1*x-k_2*sqrt(x)))"
    "SD_eq-(SD_eq-%f)*sqrt(1/(k*x+1))"
    "%f-x./(k_1+k_2*x)"
    "%f-k_1*x-k_2*sqrt(x)"];

% Ecuaciones de los modelos para introducirlas en LaTex
modelos = ["$SD(t) = SD_{eq} - (SD_{eq}-S_0)\cdot e^{-k\cdot t}$"
    "$SD(t) = SD_{eq} - (SD_{eq}-S_0)\cdot e^{-k\cdot t^m}$"
    "$SD(t) = SD_{eq} - (SD_{eq}-S_0)\cdot e^{-k_1\cdot t - k_2\cdot\sqrt{t}}$"
    "$SD(t) = SD_{eq} - (SD_{eq}-S_0)\cdot\sqrt{\frac{1}{k\cdot x + 1}}$"
    "$SD(t) = SD_0 - \frac{t}{k_1 +k_2\cdot t}$"
    "$SD(t) = SD_0 - k_1\cdot{}t - k_2\cdot{}\sqrt{t}$"];
% Nombre de los modelos para introducirlos en LaTex
nombres = ["LDF\cite{modelado1} (Mampel~\cite{modelado2})"
    "LDF modificado~\cite{modelado1}"
    "Mixto de segundo orden~\cite{modelado2}"
    "Jander~\cite{modelado2}"
    "Peleg~\cite{modelado2}"
    "Peppas mixto"];
nombres_plot = ["LDF (Mampel)"
    "LDF modificado"
    "Mixto de segundo orden"
    "Jander"
    "Peleg"
    "Peppas mixto"];
n = length(fits);
% Parámetros para ajustar de las ecuaciones
sp = cell(1, n);
sp{1} = ["k" "SD_eq"];
sp{2} = ["m" "k" "SD_eq"];
sp{3} = ["k_1" "k_2" "SD_eq"];
sp{4} = ["k" "SD_eq"];
sp{5} = ["k_1" "k_2"];
sp{6} = ["k_1" "k_2"];
% Valor inicial de cada parámetro
spp = cell(1, n);
spp{1} = [0 0.1];
spp{2} = [1 0 0.1]; 
spp{3} = [0 0 0.05];
spp{4} = [0 0.1];
spp{5} = [10000 10];
spp{6} = [0.00001 0.002];
% Límite inferior de cada parámetro
ul = cell(1, n);
ul{1} = [0 0];
ul{2} = [0 0 0];
ul{3} = [0 0 0];
ul{4} = [0 0 ];
ul{5} = [0 0 ];
ul{5} = [0 0 ];
ul{6} = [0 0 ];
% Límite superior de cada parámetro
up = cell(1, n);
up{1} = [1 1];
up{2} = [5 1 1];
up{3} = [1 1 1];
up{4} = [Inf 1];
up{5} = [100000 100];
up{5} = [10000000 100];
up{6} = [0.1 0.1];

sec_n = length(secado);
my_gofs_sec = zeros(sec_n, n);
my_p_sec = cell(sec_n, n);
r_cuadrados = zeros(sec_n, n);
s = zeros(sec_n, n);
my_coffs_sec = zeros(sec_n, 4);

for i = 1:n
    % for j = 6:sec_n-1
    for j = 6:sec_n-1 % solo se realiza el ajuste de las últimas curvas
        % Preparación de los datos
        p0 = secado(j).peso_inicial;
        pp = secado(j).peso_polimero;
        s0 = (secado(j).T.Variaci_n_mg_(1)+p0-pp)/pp;
        fit_ = sprintf(fits(i),s0);

        nan_idx = find(isnan(secado(j).sd));
        secado(j).sd(nan_idx) = [];
        secado(j).t(nan_idx) = [];
        if (size(secado(j).t, 2) > size(secado(j).t, 1))
            secado(j).t = secado(j).t';
        end
        if (size(secado(j).sd, 2) > size(secado(j).sd, 1))
            secado(j).sd = secado(j).sd';
        end
        
        % Ajuste
        myfittype = fittype(fit_, dependent = "y", independent = "x", coefficients = sp{i});
        [p, gof2] = fit(secado(j).t(1:end), secado(j).sd(1:end), myfittype, 'StartPoint', spp{i}, 'Lower', ul{i}, 'Upper', up{i});
        gof = goodnessOfFit(p(secado(j).t(1:end)), secado(j).sd(1:end), 'NRMSE');
        my_gofs_sec(j, i) = 1 - gof;
        r_cuadrados(j,i) = gof2.adjrsquare;
        s(j,i) = gof2.sse/sqrt(length(secado(j).t));
        my_p_sec{j,i} = p;
    end
end
%% Cálculo de la bondad de los ajustes medios
gof_mean = mean(my_gofs_sec(6:17,:))
gof_min = min(my_gofs_sec(6:17,:));
rcuadrado_medio = mean(r_cuadrados(6:17,:))
s_medios = mean(s(6:17,:))
s_max = max(s(6:17,:));
fprintf("Modelo\tEcuación\t$NMRSE_{mean}$\t$S_{mean}$\t$S_{max}$\t$R^2_adj$\n");
for i = 1:length(fits)
    % fprintf("%s\t%.3f\t%.3f\n",modelos(i),gof_mean(i),gof_min(i))
    fprintf("%s\t%s\t%.3f\t%.2e\t%.2e\t%.3f\n",nombres(i),modelos(i),gof_mean(i),s_medios(i),s_max(i),rcuadrado_medio(i));
    fprintf("\n")
end

%% Gráficar resultados
figure();
a = 6:sec_n-1;
c = colororder();
colororder([1 1 1;c(1:end,:)])
for i = a
    hold on;
    h(1) = plot(secado(i).t(1:end)/60, secado(i).sd(1:end),'Color',[0 0 0 1],'LineWidth', 1.5,'DisplayName',"Experimental");
    h(2) = plot(secado(i).t(1:end)/60, my_p_sec{i, 1}(secado(i).t(1:end)), '--', 'LineWidth', 1.5,'DisplayName',nombres_plot(6));
    h(2) = plot(secado(i).t(1:end)/60, my_p_sec{i, 1}(secado(i).t(1:end)), '--', 'LineWidth', 1.5,'DisplayName',nombres_plot(1));
    h(3) = plot(secado(i).t(1:end)/60, my_p_sec{i, 2}(secado(i).t(1:end)), '--', 'LineWidth', 1.5,'DisplayName',nombres_plot(2));
    h(4) = plot(secado(i).t(1:end)/60, my_p_sec{i, 3}(secado(i).t(1:end)), '--', 'LineWidth', 1.5,'DisplayName',nombres_plot(3));
    h(5) = plot(secado(i).t(1:end)/60, my_p_sec{i, 4}(secado(i).t(1:end)), '--', 'LineWidth', 1.5,'DisplayName',nombres_plot(4));
    h(6)= plot(secado(i).t(1:end)/60, my_p_sec{i, 5}(secado(i).t(1:end)), '--', 'LineWidth', 1.5,'DisplayName',nombres_plot(5));
end
pbaspect([1.4 1 1]);
grid on;
xlabel("Tiempo [min]"); ylabel("SD")
xlim('tight')
legend();yticks(0.14:0.02:0.24);xticks(0:30:240)
uistack(h(1),"top");legend(h)
fontsize(scale=1.3)