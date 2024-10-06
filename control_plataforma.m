classdef control_plataforma < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TipodecontrolSwitch            matlab.ui.control.ToggleSwitch
        TipodecontrolSwitchLabel       matlab.ui.control.Label
        envioEditField                 matlab.ui.control.EditField
        envioEditFieldLabel            matlab.ui.control.Label
        indiceEditField                matlab.ui.control.NumericEditField
        indiceEditFieldLabel           matlab.ui.control.Label
        ErrorLamp                      matlab.ui.control.Lamp
        NoejecutandoLabel              matlab.ui.control.Label
        prueba1EditField               matlab.ui.control.NumericEditField
        prueba1EditFieldLabel          matlab.ui.control.Label
        pruebaEditField                matlab.ui.control.NumericEditField
        pruebaEditFieldLabel           matlab.ui.control.Label
        SDbuscadoEditField             matlab.ui.control.NumericEditField
        SDbuscadoEditFieldLabel        matlab.ui.control.Label
        ButtonGroup                    matlab.ui.container.ButtonGroup
        MonitorearButton               matlab.ui.control.RadioButton
        ControlButton                  matlab.ui.control.RadioButton
        TomardatosButton               matlab.ui.control.RadioButton
        encendido_lamp                 matlab.ui.control.Lamp
        funcionaLamp                   matlab.ui.control.Lamp
        MensajesTextArea               matlab.ui.control.TextArea
        MensajesTextAreaLabel          matlab.ui.control.Label
        PararButton                    matlab.ui.control.Button
        DatosPanel                     matlab.ui.container.Panel
        TiemposEditField               matlab.ui.control.NumericEditField
        TiemposEditFieldLabel          matlab.ui.control.Label
        Resistencia_par2               matlab.ui.control.NumericEditField
        Rsubpar2subLabel               matlab.ui.control.Label
        Resistencia_par1               matlab.ui.control.NumericEditField
        Rsubpar1subLabel               matlab.ui.control.Label
        TemperaturaCEditField          matlab.ui.control.NumericEditField
        TemperaturaCLabel              matlab.ui.control.Label
        Vsubpar2subVEditField          matlab.ui.control.NumericEditField
        Vsubpar2subLabel               matlab.ui.control.Label
        SDEditField                    matlab.ui.control.NumericEditField
        SDEditFieldLabel               matlab.ui.control.Label
        Vsubpar1subVEditField          matlab.ui.control.NumericEditField
        Vsubpar1subLabel               matlab.ui.control.Label
        VariacingEditField             matlab.ui.control.NumericEditField
        VariacingEditFieldLabel        matlab.ui.control.Label
        ComenzarButton                 matlab.ui.control.Button
        ConfiguracininicialPanel       matlab.ui.container.Panel
        TemperaturaambienteCEditField  matlab.ui.control.NumericEditField
        TemperaturaambienteCEditFieldLabel  matlab.ui.control.Label
        Monitorear_tras_secadoButton   matlab.ui.control.StateButton
        ArchivoEditField               matlab.ui.control.EditField
        ArchivoEditFieldLabel          matlab.ui.control.Label
        GuardardatosButton             matlab.ui.control.StateButton
        SDinicialEditField             matlab.ui.control.NumericEditField
        SDinicialEditFieldLabel        matlab.ui.control.Label
        DuracinSpinner                 matlab.ui.control.Spinner
        DuracinSpinnerLabel            matlab.ui.control.Label
        AnotacionesEditField           matlab.ui.control.EditField
        AnotacionesEditFieldLabel      matlab.ui.control.Label
        R2kEditField                   matlab.ui.control.NumericEditField
        R2Label                        matlab.ui.control.Label
        DedoDropDown                   matlab.ui.control.DropDown
        DedoDropDownLabel              matlab.ui.control.Label
        ExperimentoDropDown            matlab.ui.control.DropDown
        ExperimentoDropDownLabel       matlab.ui.control.Label
        R1kEditField                   matlab.ui.control.NumericEditField
        R1Label                        matlab.ui.control.Label
        PesoinicialgEditField          matlab.ui.control.NumericEditField
        PesoinicialgEditFieldLabel     matlab.ui.control.Label
        ConexinPanel                   matlab.ui.container.Panel
        ind_basculaLamp                matlab.ui.control.Lamp
        ind_arduinoLamp                matlab.ui.control.Lamp
        ConectarButton                 matlab.ui.control.Button
        PuertoarduinoDropDown          matlab.ui.control.DropDown
        PuertoarduinoDropDownLabel     matlab.ui.control.Label
        PuertobasculaDropDown          matlab.ui.control.DropDown
        PuertobasculaDropDownLabel     matlab.ui.control.Label
        estado_conTextArea             matlab.ui.control.TextArea
        UIAxes_2                       matlab.ui.control.UIAxes
        UIAxes                         matlab.ui.control.UIAxes
    end


    properties (Access = private)
        serie_arduino; % Description
        serie_bascula;
        peso_inicial;
        peso_polimero;% Description
        final;
        % a_sec;
        % b_sec;
        % c_sec;
        %
        % a_hum;
        % b_hum;
        % c_hum;
    end

    methods (Access = private)


        function tomardatos(app)
            warning("off");
            % Función que se encarga de realizar los experimentos de secado
            % y de humidificación.
            %% Variables necesarias
            app.prueba1EditField.Value = app.peso_polimero;
            app.pruebaEditField.Value = app.peso_inicial;
            dia = datetime("today",'Format','MM-dd-yyyy');
            hora_inicio = datetime('now','Format','HH:mm:ss');
            dedo = app.DedoDropDown.Value;
            experimento = app.ExperimentoDropDown.Value;
            comentario = app.AnotacionesEditField.Value;
            r1 = app.R1kEditField.Value;
            r2 = app.R2kEditField.Value;
            error = 0;
            %% Creacion de archivo donde se van a guardar los datos
            carpeta = "Datos_Arduino\"+ string(dia);
            mkdir(carpeta);

            filename = string(dia)+"_"+dedo+"_"+experimento;
            filename = carpeta + "\" + filename;
            while isfile(filename+".csv")
                warning("Nombre de archivo existente");
                filename = filename+"_nuevo";
            end
            filename = filename + ".csv";
            if app.GuardardatosButton.Value == false
                filename = carpeta + "\" + "temporal_" + string(datetime("now",'Format','d-MMM-y_HH-mm-ss')) + ".xlsx";
            end

            variables = ["Peso inicial";"Peso polimero";"SD incial";"Fecha";"Hora";"Dedo";"Sec/Hum";"Comentario";"R1";"R2"];
            valores = [string(app.peso_inicial*1000);string(app.peso_polimero*1000);string(app.SDinicialEditField.Value);string(dia);string(hora_inicio);dedo;experimento;comentario;r1;r2];

            var_val = ["Peso inicial";string(app.peso_inicial*1000);"Peso polimero";string(app.peso_polimero*1000);"SD incial";string(app.SDinicialEditField.Value);"Fecha";string(dia);"Hora";string(hora_inicio);"Dedo";dedo;"Sec/Hum";experimento;"Comentario";comentario;"R1";string(r1);"R2";string(r2)]';
            % T = table(variables, valores);
            T2 = ["Tiempo [s]","Voltaje 1 [V]","Voltaje 2 [V]","Temperatura dedo [C]","Tiempo bascula [s]","Variación [mg]"];
            app.ArchivoEditField.Value = filename;
            writematrix(var_val,filename);
            writematrix(T2,filename,"WriteMode","append");

            %% Inicialización de la ejecución del programa
            sec_hum = 0;
            if experimento == "Humedecido"
                sec_hum = 2;
            elseif experimento == "Toma de datos"
                sec_hum = 6;
            end
            n_array = 1000;
            t = zeros(n_array,1);
            tbasc = zeros(n_array,1);
            v1 = zeros(n_array,1);
            v2 = zeros(n_array,1);
            temp_dedo = zeros(n_array,1);
            variacion = zeros(n_array,1);
            temp_amb = zeros(n_array,1);
            hum_amb = zeros(n_array,1);
            % t_arduino = zeros(n_array,1);
            % encendido = zeros(n_array,1);
            % v3 = zeros(n_array,1);
            % v4 = zeros(n_array,1);
            i3 = 1;i4=1;
            i = 1;i2 = 1;
            n_horas = app.DuracinSpinner.Value;
            tiempos = 0:15:60*60*n_horas;
            vari = 0;
            app.PararButton.Enable = "on";

            %% Preparar gráficas
            yyaxis(app.UIAxes,'left');
            volt1_line = animatedline(app.UIAxes,"Color",[0 0.4470 0.7410]);
            volt2_line = animatedline(app.UIAxes,'Color',[0 0.4470 0.7410],'LineStyle','--');
            ylim(app.UIAxes,[0 5.5]);
            
            yyaxis(app.UIAxes,"right");
            temp_line = animatedline(app.UIAxes,'Color',[0.8500 0.3250 0.0980]);

            sd_line = animatedline(app.UIAxes_2,"Color",[0 0.4470 0.7410]);
            % addpoints(sd_line,0,sd_line)
            
            delay_figure = 0.1;
            timer_figure = delay_figure;

            %% Sincronizació
            % app.MensajesTextArea.Value = "Comenzando en: 3";
            app.addmsg('Comenzando en: 3');
            app.funcionaLamp.Color = [1 0 0];
            pause(1);
            % app.MensajesTextArea.Value = "Comenzando en: 2";
            app.addmsg('Comenzando en: 2');
            app.funcionaLamp.Color = [1.00,0.41,0.16];
            pause(1);
            % app.MensajesTextArea.Value = "Comenzando en: 1";
            app.addmsg('Comenzando en: 1');
            app.funcionaLamp.Color = [1.00,0.98,0];
            pause(1);
            % app.MensajesTextArea.Value = "";
            app.funcionaLamp.Color = [0.00,1,0];
            app.NoejecutandoLabel.Text = append("Tomando datos: ",experimento);
            app.addmsg('Tomando datos');
            beep;

            %% Ejecucion del programa
            write(app.serie_arduino,1,'int16');% Se da la señal de comienzo al arduino
            app.final = 0;
            ind = 2; % El primer cambio es en el 15 no en el 0
            tic;
            app.funcionaLamp.Color = [0 1 0];
            encendido = 0;
            write(app.serie_arduino,2+sec_hum,'int16');% primera instrucción de encendido
            last_figure_update = toc;
            try
                while app.final == 0 && ind<=length(tiempos)
                    % Se sale del bucle al pulsar el boton de parar o al
                    % acabar el tiempo de experimento
                    flush(app.serie_arduino);
                    flush(app.serie_bascula);
                    cadena_aux = readline(app.serie_bascula);

                    ti = toc;
                    % Control del encendido y apagado del sistema
                    if ti >= tiempos(ind)
                        if encendido == 1
                            write(app.serie_arduino,2+sec_hum,'int16');
                            app.encendido_lamp.Color = [0 1 0];
                            % fprintf("%d\n",2+sec_hum);
                            encendido = 0;
                        else
                            write(app.serie_arduino,3+sec_hum,'int16');
                            app.encendido_lamp.Color = [0.65 0.65 0.65];
                            encendido = 1;
                        end
                        ind = ind+1;
                    end
                    
                    % Toma de datos
                    [v1(i3),v2(i3),temp_dedo(i3),variacion(i3),hum_amb(i3),temp_amb(i3)] = app.obtener_valores();
                    t(i3) = toc;
                    tbasc(i3) = t(i3);

                    if(i3==n_array)% Guardado de datos por lotes
                        writematrix([t v1 v2 temp_dedo tbasc variacion hum_amb temp_amb],filename,"WriteMode","append");
                        i3 = 0;
                    end
                    i3 = i3+1;

                    % Actualizar graficas
                    ti = toc;
                    if ti > last_figure_update+timer_figure
                        timer_figure = delay_figure - (ti-last_figure_update-timer_figure);
                        last_figure_update = ti;

                        addpoints(volt1_line,ti,app.Vsubpar1subVEditField.Value);
                        addpoints(volt2_line,ti,app.Vsubpar2subVEditField.Value);
                        addpoints(temp_line,ti,app.TemperaturaCEditField.Value);

                        % Añadir SD solo cuando el sistema este apagado
                        if encendido == 1 && ti>tiempos(ind-1)+10
                            % a = (valor+app.peso_inicial-app.peso_polimero)/app.peso_polimero
                            addpoints(sd_line,ti,(vari+app.peso_inicial-app.peso_polimero)/app.peso_polimero);
                        end

                    end
                    % Fin del bucle

                end
            catch
                % app.MensajesTextArea.Value = "Ha habido un error";
                app.addmsg('Ha habido un error');
                app.funcionaLamp.Color = [0.65 0.65 0.65];
                app.ErrorLamp.Color = [0.65 0.65 0.65];
                error = 1;
            end

            %% Finalización del programa
            if app.Monitorear_tras_secadoButton.Value == 1 && error == 0
                % Si se finaliza la ejecuciión del bucle sin errores,
                % se guardan los datos y se inicia un proceso de
                % monitorización
                write(app.serie_arduino,3,'int16');
                write(app.serie_arduino,5,'int16');
                app.addmsg('Empezando monitoreo...');
                writematrix([t(1:i3-1) v1(1:i3-1) v2(1:i3-1) temp_dedo(1:i3-1) tbasc(1:i3-1) variacion(1:i3-1) hum_amb(1:i3-1) temp_amb(1:i3-1)],filename,'WriteMode','append');
                app.PararButton.Enable = "off";
                app.funcionaLamp.Color = [0 1 0];
                app.monitorear(0.1);
            else
                % Si ha habido un error, se guardan los datos y se finaliza
                % la ejecución
                write(app.serie_arduino,6,'int16');
                app.serie_arduino = 0;
                app.serie_bascula = 0;
                writematrix([t(1:i3-1) v1(1:i3-1) v2(1:i3-1) temp_dedo(1:i3-1) tbasc(1:i3-1) variacion(1:i3-1) hum_amb(1:i3-1) temp_amb(1:i3-1)],filename,'WriteMode','append');
                app.PararButton.Enable = "off";
                app.funcionaLamp.Color = [0 1 0];
                app.acabar_execution();
                
                beep;
            end
        end

        function control_bang(app)
            % Función que se encarga de realizar el control bang-bang
            %% Activar arduino y mirar sd
            app.final = 0;
            app.NoejecutandoLabel.Text = "Controlando";
            sd_objetivo = app.SDbuscadoEditField.Value;
            %% Creacion de archivo donde se van a guardar los datos
             % Variables necesarias
             dia = datetime("today",'Format','MM-dd-yyyy');
             hora_inicio = datetime('now','Format','HH:mm:ss');
             dedo = app.DedoDropDown.Value;
             % experimento = app.ExperimentoDropDown.Value;
             comentario = app.AnotacionesEditField.Value;
             r1 = app.R1kEditField.Value;
             r2 = app.R2kEditField.Value;
             
             carpeta = "Datos_Arduino\Control\"+ string(dia);
             mkdir(carpeta);

             filename = string(dia)+"_"+dedo+"_"+"Control";
             filename = carpeta + "\" + filename;
             while isfile(filename+".xlsx")
                 warning("Nombre de archivo existente");
                 filename = filename+"_nuevo";
             end
             filename = filename + ".xlsx";
             if app.GuardardatosButton.Value == false
                 filename = carpeta + "\" + "temporal_" + string(datetime("now",'Format','d-MMM-y_HH-mm-ss')) + ".xlsx";
             end

             variables = ["Peso inicial";"Peso polimero";"SD incial";"Fecha";"Hora";"Dedo";"SD_objetivo";"Comentario";"R1";"R2"];
             valores = [string(app.peso_inicial*1000);string(app.peso_polimero*1000);string(app.SDinicialEditField.Value);string(dia);string(hora_inicio);dedo;sd_objetivo;comentario;r1;r2];

             T = table(variables, valores);
             T2 = ["Tiempo [s]","Voltaje 1 [V]","Voltaje 2 [V]","Temperatura dedo [C]","Tiempo bascula [s]","Variación [mg]"];

             app.ArchivoEditField.Value = filename;
             writetable(T,filename,'Range','G1');
             writematrix(T2,filename,'Range','A1');
             %% Preparar gráficas
             yyaxis(app.UIAxes,'left');
             volt1_line = animatedline(app.UIAxes,"Color",[0 0.4470 0.7410]);
             volt2_line = animatedline(app.UIAxes,'Color',[0 0.4470 0.7410],'LineStyle','--');

             yyaxis(app.UIAxes,"right");
             temp_line = animatedline(app.UIAxes,'Color',[0.8500 0.3250 0.0980]);

             sd_line = animatedline(app.UIAxes_2,"Color",[0 0.4470 0.7410]);
             referencia_line = animatedline(app.UIAxes_2,"Color",[0.8 0.8 0.08],"LineStyle","--");

            %% Bucle principal
            % Se manda la señal de activación del Arduino
            write(app.serie_arduino,8,'int16');
            addpoints(referencia_line,0,sd_objetivo);

            t_start = tic;
            app.PararButton.Enable = "on";
            app.final = 0;
            app.funcionaLamp.Color = [0 1 0];
            encendido = 0;
            write(app.serie_arduino,1,'int16');
            pause(1)
            t_ex = tic;
            sd_previo = (app.peso_inicial-app.peso_polimero)/app.peso_polimero;
            % sd_previo = app.SDinicialEditField.
            last_t = -10000;
            medicion = 1;
            try
                while app.final == 0
                    % Primero se limpian los datos de los puertos serie
                    flush(app.serie_bascula);
                    cadena_aux = readline(app.serie_bascula);
                    flush(app.serie_arduino);

                    ti = toc(t_start);
                    % ti = toc(t_exp);
                    % Cada 29 segundos si el sistema esta apagado se leen
                    % los datos
                    if ti-last_t>=29 && medicion == 1 && encendido ==0
                        [v1,v2,temp_dedo,variacion,hum_amb,temp_amb] = app.obtener_valores();
                        writematrix([ti v1 v2 temp_dedo ti variacion],filename,'WriteMode','append');
                        % medicion = 0;

                        app.TiemposEditField.Value = ti;
                        addpoints(volt1_line,ti,app.Vsubpar1subVEditField.Value);
                        addpoints(volt2_line,ti,app.Vsubpar2subVEditField.Value);
                        addpoints(temp_line,ti,app.TemperaturaCEditField.Value);
                        addpoints(sd_line,ti,app.SDEditField.Value);
                        addpoints(referencia_line,ti,sd_objetivo);

                        sd_actual = (variacion+app.peso_inicial-app.peso_polimero)/app.peso_polimero;
                        %Si hay un cambio muy brusco se espera a la segunda
                        %medida para encender los sistemas, esto evita
                        %errores de pesaje de la bascula
                        if abs(sd_actual-sd_previo)>0.01
                            medicion = 1;
                        else
                            medicion = 0;
                        end
                        sd_previo = sd_actual;
                    end

                    if ti-last_t>=30
                        last_t = ti;
                        medicion = 1;
                        if sd_actual -sd_objetivo >= 0.001
                        % Iniciar secado
                            sec_hum = 0;
                            encendido =1;
                            write(app.serie_arduino,2,'int16');
                            app.encendido_lamp.Color = [0 1 0];
                            app.envioEditField.Value = string(2+sec_hum);
                        elseif sd_actual-sd_objetivo <= -0.001
                            %Iniciar humidificación
                            sec_hum = 2;
                            encendido = 1;
                            write(app.serie_arduino,4,'int16');
                            app.encendido_lamp.Color = [0 1 0];
                            app.envioEditField.Value = string(2+sec_hum);
                        else
                            encendido = 0;
                            write(app.serie_arduino,8,'int16');
                        end
                    end
                    
                    % Control del encendido y apagado del sistema
                    if encendido == 1 && ti - last_t>= 15  
                        write(app.serie_arduino,3+sec_hum,'int16');
                        app.envioEditField.Value = string(3+sec_hum);
                        app.encendido_lamp.Color = [0.65 0.65 0.65];
                        encendido = 0;
                    end
                    ti = toc(t_start);
                end
                write(app.serie_arduino,3,'int16');
                write(app.serie_arduino,3+2,'int16');

            catch
                % app.MensajesTextArea.Value = "Ha habido un error";
                app.addmsg(sprintf("[%f] Ha habido un error",toc(t_start)/60));
                app.funcionaLamp.Color = [0.65 0.65 0.65];
                app.acabar_execution();
                display(lasterr);
                write(app.serie_arduino,3+sec_hum,'int16');
            end

                    % i3 = 0;
        end
    

        function t_final = tiempo_funcionamiento(app,sec,sd_actual)
            % Función que devuelve el tiempo que tardaría el sistema en
            % realizar un secado o un proceso de humidificación con los
            % modelos
            load("regresiones.mat");
            syms t;
            Sd_objetivo = app.SDbuscadoEditField.Value;
            if sec == 0
                temp_0 = app.TemperaturaambienteCEditField.Value;
                k1 = 1.6*10^(-7)*temp_0-3.2*10^(-6);
                k2 = 10^(-5)*exp(17.1*sd_actual);

                t_final = (k2-sqrt(k2^2+4*k1*(sd_actual-Sd_objetivo)))^2/(4*k1^2);
                if t_final<0
                    t_final = 60;
                    warning("Hay algo raro, t_final es menor a 0");
                end

            else
                Am = Humedecido.Am;An = Humedecido.An;
                B = Humedecido.B;
                Cm = Humedecido.Cm;Cn = Humedecido.Cn;
                Dm = Humedecido.Dm;Dn = Humedecido.Dn;
                E = Humedecido.E;
                A = Am*sd_actual+An;
                C = Cm*sd_actual+Cn;
                D = Dm*sd_actual+Dn;

                if A+C >= Sd_objetivo
                    A = sd_actual-C;
                end
                
                t_final = double(vpasolve(Sd_objetivo == A*exp(B*t)+C,t));
                if isempty(t_final) || t_final >= 5000
                    t_final = double(vpasolve(Sd_objetivo == D+E*t,t));

                end
    
            end
        end

        function monitorear(app,delay_toma)
            % Función que se encarga de tomar los datos del arduino y de la
            % bascula. Muy similar a las anteriores.
            warning("off");
            if nargin == 1
                delay_toma = 5;
            % elseif nargin == 2
                
            end
            %% Variables necesarias
            app.serie_arduino.Timeout = 10;
            app.serie_bascula.Timeout = 10;
            app.prueba1EditField.Value = app.peso_polimero;
            app.pruebaEditField.Value = app.peso_inicial;
            dia = datetime("today",'Format','MM-dd-yyyy');
            hora_inicio = datetime('now','Format','HH:mm:ss');
            dedo = app.DedoDropDown.Value;
            experimento = app.ExperimentoDropDown.Value;
            comentario = app.AnotacionesEditField.Value;
            r1 = app.R1kEditField.Value;
            r2 = app.R2kEditField.Value;

            %% Creacion de archivo donde se van a guardar los datos
            carpeta = "Datos_Arduino\"+ string(dia);
            mkdir(carpeta);

            filename = string(dia)+"_"+dedo+"_Monitoreo";
            filename = carpeta + "\" + filename;
            if isfile(filename+".csv")
                warning("Nombre de archivo existente");
                filename = filename+"_nuevo";
            end
            filename = filename + ".csv";
            if app.GuardardatosButton.Value == false
                filename = carpeta + "\" + "temporal_" + string(datetime("now",'Format','d-MMM-y_HH-mm-ss')) + ".csv";
            end
            
            variables = ["Peso inicial";"Peso polimero";"SD incial";"Fecha";"Hora";"Dedo";"Sec/Hum";"Comentario";"R1";"R2"];
            valores = [string(app.peso_inicial*1000);string(app.peso_polimero*1000);string(app.SDinicialEditField.Value);string(dia);string(hora_inicio);dedo;experimento;comentario;r1;r2];
            var_val = ["Peso inicial";string(app.peso_inicial*1000);"Peso polimero";string(app.peso_polimero*1000);"SD incial";string(app.SDinicialEditField.Value);"Fecha";string(dia);"Hora";string(hora_inicio);"Dedo";dedo;"Sec/Hum";experimento;"Comentario";comentario;"R1";string(r1);"R2";string(r2)]';

            T2 = ["Tiempo [s]","Voltaje 1 [V]","Voltaje 2 [V]","Temperatura dedo [C]","Tiempo bascula [s]","Variación [mg]"];

            app.ArchivoEditField.Value = filename;
            writematrix(var_val,filename);
            writematrix(T2,filename,"WriteMode","append");

            %% Inicialización de la ejecución del programa
            % sec_hum = 0;
            
            n_array = 5;
            t = zeros(n_array,1);
            tbasc = zeros(n_array,1);
            v1 = zeros(n_array,1);
            v2 = zeros(n_array,1);
            temp_dedo = zeros(n_array,1);
            variacion = zeros(n_array,1);
            temp_amb = zeros(n_array,1);
            hum_amb = zeros(n_array,1);

            i3 = 1;i4=1;
            i = 1;i2 = 1;
            n_horas = app.DuracinSpinner.Value;
            tiempos = 0:15:60*60*n_horas;
            vari = 0;
            app.PararButton.Enable = "on";

            %% Preparar gráficas
            yyaxis(app.UIAxes,'left');
            volt1_line = animatedline(app.UIAxes,"Color",[0 0.4470 0.7410],'MaximumNumPoints',10000);
            volt2_line = animatedline(app.UIAxes,'Color',[0 0.4470 0.7410],'LineStyle','--','MaximumNumPoints',10000);
            ylim(app.UIAxes,[0 5.5]);

            yyaxis(app.UIAxes,"right");
            temp_line = animatedline(app.UIAxes,'Color',[0.8500 0.3250 0.0980],'MaximumNumPoints',10000);


            sd_line = animatedline(app.UIAxes_2,"Color",[0 0.4470 0.7410],'MaximumNumPoints',10000);

            delay_figure = delay_toma;
            timer_figure = delay_figure;
            % timer_sd = 100;
            % last_figure_update = 0;

            %% Sincronización
            app.addmsg('Comenzando en: 3');
            app.funcionaLamp.Color = [1 0 0];
            pause(1);
            app.addmsg('Comenzando en: 2');
            app.funcionaLamp.Color = [1.00,0.41,0.16];
            pause(1);
            app.addmsg('Comenzando en: 1');
            app.funcionaLamp.Color = [1.00,0.98,0];
            pause(1);
            app.funcionaLamp.Color = [0.00,1,0];
            app.NoejecutandoLabel.Text = "Monitorizando";
            app.addmsg('Monitorizando');
            beep;
            %% Ejecución del programa
            write(app.serie_arduino,1,'int16');
            app.final = 0;
            ind = 2; % El primer cambio es en el 15 no en el 0
            % t_previo = 0;
            tic;
            app.funcionaLamp.Color = [0 1 0];
            encendido = 0;
            % write(app.serie_arduino,2+sec_hum,'int16');
            last_figure_update = toc;
            tiempo_maximo = 60*60*24*10;
            ti = toc;
            try
                while app.final == 0 && ti<=tiempo_maximo
                    ti = toc;
                    app.encendido_lamp.Color = [0.65 0.65 0.65];
                    if ti > last_figure_update+timer_figure
                        flush(app.serie_arduino);
                        flush(app.serie_bascula);
                        cadena_aux = readline(app.serie_bascula);

                        ti = toc;
                        write(app.serie_arduino,8,'int16');
                        app.encendido_lamp.Color = [0 1 0];
  
                        [v1(i3),v2(i3),temp_dedo(i3),variacion(i3),hum_amb(i3),temp_amb(i3)] = app.obtener_valores();    
                        t(i3) = toc;
                        tbasc(i3) = t(i3);

                        if(i3==n_array)
                            writematrix([t v1 v2 temp_dedo tbasc variacion hum_amb temp_amb],filename,"WriteMode","append");
                            i3 = 0;
                        end
                        i3 = i3+1;
                        % Cosas graficas

                        timer_figure = delay_figure - (ti-last_figure_update-timer_figure);
                        last_figure_update = ti;

                        addpoints(volt1_line,ti,app.Vsubpar1subVEditField.Value);
                        addpoints(volt2_line,ti,app.Vsubpar2subVEditField.Value);
                        addpoints(temp_line,ti,app.TemperaturaCEditField.Value);
                        addpoints(sd_line,ti,(vari+app.peso_inicial-app.peso_polimero)/app.peso_polimero);


                    end
                    % Fin del bucle

                end
            catch
                % app.MensajesTextArea.Value = "Ha habido un error";
                app.addmsg('Ha habido un error');
                app.funcionaLamp.Color = [0.65 0.65 0.65];
            end

            %% Finalización del programa
            write(app.serie_arduino,6,'int16');
            app.serie_arduino = 0;
            app.serie_bascula = 0;
            writematrix([t(1:i3-1) v1(1:i3-1) v2(1:i3-1) temp_dedo(1:i3-1) tbasc(1:i3-1) variacion(1:i3-1) hum_amb(1:i3-1) temp_amb(1:i3-1)],filename,'WriteMode','append');
            app.PararButton.Enable = "off";
            app.funcionaLamp.Color = [0 1 0];
            app.acabar_execution();
            beep;
        end

        
        function  acabar_execution(app)
            % Función que se encarga de finalizar la ejecución, activando
            % los botones necesarios para poder realizar otro proceso
            app.ComenzarButton.Enable = "off";
            app.ConexinPanel.Enable = "on";
            app.ind_arduinoLamp.Color = [0.65 0.65 0.65];
            app.ind_basculaLamp.Color = [0.65 0.65 0.65];
            app.encendido_lamp.Color = [0.65 0.65 0.65];
            app.funcionaLamp.Color = [0.65 0.65 0.65];
            app.NoejecutandoLabel.Text = "No ejecutando";
        end
        
        function addmsg(app,msg)
            % Se usa para escribir mensajes en el cuadro de texto.
            if isstring(msg)
                msg = convertStringsToChars(msg);
            end
            app.MensajesTextArea.Value{end+1} = msg;
            app.MensajesTextArea.scroll("bottom");
        end
        
        function  control_pseuso(app)
            % Función que realiza el pseudo control, hace uso de la función
            % tiempo_funcionamiento().
             %% Activar arduino y mirar sd
            write(app.serie_arduino,1,'int16');
            app.final = 0;
            app.NoejecutandoLabel.Text = "Controlando";
            %% Creacion de archivo donde se van a guardar los datos
             % Variables necesarias
             dia = datetime("today",'Format','MM-dd-yyyy');
             hora_inicio = datetime('now','Format','HH:mm:ss');
             dedo = app.DedoDropDown.Value;
             experimento = app.ExperimentoDropDown.Value;
             comentario = app.AnotacionesEditField.Value;
             r1 = app.R1kEditField.Value;
             r2 = app.R2kEditField.Value;
             
             carpeta = "Datos_Arduino\Control\"+ string(dia);
             mkdir(carpeta);

             filename = string(dia)+"_"+dedo+"_"+"Control";
             filename = carpeta + "\" + filename;
             while isfile(filename+".xlsx")
                 warning("Nombre de archivo existente");
                 filename = filename+"_nuevo";
             end
             filename = filename + ".xlsx";
             if app.GuardardatosButton.Value == false
                 filename = carpeta + "\" + "temporal_" + string(datetime("now",'Format','d-MMM-y_HH-mm-ss')) + ".xlsx";
             end

             variables = ["Peso inicial";"Peso polimero";"SD incial";"Fecha";"Hora";"Dedo";"Sec/Hum";"Comentario";"R1";"R2"];
             valores = [string(app.peso_inicial*1000);string(app.peso_polimero*1000);string(app.SDinicialEditField.Value);string(dia);string(hora_inicio);dedo;experimento;comentario;r1;r2];

             T = table(variables, valores);
             T2 = ["Tiempo [s]","Voltaje 1 [V]","Voltaje 2 [V]","Temperatura dedo [C]","Tiempo bascula [s]","Variación [mg]"];

             app.ArchivoEditField.Value = filename;
             writetable(T,filename,'Range','G1');
             writematrix(T2,filename,'Range','A1');
             %% Cosas graficas
             yyaxis(app.UIAxes,'left');
             volt1_line = animatedline(app.UIAxes,"Color",[0 0.4470 0.7410]);
             volt2_line = animatedline(app.UIAxes,'Color',[0 0.4470 0.7410],'LineStyle','--');

             yyaxis(app.UIAxes,"right");
             temp_line = animatedline(app.UIAxes,'Color',[0.8500 0.3250 0.0980]);

             sd_line = animatedline(app.UIAxes_2,"Color",[0 0.4470 0.7410]);
             referencia_line = animatedline(app.UIAxes_2,"Color",[0.8 0.8 0.08],"LineStyle","--");

             delay_figure = 0.1;
             timer_figure = delay_figure;
            %% Bucle principal
            % Primero se obtiene el sd_actual y se prepara el vector
            % tiempos de ejecución. Si el sd_actual es igual al objetivo no
            % hace nada
            write(app.serie_arduino,8,'int16');
            sd_objetivo = app.SDbuscadoEditField.Value;
            addpoints(referencia_line,0,sd_objetivo);

            n_array = 1000;
            t = zeros(n_array,1);
            tbasc = zeros(n_array,1);
            v1 = zeros(n_array,1);
            v2 = zeros(n_array,1);
            temp_dedo = zeros(n_array,1);
            variacion = zeros(n_array,1);
            temp_amb = zeros(n_array,1);
            hum_amb = zeros(n_array,1);

            t_start = tic;
            t_reanudacion = -1;
            i = 1;
            while app.final == 0
                ti = toc(t_start);                
                % Tomo los valores de la bascula y del arduino
                flush(app.serie_arduino);flush(app.serie_bascula);
                cadena_aux = readline(app.serie_bascula);
                [v1i,v2i,temp_dedoi,variacioni,hum_ambi,temp_ambi] = app.obtener_valores();
                lectura = 1;
                if ~isnan(variacioni)
                    addpoints(sd_line,ti,(variacioni+app.peso_inicial-app.peso_polimero)/app.peso_polimero);
                    writematrix([ti v1i v2i temp_dedoi ti variacioni hum_ambi temp_ambi],filename,"WriteMode","append");
                    sd_actual = (variacioni+app.peso_inicial-app.peso_polimero)/app.peso_polimero;
                else
                    lectura = 0;
                end
                
                t_final = 0;
                sec_hum = 6;
                % Si el sd actual está fuera de la banda establecida se
                % calcula el tiempo necesario para que llegue.
                if abs(sd_objetivo-sd_actual)>0.001 && lectura == 1
                    if sd_actual > sd_objetivo
                        % Hay que secar
                        sec_hum = 0;
                        
                        t_final = tiempo_funcionamiento(app,0,sd_actual)*0.95;
                        tiempos = 0:15:t_final;
                        addpoints(referencia_line,t_final+toc(t_start),sd_objetivo);
                        app.addmsg(sprintf("[%f] Comenzando secado de %.3f hasta %.3f durante %.0f minutos",toc(t_start)/60,sd_actual,sd_objetivo,t_final/60));
                    elseif sd_actual < sd_objetivo
                        % Hay que mojar
                        sec_hum = 2;
                        t_final = tiempo_funcionamiento(app,1,sd_actual)*0.95;
                        tiempos = 0:15:t_final;
                        addpoints(referencia_line,t_final+toc(t_start),sd_objetivo);
                        app.addmsg(sprintf("[%f] Comenzando humedecido de %.3f hasta %.3f durante %.0f minutos",toc(t_start)/60,sd_actual,sd_objetivo,t_final/60));
                        
                    end
                else
                    tiempos = 0;
                end

                %% Ejecucion del bucle de encendido/apagado
                % Codigo similar al anterior, con la diferencia que se
                % leen datos cada segundo
      
                %% Inicialización de la ejecución del programa               
                i3 = 1;
                app.PararButton.Enable = "on";

                %% Bucle de verdad
                app.final = 0;
                ind = 2; % El primer cambio es en el 15 no en el 0
                % app.MensajesTextArea.Value = sprintf("Tiempo de funcionamiento: %d",t_final);
                % app.addmsg(sprintf("Tiempo de funcionamiento: %d",t_final));
                
                app.funcionaLamp.Color = [0 1 0];
                encendido = 0;
                if t_final>0
                write(app.serie_arduino,2+sec_hum,'int16');
                end
                t_ex = tic;
                last_figure_update = toc(t_ex);
                % ti = toc(t_ex);
                t_inicio_exp = toc(t_start);
                try
                    while app.final == 0 && ind<=length(tiempos)
                        flush(app.serie_bascula);
                        cadena_aux = readline(app.serie_bascula);
                        % write(app.serie_arduino,1,'int16');
                        flush(app.serie_arduino);
                        
                        ti = toc(t_ex);
                        app.TiemposEditField.Value = ti;
                        % Control del encendido y apagado del sistema
                        if ti >= tiempos(ind)
                            if encendido == 1
                                write(app.serie_arduino,2+sec_hum,'int16');
                                app.encendido_lamp.Color = [0 1 0];
                                % fprintf("%d\n",2+sec_hum);
                                app.envioEditField.Value = string(2+sec_hum);
                                encendido = 0;
                            else
                                write(app.serie_arduino,3+sec_hum,'int16');
                                app.envioEditField.Value = string(3+sec_hum);
                                app.encendido_lamp.Color = [0.65 0.65 0.65];
                                encendido = 1;
                            end
                            ind = ind+1;
                            app.indiceEditField.Value = ind;
                        end
                        
                        % Se toman datos solo con el sistema apagado
                        if encendido == 1 && ti>tiempos(ind-1)+10
                            [v1(i3),v2(i3),temp_dedo(i3),variacion(i3),hum_amb(i3),temp_amb(i3)] = app.obtener_valores();
                            t(i3) = toc(t_start);
                            tbasc(i3) = t(i3);
                        
                            if(i3==n_array)
                                writematrix([t v1 v2 temp_dedo tbasc variacion],filename,'WriteMode','append');
                                i3 = 0;
                            end
                            i3 = i3+1;
                            i = i+1;
                        end
                        % Actualizar graficas
                        ti = toc(t_start);
                        if ti > last_figure_update+timer_figure
                            timer_figure = delay_figure - (ti-last_figure_update-timer_figure);
                            last_figure_update = ti;

                            addpoints(volt1_line,ti,app.Vsubpar1subVEditField.Value);
                            addpoints(volt2_line,ti,app.Vsubpar2subVEditField.Value);
                            addpoints(temp_line,ti,app.TemperaturaCEditField.Value);

                            % Añadir SD solo cuando el sistema este apagado
                            if encendido == 1 && ti>tiempos(ind-1)+10
                                addpoints(sd_line,ti,app.SDEditField.Value);
                            end

                        end
                        % Fin del bucle

                    end
                    write(app.serie_arduino,3+sec_hum,'int16');
                    t_reanudacion = toc(t_start);
                    ti = t_reanudacion;
                    writematrix([t(1:i3-1) v1(1:i3-1) v2(1:i3-1) temp_dedo(1:i3-1) tbasc(1:i3-1) variacion(1:i3-1)],filename,'WriteMode','append');
                    i3 = 1;
                    % Inicio del tiempo de reposo que tiene que pasar antes
                    % de realizar un nuevo proceso de secado o
                    % humidificación
                    while ti<t_reanudacion+1*60
                        pause(15);
                        % try
                        write(app.serie_arduino,8,'int16');
                        % app.obtener_valores();
                        [v1(i3),v2(i3),temp_dedo(i3),variacion(i3),hum_amb(i3),temp_amb(i3)] = app.obtener_valores();
                        t(i3) = toc(t_start);
                        tbasc(i3) = t(i3);
                        if(i3==n_array)
                            writematrix([t v1 v2 temp_dedo tbasc variacion],filename,'WriteMode','append');
                            i3 = 0;
                        end
                        i3 = i3+1;
                        i = i+1;
                        % catch
                        %     serialport(app.serie_arduino)
                        % end
                        ti = toc(t_start);
                        addpoints(volt1_line,ti,app.Vsubpar1subVEditField.Value);
                        addpoints(volt2_line,ti,app.Vsubpar2subVEditField.Value);
                        addpoints(temp_line,ti,app.TemperaturaCEditField.Value);
                        addpoints(sd_line,ti,app.SDEditField.Value);

                    end
                    % Se guardan los datos que queden por guardar.
                    writematrix([t(1:i3-1) v1(1:i3-1) v2(1:i3-1) temp_dedo(1:i3-1) tbasc(1:i3-1) variacion(1:i3-1)],filename,'WriteMode','append');
                catch
                    % app.MensajesTextArea.Value = "Ha habido un error";
                    app.addmsg(sprintf("[%f] Ha habido un error",toc(t_start)/60));
                    app.funcionaLamp.Color = [0.65 0.65 0.65];
                    app.acabar_execution();
                    display(lasterr);
                    write(app.serie_arduino,3+sec_hum,'int16');
                end

                    % i3 = 0;
            
            end
        end
    end

    methods (Access = public)
        
        function [v1,v2,temp_dedo,variacion,hum_amb,temp_amb] = obtener_valores(app)
            % Función que se encarga de leer el arduino y la bascula para
            % obtener los distintos datos. Tambien, se encarga de
            % actualizar estos valores en la UI

            % Obtener valores del arduino
            cadena = [];cadena2 = [];
            try
                cadena = readline(app.serie_arduino);
            catch
                app.serie_arduino.delete();
                app.serie_arduino = serialport(app.PuertoarduinoDropDown.Value,9600,'Timeout',10);
            end
            aux1 = 0;
            if ~isempty(cadena)
                % temp = char(cadena);
                if strncmp(cadena,"Fin",3)
                    app.final = 1;
                    % break;
                else
                    % fprintf(cadena)
                    cadenas = split(cadena,";");
                    % t_arduino(i) = double(cadenas(1));
                    if length(cadenas) == 5
                        t(i3) = ti;
                        v1 = double(cadenas(2))*5/1023;
                        v2 = double(cadenas(3))*5/1023;
                        temp_dedo = double(cadenas(4));

                        app.Vsubpar1subVEditField.Value = v1;
                        app.Vsubpar2subVEditField.Value = v2;
                        app.TemperaturaCEditField.Value = temp_dedo;
                        aux1 = 1;

                    elseif length(cadenas)==7
                        % Añadir cuando se mida humedad relativa
                        % t = ti;
                        v1 = double(cadenas(2))*5/1023;
                        v2 = double(cadenas(3))*5/1023;
                        temp_dedo = double(cadenas(4));

                        hum_amb = double(cadenas(5));
                        temp_amb = double(cadenas(6));

                        app.Vsubpar1subVEditField.Value = v1;
                        app.Vsubpar2subVEditField.Value = v2;
                        app.TemperaturaCEditField.Value = temp_dedo;
                        aux1 = 1;
                    end                   
                end
            end
            % Obtener los valores de la bascula
            
            try
                cadena2 = readline(app.serie_bascula);
            catch
                app.serie_bascula.delete();
                app.serie_bascula = serialport(app.PuertobasculaDropDown.Value,9600,'Timeout',10);
            end
            aux2 = 0;
            if ~isempty(cadena2)
                valor = double(erase(regexp(cadena2,'[\+\-]* *\d*\.\d*','match'),' '));
                if(isscalar(valor))
                    % tbasc(i3) = ti;
                    variacion = valor;

                    app.VariacingEditField.Value = variacion;
                    app.SDEditField.Value = (variacion+app.peso_inicial-app.peso_polimero)/app.peso_polimero;
                    aux2 = 1;
                end
            end
            if aux2 == 0;variacion = NaN;end
            if aux1 == 0;v1=NaN;v2=NaN;temp_dedo=NaN;hum_amb= NaN;temp_amb=NaN;  end
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Carga datos de ultima ejecución

            datos_last_ex = load("lastexecution.mat");
            app.R1kEditField.Value = datos_last_ex.r1;
            app.PesoinicialgEditField.Value = datos_last_ex.peso_inicial;
            app.R2kEditField.Value = datos_last_ex.r2;
            app.DedoDropDown.Value = datos_last_ex.dedo;
            app.ExperimentoDropDown.Value = datos_last_ex.experimento;
            app.GuardardatosButton.Value = datos_last_ex.guardar;

            app.DuracinSpinner.Value = datos_last_ex.duracion;
            
            app.peso_inicial = app.PesoinicialgEditField.Value;
            switch app.DedoDropDown.Value
                case "Mediano"
                    app.peso_polimero = 18.539;
                case "Pequeño"
                    app.peso_polimero = 22.222;
                case "Grande"
                    app.peso_polimero = 222.222;
            end
            app.SDinicialEditField.Value = (app.peso_inicial-app.peso_polimero)/app.peso_polimero;
            app.final = 0;

            % Prepara las figuras

            yyaxis(app.UIAxes,'left');
            ylabel(app.UIAxes,"Voltaje [V]");
            yyaxis(app.UIAxes,"right");
            ylabel(app.UIAxes,"Temperatura [ºC]");

            app.SDbuscadoEditField.Enable = "off";
            app.SDbuscadoEditField.Visible = "off";
            app.SDbuscadoEditFieldLabel.Visible = "off";
            
            % Se encienden y se hacen visibles los controles necesarios
            % segun el tipo de experimento.
            if app.TomardatosButton.Value == 1
                app.ExperimentoDropDown.Enable = "on";
                app.DuracinSpinner.Enable = "on";
                app.Monitorear_tras_secadoButton.Enable = "on";
                app.SDbuscadoEditField.Visible = "off";
                app.SDbuscadoEditFieldLabel.Visible = "off";
                app.TipodecontrolSwitch.Enable = "off";
                app.TipodecontrolSwitchLabel.Visible = "off";
                app.TipodecontrolSwitch.Visible = "off";
            elseif app.ControlButton.Value == 1
                app.ExperimentoDropDown.Enable = "off";
                app.DuracinSpinner.Enable = "off";
                app.Monitorear_tras_secadoButton.Enable = "off";
                app.SDbuscadoEditField.Visible = "on";
                app.SDbuscadoEditFieldLabel.Visible = "on";
                app.TipodecontrolSwitch.Enable = "on";
                app.TipodecontrolSwitchLabel.Visible = "on";
                app.TipodecontrolSwitch.Visible = "on";
            elseif app.MonitorearButton.Value == 1
                app.ExperimentoDropDown.Enable = "off";
                app.DuracinSpinner.Enable = "off";
                app.Monitorear_tras_secadoButton.Enable = "off";
                app.SDbuscadoEditField.Visible = "off";
                app.SDbuscadoEditFieldLabel.Visible = "off";
                app.TipodecontrolSwitch.Enable = "off";
                app.TipodecontrolSwitchLabel.Visible = "off";
                app.TipodecontrolSwitch.Visible = "off";

            end
        end

        % Drop down opening function: PuertoarduinoDropDown, 
        % ...and 1 other component
        function puertos_disponibles(app, event)
            % Se usa para ver los puertos serie disponibles
           
            puertos = serialportlist();
            app.PuertobasculaDropDown.Items = puertos;
            % app.PuertobasculaDropDown.Value = puertos;
            app.PuertoarduinoDropDown.Items = puertos;
        end

        % Value changed function: DedoDropDown, DuracinSpinner, 
        % ...and 5 other components
        function configuracion_cambios(app, event)
            % Cuando se realiza algun cambio en los valores de la
            % configuracion inicial se guardan
            r1 = app.R1kEditField.Value;
            r2 = app.R2kEditField.Value;
            app.peso_inicial = app.PesoinicialgEditField.Value;
            dedo = app.DedoDropDown.Value;
            experimento = app.ExperimentoDropDown.Value;
            duracion = app.DuracinSpinner.Value;
            peso_inicial = app.peso_inicial;
            if peso_inicial >100
                app.MensajesTextArea.Value = "Fiera pon bien el peso, que estas tonto"
                error("Pon el peso en gramos");
            end
            guardar = app.GuardardatosButton.Value;
            save("lastexecution.mat","experimento","dedo","r1","r2","peso_inicial","duracion","guardar","-append")

            switch dedo
                case "Mediano"
                    app.peso_polimero = 18.539;
                case "Pequeño"
                    app.peso_polimero = 22.222;
                case "Grande"
                    app.peso_polimero = 222.222;
            end

            app.peso_inicial = app.PesoinicialgEditField.Value;
            app.SDinicialEditField.Value = (app.peso_inicial-app.peso_polimero)/app.peso_polimero;

        end

        % Button pushed function: ComenzarButton
        function ComenzarButtonPushed(app, event)
            % Llama a la función correspondiente dependiendo del timpo de
            % experimento
            if app.ControlButton.Value == 1
                fprintf("Control\n");
                % if app.TipodecontrolSwitch.Value == true
                    app.control_bang();
                    
                % else
                %     app.control_bang();
                % 
                % end
            elseif app.TomardatosButton.Value == 1
                app.tomardatos();
            elseif(app.MonitorearButton.Value == 1)
                app.monitorear(1);
            end
        end

        % Button pushed function: ConectarButton
        function ConectarButtonPushed(app, event)
            % Función que se encarga de realizar la conexion serie con el
            % Arduino y la bascula. Solo si se conectan correctamente
            % ambos, se habilita el boton de comenzar.
            a = 0;
            try
                app.serie_arduino = serialport(app.PuertoarduinoDropDown.Value,9600,'Timeout',0.5);
                app.ind_arduinoLamp.Color = [0.00,1.00,0.00];
            catch
                a = 1;
                app.ind_arduinoLamp.Color = [1.00,0.00,0.00];
            end
            try
                app.serie_bascula = serialport(app.PuertobasculaDropDown.Value,9600,'Timeout',0.5);
                flush(app.serie_bascula);
                cadena = readline(app.serie_bascula);
                app.ind_basculaLamp.Color = [0,1,0];
                if ~isempty(cadena)
                    % app.MensajesTextArea.Value = cadena;
                    valor = double(erase(regexp(cadena,'[\+\-]* *\d*\.\d*','match'),' '));
                    if(~isscalar(valor))
                        a = a+4;
                        app.ind_basculaLamp.Color = [1.00,0.41,0.16];
                    end
                end

            catch
                a = a+2;
                app.ind_basculaLamp.Color = [1,0,0];
            end

            switch a
                case 0
                    mensaje = "Conectado";
                    app.ComenzarButton.Enable = "on";
                    app.ConexinPanel.Enable = "off";

                case 1
                    mensaje = "Arduino no conectado";
                    app.serie_arduino = 0;
                   
                    app.serie_bascula = 0;
                case 2
                    mensaje = "Bascula no conectada";
                    app.serie_arduino = 0;
                    app.serie_bascula = 0;
                case 3
                    mensaje = "No conectado";
                    app.serie_arduino = 0;
                    app.serie_bascula = 0;
                case 4
                    mensaje = "Bascula mal";
                    app.serie_arduino = 0;
                    app.serie_bascula = 0;
                case 5
                    mensaje = "Bascula mal y Ard. no conectado";
                    app.serie_arduino = 0;
                    app.serie_bascula = 0;
            end

            app.estado_conTextArea.Value = mensaje;
        end

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            % Se encarga de cambiar la interfaz segun el tipo de
            % experimento marcado
            selectedButton = app.ButtonGroup.SelectedObject;
            if app.ControlButton.Value == 1
                fprintf("Control\n");
                 app.ExperimentoDropDown.Enable = "off";
                app.DuracinSpinner.Enable = "off";
                app.Monitorear_tras_secadoButton.Enable = "off";
                app.SDbuscadoEditField.Visible = "on";
                app.SDbuscadoEditFieldLabel.Visible = "on";
                app.SDbuscadoEditField.Enable = "on";
                % app.NoejecutandoLabel.Text = "Control";
                app.TipodecontrolSwitch.Enable = "on";
                app.TipodecontrolSwitchLabel.Visible = "on";
                app.TipodecontrolSwitch.Visible = "on";
            elseif app.TomardatosButton.Value == 1
                app.ExperimentoDropDown.Enable = "on";
                app.DuracinSpinner.Enable = "on";
                app.Monitorear_tras_secadoButton.Enable = "on";
                app.SDbuscadoEditField.Visible = "off";
                app.SDbuscadoEditFieldLabel.Visible = "off";
                % app.NoejecutandoLabel.Text = "Tomando datos";
                app.TipodecontrolSwitch.Enable = "off";
                app.TipodecontrolSwitchLabel.Visible = "off";
                app.TipodecontrolSwitch.Visible = "off";
                fprintf("Tomar datos\n");
            elseif app.MonitorearButton.Value == 1
                % añadir cosas
                app.ExperimentoDropDown.Enable = "off";
                app.DuracinSpinner.Enable = "off";
                app.Monitorear_tras_secadoButton.Enable = "off";
                app.SDbuscadoEditField.Visible = "off";
                app.SDbuscadoEditFieldLabel.Visible = "off";
                                app.TipodecontrolSwitch.Enable = "off";
                app.TipodecontrolSwitchLabel.Visible = "off";
                app.TipodecontrolSwitch.Visible = "off";
                % app.NoejecutandoLabel.Text = "Monitorizando";

            end

        end

        % Button pushed function: PararButton
        function PararButtonPushed(app, event)
            app.final = 1;
            % Para la ejecución de los distintos procesos
            % app.MensajesTextArea.Value = "Parando ejecución";
            app.addmsg('Parando ejecución');
        end

        % Value changed function: MensajesTextArea
        function MensajesTextAreaValueChanged(app, event)
            value = app.MensajesTextArea.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1378 658];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Arduino')
            xlabel(app.UIAxes, 'Tiempo [s]')
            ylabel(app.UIAxes, 'Hola')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [924 344 394 277];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            title(app.UIAxes_2, 'SD')
            xlabel(app.UIAxes_2, 'Tiempo [s]')
            ylabel(app.UIAxes_2, 'SD')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.XGrid = 'on';
            app.UIAxes_2.YGrid = 'on';
            app.UIAxes_2.Position = [924 45 394 281];

            % Create ConexinPanel
            app.ConexinPanel = uipanel(app.UIFigure);
            app.ConexinPanel.Title = 'Conexión';
            app.ConexinPanel.Position = [34 459 354 161];

            % Create estado_conTextArea
            app.estado_conTextArea = uitextarea(app.ConexinPanel);
            app.estado_conTextArea.Position = [55 17 150 21];
            app.estado_conTextArea.Value = {'Esperando conexión'};

            % Create PuertobasculaDropDownLabel
            app.PuertobasculaDropDownLabel = uilabel(app.ConexinPanel);
            app.PuertobasculaDropDownLabel.HorizontalAlignment = 'right';
            app.PuertobasculaDropDownLabel.Position = [55 94 85 22];
            app.PuertobasculaDropDownLabel.Text = 'Puerto bascula';

            % Create PuertobasculaDropDown
            app.PuertobasculaDropDown = uidropdown(app.ConexinPanel);
            app.PuertobasculaDropDown.Items = {'COM4', 'COM5'};
            app.PuertobasculaDropDown.DropDownOpeningFcn = createCallbackFcn(app, @puertos_disponibles, true);
            app.PuertobasculaDropDown.Position = [155 94 100 22];
            app.PuertobasculaDropDown.Value = 'COM4';

            % Create PuertoarduinoDropDownLabel
            app.PuertoarduinoDropDownLabel = uilabel(app.ConexinPanel);
            app.PuertoarduinoDropDownLabel.HorizontalAlignment = 'right';
            app.PuertoarduinoDropDownLabel.Position = [54 60 84 22];
            app.PuertoarduinoDropDownLabel.Text = 'Puerto arduino';

            % Create PuertoarduinoDropDown
            app.PuertoarduinoDropDown = uidropdown(app.ConexinPanel);
            app.PuertoarduinoDropDown.Items = {'COM4', 'COM5'};
            app.PuertoarduinoDropDown.DropDownOpeningFcn = createCallbackFcn(app, @puertos_disponibles, true);
            app.PuertoarduinoDropDown.Position = [153 60 100 22];
            app.PuertoarduinoDropDown.Value = 'COM5';

            % Create ConectarButton
            app.ConectarButton = uibutton(app.ConexinPanel, 'push');
            app.ConectarButton.ButtonPushedFcn = createCallbackFcn(app, @ConectarButtonPushed, true);
            app.ConectarButton.Position = [220 15 100 23];
            app.ConectarButton.Text = 'Conectar';

            % Create ind_arduinoLamp
            app.ind_arduinoLamp = uilamp(app.ConexinPanel);
            app.ind_arduinoLamp.Position = [286 62 17 17];
            app.ind_arduinoLamp.Color = [0.651 0.651 0.651];

            % Create ind_basculaLamp
            app.ind_basculaLamp = uilamp(app.ConexinPanel);
            app.ind_basculaLamp.Position = [286 98 17 17];
            app.ind_basculaLamp.Color = [0.651 0.651 0.651];

            % Create ConfiguracininicialPanel
            app.ConfiguracininicialPanel = uipanel(app.UIFigure);
            app.ConfiguracininicialPanel.Title = 'Configuración inicial';
            app.ConfiguracininicialPanel.Position = [34 99 354 343];

            % Create PesoinicialgEditFieldLabel
            app.PesoinicialgEditFieldLabel = uilabel(app.ConfiguracininicialPanel);
            app.PesoinicialgEditFieldLabel.Position = [33 223 82 22];
            app.PesoinicialgEditFieldLabel.Text = 'Peso inicial [g]';

            % Create PesoinicialgEditField
            app.PesoinicialgEditField = uieditfield(app.ConfiguracininicialPanel, 'numeric');
            app.PesoinicialgEditField.ValueDisplayFormat = '%.3f';
            app.PesoinicialgEditField.ValueChangedFcn = createCallbackFcn(app, @configuracion_cambios, true);
            app.PesoinicialgEditField.Position = [133 223 60 22];

            % Create R1Label
            app.R1Label = uilabel(app.ConfiguracininicialPanel);
            app.R1Label.Position = [33 181 45 22];
            app.R1Label.Text = 'R1 [kΩ]';

            % Create R1kEditField
            app.R1kEditField = uieditfield(app.ConfiguracininicialPanel, 'numeric');
            app.R1kEditField.Limits = [0 110];
            app.R1kEditField.ValueDisplayFormat = '%.5g';
            app.R1kEditField.ValueChangedFcn = createCallbackFcn(app, @configuracion_cambios, true);
            app.R1kEditField.Position = [133 181 61 22];

            % Create ExperimentoDropDownLabel
            app.ExperimentoDropDownLabel = uilabel(app.ConfiguracininicialPanel);
            app.ExperimentoDropDownLabel.Position = [33 283 72 22];
            app.ExperimentoDropDownLabel.Text = 'Experimento';

            % Create ExperimentoDropDown
            app.ExperimentoDropDown = uidropdown(app.ConfiguracininicialPanel);
            app.ExperimentoDropDown.Items = {'Secado', 'Humedecido', 'Secado frio', 'Secado Silice', 'Toma de datos'};
            app.ExperimentoDropDown.ValueChangedFcn = createCallbackFcn(app, @configuracion_cambios, true);
            app.ExperimentoDropDown.Position = [133 283 100 22];
            app.ExperimentoDropDown.Value = 'Secado';

            % Create DedoDropDownLabel
            app.DedoDropDownLabel = uilabel(app.ConfiguracininicialPanel);
            app.DedoDropDownLabel.Position = [33 256 34 22];
            app.DedoDropDownLabel.Text = 'Dedo';

            % Create DedoDropDown
            app.DedoDropDown = uidropdown(app.ConfiguracininicialPanel);
            app.DedoDropDown.Items = {'Mediano', 'Pequeño'};
            app.DedoDropDown.ValueChangedFcn = createCallbackFcn(app, @configuracion_cambios, true);
            app.DedoDropDown.Position = [133 256 100 22];
            app.DedoDropDown.Value = 'Mediano';

            % Create R2Label
            app.R2Label = uilabel(app.ConfiguracininicialPanel);
            app.R2Label.Position = [208 181 45 22];
            app.R2Label.Text = 'R2 [kΩ]';

            % Create R2kEditField
            app.R2kEditField = uieditfield(app.ConfiguracininicialPanel, 'numeric');
            app.R2kEditField.Limits = [0 110];
            app.R2kEditField.ValueDisplayFormat = '%.5g';
            app.R2kEditField.ValueChangedFcn = createCallbackFcn(app, @configuracion_cambios, true);
            app.R2kEditField.Position = [274 181 61 22];
            app.R2kEditField.Value = 11.365;

            % Create AnotacionesEditFieldLabel
            app.AnotacionesEditFieldLabel = uilabel(app.ConfiguracininicialPanel);
            app.AnotacionesEditFieldLabel.Position = [33 147 71 22];
            app.AnotacionesEditFieldLabel.Text = 'Anotaciones';

            % Create AnotacionesEditField
            app.AnotacionesEditField = uieditfield(app.ConfiguracininicialPanel, 'text');
            app.AnotacionesEditField.Position = [133 147 177 22];
            app.AnotacionesEditField.Value = 'hdfuiehfiuewhfiuehwifhikwehfiuhweiufhiuwehfuihwe';

            % Create DuracinSpinnerLabel
            app.DuracinSpinnerLabel = uilabel(app.ConfiguracininicialPanel);
            app.DuracinSpinnerLabel.Position = [33 109 53 22];
            app.DuracinSpinnerLabel.Text = 'Duración';

            % Create DuracinSpinner
            app.DuracinSpinner = uispinner(app.ConfiguracininicialPanel);
            app.DuracinSpinner.ValueChangedFcn = createCallbackFcn(app, @configuracion_cambios, true);
            app.DuracinSpinner.Position = [133 109 51 22];
            app.DuracinSpinner.Value = 3.5;

            % Create SDinicialEditFieldLabel
            app.SDinicialEditFieldLabel = uilabel(app.ConfiguracininicialPanel);
            app.SDinicialEditFieldLabel.Position = [208 223 55 22];
            app.SDinicialEditFieldLabel.Text = 'SD inicial';

            % Create SDinicialEditField
            app.SDinicialEditField = uieditfield(app.ConfiguracininicialPanel, 'numeric');
            app.SDinicialEditField.ValueDisplayFormat = '%.3f';
            app.SDinicialEditField.Position = [274 223 59 22];

            % Create GuardardatosButton
            app.GuardardatosButton = uibutton(app.ConfiguracininicialPanel, 'state');
            app.GuardardatosButton.ValueChangedFcn = createCallbackFcn(app, @configuracion_cambios, true);
            app.GuardardatosButton.Text = 'Guardar datos';
            app.GuardardatosButton.Position = [217 109 100 23];

            % Create ArchivoEditFieldLabel
            app.ArchivoEditFieldLabel = uilabel(app.ConfiguracininicialPanel);
            app.ArchivoEditFieldLabel.Position = [33 71 45 22];
            app.ArchivoEditFieldLabel.Text = 'Archivo';

            % Create ArchivoEditField
            app.ArchivoEditField = uieditfield(app.ConfiguracininicialPanel, 'text');
            app.ArchivoEditField.Editable = 'off';
            app.ArchivoEditField.Placeholder = 'Archivo de guardado';
            app.ArchivoEditField.Position = [133 71 177 22];

            % Create Monitorear_tras_secadoButton
            app.Monitorear_tras_secadoButton = uibutton(app.ConfiguracininicialPanel, 'state');
            app.Monitorear_tras_secadoButton.Text = 'Monitorear_tras_secado';
            app.Monitorear_tras_secadoButton.Position = [111 41 144 23];
            app.Monitorear_tras_secadoButton.Value = true;

            % Create TemperaturaambienteCEditFieldLabel
            app.TemperaturaambienteCEditFieldLabel = uilabel(app.ConfiguracininicialPanel);
            app.TemperaturaambienteCEditFieldLabel.Position = [33 9 145 22];
            app.TemperaturaambienteCEditFieldLabel.Text = 'Temperatura ambiente[°C]';

            % Create TemperaturaambienteCEditField
            app.TemperaturaambienteCEditField = uieditfield(app.ConfiguracininicialPanel, 'numeric');
            app.TemperaturaambienteCEditField.Position = [252 9 55 22];
            app.TemperaturaambienteCEditField.Value = 28.7;

            % Create ComenzarButton
            app.ComenzarButton = uibutton(app.UIFigure, 'push');
            app.ComenzarButton.ButtonPushedFcn = createCallbackFcn(app, @ComenzarButtonPushed, true);
            app.ComenzarButton.Enable = 'off';
            app.ComenzarButton.Position = [404 259 184 86];
            app.ComenzarButton.Text = 'Comenzar';

            % Create DatosPanel
            app.DatosPanel = uipanel(app.UIFigure);
            app.DatosPanel.Title = 'Datos';
            app.DatosPanel.Position = [404 408 417 213];

            % Create VariacingEditFieldLabel
            app.VariacingEditFieldLabel = uilabel(app.DatosPanel);
            app.VariacingEditFieldLabel.Position = [22 158 71 22];
            app.VariacingEditFieldLabel.Text = 'Variación [g]';

            % Create VariacingEditField
            app.VariacingEditField = uieditfield(app.DatosPanel, 'numeric');
            app.VariacingEditField.ValueDisplayFormat = '%.3f';
            app.VariacingEditField.Editable = 'off';
            app.VariacingEditField.Position = [128 158 55 22];
            app.VariacingEditField.Value = -25.5646;

            % Create Vsubpar1subLabel
            app.Vsubpar1subLabel = uilabel(app.DatosPanel);
            app.Vsubpar1subLabel.Interpreter = 'html';
            app.Vsubpar1subLabel.Position = [22 124 56 22];
            app.Vsubpar1subLabel.Text = 'V<sub>par 1</sub> [V]';

            % Create Vsubpar1subVEditField
            app.Vsubpar1subVEditField = uieditfield(app.DatosPanel, 'numeric');
            app.Vsubpar1subVEditField.Editable = 'off';
            app.Vsubpar1subVEditField.Position = [128 124 55 22];
            app.Vsubpar1subVEditField.Value = 53.275;

            % Create SDEditFieldLabel
            app.SDEditFieldLabel = uilabel(app.DatosPanel);
            app.SDEditFieldLabel.Position = [217 158 25 22];
            app.SDEditFieldLabel.Text = 'SD';

            % Create SDEditField
            app.SDEditField = uieditfield(app.DatosPanel, 'numeric');
            app.SDEditField.Editable = 'off';
            app.SDEditField.Position = [323 158 55 22];

            % Create Vsubpar2subLabel
            app.Vsubpar2subLabel = uilabel(app.DatosPanel);
            app.Vsubpar2subLabel.Interpreter = 'html';
            app.Vsubpar2subLabel.Position = [22 86 56 22];
            app.Vsubpar2subLabel.Text = 'V<sub>par 2</sub> [V]';

            % Create Vsubpar2subVEditField
            app.Vsubpar2subVEditField = uieditfield(app.DatosPanel, 'numeric');
            app.Vsubpar2subVEditField.Editable = 'off';
            app.Vsubpar2subVEditField.Position = [128 86 55 22];

            % Create TemperaturaCLabel
            app.TemperaturaCLabel = uilabel(app.DatosPanel);
            app.TemperaturaCLabel.Position = [22 48 96 22];
            app.TemperaturaCLabel.Text = 'Temperatura [°C]';

            % Create TemperaturaCEditField
            app.TemperaturaCEditField = uieditfield(app.DatosPanel, 'numeric');
            app.TemperaturaCEditField.Editable = 'off';
            app.TemperaturaCEditField.Position = [128 48 55 22];

            % Create Rsubpar1subLabel
            app.Rsubpar1subLabel = uilabel(app.DatosPanel);
            app.Rsubpar1subLabel.Interpreter = 'html';
            app.Rsubpar1subLabel.Position = [217 124 57 22];
            app.Rsubpar1subLabel.Text = 'R<sub>par 1</sub> [Ω]';

            % Create Resistencia_par1
            app.Resistencia_par1 = uieditfield(app.DatosPanel, 'numeric');
            app.Resistencia_par1.Editable = 'off';
            app.Resistencia_par1.Position = [323 124 55 22];
            app.Resistencia_par1.Value = 53.275;

            % Create Rsubpar2subLabel
            app.Rsubpar2subLabel = uilabel(app.DatosPanel);
            app.Rsubpar2subLabel.Interpreter = 'html';
            app.Rsubpar2subLabel.Position = [217 86 57 22];
            app.Rsubpar2subLabel.Text = 'R<sub>par 2</sub> [Ω]';

            % Create Resistencia_par2
            app.Resistencia_par2 = uieditfield(app.DatosPanel, 'numeric');
            app.Resistencia_par2.Editable = 'off';
            app.Resistencia_par2.Position = [323 86 55 22];

            % Create TiemposEditFieldLabel
            app.TiemposEditFieldLabel = uilabel(app.DatosPanel);
            app.TiemposEditFieldLabel.HorizontalAlignment = 'right';
            app.TiemposEditFieldLabel.Position = [211 51 61 22];
            app.TiemposEditFieldLabel.Text = 'Tiempo [s]';

            % Create TiemposEditField
            app.TiemposEditField = uieditfield(app.DatosPanel, 'numeric');
            app.TiemposEditField.Position = [323 51 55 22];

            % Create PararButton
            app.PararButton = uibutton(app.UIFigure, 'push');
            app.PararButton.ButtonPushedFcn = createCallbackFcn(app, @PararButtonPushed, true);
            app.PararButton.BackgroundColor = [0.9686 0.349 0.349];
            app.PararButton.Enable = 'off';
            app.PararButton.Position = [638 259 184 86];
            app.PararButton.Text = 'Parar';

            % Create MensajesTextAreaLabel
            app.MensajesTextAreaLabel = uilabel(app.UIFigure);
            app.MensajesTextAreaLabel.HorizontalAlignment = 'right';
            app.MensajesTextAreaLabel.Position = [405 187 56 22];
            app.MensajesTextAreaLabel.Text = 'Mensajes';

            % Create MensajesTextArea
            app.MensajesTextArea = uitextarea(app.UIFigure);
            app.MensajesTextArea.ValueChangedFcn = createCallbackFcn(app, @MensajesTextAreaValueChanged, true);
            app.MensajesTextArea.Position = [405 121 417 60];

            % Create funcionaLamp
            app.funcionaLamp = uilamp(app.UIFigure);
            app.funcionaLamp.Position = [604 320 20 20];
            app.funcionaLamp.Color = [0.651 0.651 0.651];

            % Create encendido_lamp
            app.encendido_lamp = uilamp(app.UIFigure);
            app.encendido_lamp.Position = [604 261 20 20];
            app.encendido_lamp.Color = [0.651 0.651 0.651];

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.UIFigure);
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.Title = 'Button Group';
            app.ButtonGroup.Position = [405 355 273 49];

            % Create TomardatosButton
            app.TomardatosButton = uiradiobutton(app.ButtonGroup);
            app.TomardatosButton.Text = 'Tomar datos';
            app.TomardatosButton.Position = [11 3 88 22];
            app.TomardatosButton.Value = true;

            % Create ControlButton
            app.ControlButton = uiradiobutton(app.ButtonGroup);
            app.ControlButton.Text = 'Control';
            app.ControlButton.Position = [103 3 65 22];

            % Create MonitorearButton
            app.MonitorearButton = uiradiobutton(app.ButtonGroup);
            app.MonitorearButton.Text = 'Monitorear';
            app.MonitorearButton.Position = [175 3 79 22];

            % Create SDbuscadoEditFieldLabel
            app.SDbuscadoEditFieldLabel = uilabel(app.UIFigure);
            app.SDbuscadoEditFieldLabel.Position = [736 382 70 22];
            app.SDbuscadoEditFieldLabel.Text = 'SD buscado';

            % Create SDbuscadoEditField
            app.SDbuscadoEditField = uieditfield(app.UIFigure, 'numeric');
            app.SDbuscadoEditField.Position = [736 358 85 22];

            % Create pruebaEditFieldLabel
            app.pruebaEditFieldLabel = uilabel(app.UIFigure);
            app.pruebaEditFieldLabel.HorizontalAlignment = 'right';
            app.pruebaEditFieldLabel.Visible = 'off';
            app.pruebaEditFieldLabel.Position = [439 68 42 22];
            app.pruebaEditFieldLabel.Text = 'prueba';

            % Create pruebaEditField
            app.pruebaEditField = uieditfield(app.UIFigure, 'numeric');
            app.pruebaEditField.Visible = 'off';
            app.pruebaEditField.Position = [496 68 100 22];

            % Create prueba1EditFieldLabel
            app.prueba1EditFieldLabel = uilabel(app.UIFigure);
            app.prueba1EditFieldLabel.HorizontalAlignment = 'right';
            app.prueba1EditFieldLabel.Visible = 'off';
            app.prueba1EditFieldLabel.Position = [432 87 49 22];
            app.prueba1EditFieldLabel.Text = 'prueba1';

            % Create prueba1EditField
            app.prueba1EditField = uieditfield(app.UIFigure, 'numeric');
            app.prueba1EditField.Visible = 'off';
            app.prueba1EditField.Position = [496 87 100 22];

            % Create NoejecutandoLabel
            app.NoejecutandoLabel = uilabel(app.UIFigure);
            app.NoejecutandoLabel.HorizontalAlignment = 'center';
            app.NoejecutandoLabel.FontSize = 24;
            app.NoejecutandoLabel.Position = [419 208 387 31];
            app.NoejecutandoLabel.Text = 'No ejecutando';

            % Create ErrorLamp
            app.ErrorLamp = uilamp(app.UIFigure);
            app.ErrorLamp.Position = [604 290 20 20];
            app.ErrorLamp.Color = [0.902 0.902 0.902];

            % Create indiceEditFieldLabel
            app.indiceEditFieldLabel = uilabel(app.UIFigure);
            app.indiceEditFieldLabel.HorizontalAlignment = 'right';
            app.indiceEditFieldLabel.Visible = 'off';
            app.indiceEditFieldLabel.Position = [642 87 36 22];
            app.indiceEditFieldLabel.Text = 'indice';

            % Create indiceEditField
            app.indiceEditField = uieditfield(app.UIFigure, 'numeric');
            app.indiceEditField.Visible = 'off';
            app.indiceEditField.Position = [693 87 100 22];

            % Create envioEditFieldLabel
            app.envioEditFieldLabel = uilabel(app.UIFigure);
            app.envioEditFieldLabel.HorizontalAlignment = 'right';
            app.envioEditFieldLabel.Visible = 'off';
            app.envioEditFieldLabel.Position = [447 32 34 22];
            app.envioEditFieldLabel.Text = 'envio';

            % Create envioEditField
            app.envioEditField = uieditfield(app.UIFigure, 'text');
            app.envioEditField.Visible = 'off';
            app.envioEditField.Position = [496 32 100 22];

            % Create TipodecontrolSwitchLabel
            app.TipodecontrolSwitchLabel = uilabel(app.UIFigure);
            app.TipodecontrolSwitchLabel.HorizontalAlignment = 'center';
            app.TipodecontrolSwitchLabel.Position = [831 397 84 22];
            app.TipodecontrolSwitchLabel.Text = 'Tipo de control';

            % Create TipodecontrolSwitch
            app.TipodecontrolSwitch = uiswitch(app.UIFigure, 'toggle');
            app.TipodecontrolSwitch.Items = {'Pseudo', 'Bang Bang'};
            app.TipodecontrolSwitch.Position = [863 332 20 45];
            app.TipodecontrolSwitch.Value = 'Pseudo';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = control_plataforma

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end