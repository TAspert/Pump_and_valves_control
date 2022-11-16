classdef Pump_controller_v2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        DirectionSwitchLabel  matlab.ui.control.Label
        DirectionSwitch       matlab.ui.control.Switch
        Switch2               matlab.ui.control.ToggleSwitch
        RoutinePanel          matlab.ui.container.Panel
        Flow1SpinnerLabel     matlab.ui.control.Label
        Flow1Spinner          matlab.ui.control.Spinner
        Time1SpinnerLabel     matlab.ui.control.Label
        Time1Spinner          matlab.ui.control.Spinner
        Flow2SpinnerLabel     matlab.ui.control.Label
        Flow2Spinner          matlab.ui.control.Spinner
        DurationSpinnerLabel  matlab.ui.control.Label
        DurationSpinner       matlab.ui.control.Spinner
        Time2SpinnerLabel     matlab.ui.control.Label
        Time2Spinner          matlab.ui.control.Spinner
        RoutineSwitch         matlab.ui.control.Switch
        PortDropDownLabel     matlab.ui.control.Label
        PortDropDown          matlab.ui.control.DropDown
        EditField             matlab.ui.control.EditField
        ConnectButton         matlab.ui.control.StateButton
        EditField_2           matlab.ui.control.EditField
        CalibSpinnerLabel     matlab.ui.control.Label
        CalibSpinner          matlab.ui.control.Spinner

        DESCRIPTION='Ismatec IPC';
        NAME='Pump1';
        BAUD_RATE=9600;
        TERMINATOR='CR';
        
        GET_DEBIT='1!';
        GET_ID='1+';
        SET_CW_DIRECTION='1J';
        SET_CCW_DIRECTION='1K';
        SET_DEBIT='1S';
        SET_ID='1+00';
        START='1H';
        STOP='1I';
        TIMER=0;
       
        SERIAL;
    end
    
    methods (Access = private)
        
        function connect(app)
                app.SERIAL = serialport(app.PortDropDown.Value,app.BAUD_RATE);
                configureTerminator(app.SERIAL,app.TERMINATOR);
                configureCallback(app.SERIAL,'terminator',@read)
                
                switchOnOff(app);                
                out=' ';
                if out == '*'
                    app.EditField.Value='Connected';
                elseif out~='*'
                    app.EditField.Value='Not connected';
                end
        end
        
        function disconnect(app)
               app.SERIAL=[];%clear the port
               app.EditField.Value= 'Not connected';
        end
                
        function runLoop(app)
            n=1;
            tic;
            app.TIMER=toc; %in milliseconds

                while app.TIMER <app.DurationSpinner.Value*60000 && app.RoutineSwitch.Value=='On' 

                    if (n-1)*60*(app.Time1Spinner.Value+app.Time2Spinner.Value)<app.TIMER && app.TIMER< (n-1)*60*app.Time2Spinner.Value+  n*60*app.Time1Spinner.Value
                        towrite=sprintf('%05d',     10*round(app.CalibSpinner.Value*app.Flow1Spinner.Value/100,1));
                        write(app,strcat(app.SET_DEBIT,towrite));

                    elseif  (n-1)*60*app.Time2Spinner.Value  +  n*60*app.Time1Spinner.Value<app.TIMER &&  app.TIMER<n*60*(app.Time1Spinner.Value+app.Time2Spinner.Value)
                        towrite=sprintf('%05d',    10*round(app.CalibSpinner.Value*app.Flow2Spinner.Value/100,1));
                        write(app,strcat(app.SET_DEBIT,towrite));
                    
                    else
                    end

                    if app.TIMER>n*60*(app.Time1Spinner.Value+app.Time2Spinner.Value)
                        n=n+1;
                    end

                    app.TIMER=toc;
                    pause(1)
                end
        end
        
        %SET THE DIRECTION OF ROTATION
        function setDirection(app)
            if app.DirectionSwitch.Value=='-'
                write(app,app.SET_CCW_DIRECTION)
%                 read(app);
            elseif app.DirectionSwitch.Value=='+'
                write(app,app.SET_CW_DIRECTION)
%                 read(app);
            end
        end
        
        
        %LAUNCH OR STOP THE PUMP ROTATION
        function switchOnOff(app)
            if app.Switch2.Value=='On'
               write(app,app.START);
%                read(app);
               
            elseif app.Switch2.Value=='Off'
               write(app,app.STOP);
%                read(app);
            end
        end
        
        %WRITE
        function write(app,message)
               writeline(app.SERIAL,message);
               app.EditField_2.Value=strcat(app.EditField_2.Value,' Sent ',message);
        end
        
        %READ
        function out=read(app, event)
               out = readline(app.SERIAL);
               app.EditField_2.Value=strcat(app.EditField_2.Value,' Read',out);
        end
        
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: FramerateSpinner
        function FramerateSpinnerValueChanged(app, event)
            app.FramerateSpinner.Value;
%             read(app)
        end

        % Value changed function: DirectionSwitch
        function DirectionSwitchValueChanged(app, event)
            app.DirectionSwitch.Value;
            setDirection(app);
        end


        % Value changed function: Switch2
        function Switch2ValueChanged(app, event)
            switchOnOff(app);
        end

%         Value changed function: ConnectButton
        function ConnectButtonValueChanged(app, event)
            if app.ConnectButton.Value==1
                connect(app)
            elseif app.ConnectButton.Value==0
                disconnect(app)
            end
        end
        
         % Value changed function: Flow1Spinner
        function Flow1SpinnerValueChanged(app, event)
            app.Flow1Spinner.Value;
            
        end
        
         % Value changed function: Flow1Spinner
        function Flow2SpinnerValueChanged(app, event)
            app.Flow2Spinner.Value;
            
        end
        
        % Callback function
        function Time1SpinnerValueChanged(app, event)
            app.Time1Spinner.Value;
            
        end
        
        % Callback function
        function Time2SpinnerValueChanged(app, event)
            app.Time2Spinner.Value;
            
        end
        
         % Value changed function: RoutineSwitch
        function RoutineSwitchValueChanged(app, event)
                runLoop(app);   
        end
    end
    
% Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 448 306];
            app.UIFigure.Name = 'UI Figure';

            % Create DirectionSwitchLabel
            app.DirectionSwitchLabel = uilabel(app.UIFigure);
            app.DirectionSwitchLabel.HorizontalAlignment = 'center';
            app.DirectionSwitchLabel.Position = [27 28 53 22];
            app.DirectionSwitchLabel.Text = 'Direction';

            % Create DirectionSwitch
            app.DirectionSwitch = uiswitch(app.UIFigure, 'slider');
            app.DirectionSwitch.Items = {'-', '+'};
            app.DirectionSwitch.ValueChangedFcn = createCallbackFcn(app, @DirectionSwitchValueChanged, true);
            app.DirectionSwitch.Position = [31 57 45 20];
            app.DirectionSwitch.Value = '-';

            % Create Switch2
            app.Switch2 = uiswitch(app.UIFigure, 'toggle');
            app.Switch2.ValueChangedFcn = createCallbackFcn(app, @Switch2ValueChanged, true);
            app.Switch2.Position = [21 112 20 45];

            % Create RoutinePanel
            app.RoutinePanel = uipanel(app.UIFigure);
            app.RoutinePanel.Title = 'Routine';
            app.RoutinePanel.Position = [101 19 338 203];

            % Create Flow1SpinnerLabel
            app.Flow1SpinnerLabel = uilabel(app.RoutinePanel);
            app.Flow1SpinnerLabel.Position = [10 157 38 22];
            app.Flow1SpinnerLabel.Text = 'Flow1';

            % Create Flow1Spinner
            app.Flow1Spinner = uispinner(app.RoutinePanel);
            app.Flow1Spinner.ValueChangedFcn = createCallbackFcn(app, @Flow1SpinnerValueChanged, true);
            app.Flow1Spinner.Position = [196 157 100 22];

            % Create RoutineSwitch
            app.RoutineSwitch = uiswitch(app.RoutinePanel, 'slider');
            app.RoutineSwitch.ValueChangedFcn = createCallbackFcn(app, @RoutineSwitchValueChanged, true);
            app.RoutineSwitch.Position = [125 10 45 20];

            % Create Time1SpinnerLabel
            app.Time1SpinnerLabel = uilabel(app.RoutinePanel);
            app.Time1SpinnerLabel.Position = [10 136 38 22];
            app.Time1SpinnerLabel.Text = 'Time1';

            % Create Time1Spinner
            app.Time1Spinner = uispinner(app.RoutinePanel);
            app.Time1Spinner.Position = [196 136 100 22];

            % Create Flow2SpinnerLabel
            app.Flow2SpinnerLabel = uilabel(app.RoutinePanel);
            app.Flow2SpinnerLabel.Position = [10 104 38 22];
            app.Flow2SpinnerLabel.Text = 'Flow2';

            % Create Flow2Spinner
            app.Flow2Spinner = uispinner(app.RoutinePanel);
            app.Flow2Spinner.Position = [196 104 100 22];

            % Create Time2SpinnerLabel
            app.Time2SpinnerLabel = uilabel(app.RoutinePanel);
            app.Time2SpinnerLabel.Position = [10 83 38 22];
            app.Time2SpinnerLabel.Text = 'Time2';

            % Create Time2Spinner
            app.Time2Spinner = uispinner(app.RoutinePanel);
            app.Time2Spinner.Position = [196 83 100 22];

            % Create DurationSpinnerLabel
            app.DurationSpinnerLabel = uilabel(app.RoutinePanel);
            app.DurationSpinnerLabel.Position = [10 30 51 22];
            app.DurationSpinnerLabel.Text = 'Duration';

            % Create DurationSpinner
            app.DurationSpinner = uispinner(app.RoutinePanel);
            app.DurationSpinner.Position = [196 30 100 22];

            % Create CalibSpinnerLabel
            app.CalibSpinnerLabel = uilabel(app.RoutinePanel);
            app.CalibSpinnerLabel.Position = [10 57 33 22];
            app.CalibSpinnerLabel.Text = 'Calib';

            % Create CalibSpinner
            app.CalibSpinner = uispinner(app.RoutinePanel);
            app.CalibSpinner.Position = [196 57 100 22];
            app.CalibSpinner.Value=5;

            % Create PortDropDownLabel
            app.PortDropDownLabel = uilabel(app.UIFigure);
            app.PortDropDownLabel.HorizontalAlignment = 'right';
            app.PortDropDownLabel.Position = [16 239 28 22];
            app.PortDropDownLabel.Text = 'Port';

            % Create PortDropDown
            app.PortDropDown = uidropdown(app.UIFigure);
            app.PortDropDown.Items = seriallist;
            app.PortDropDown.ValueChangedFcn = createCallbackFcn(app, @PortDropDownValueChanged, true);
            app.PortDropDown.Position = [59 239 100 22];
            app.PortDropDown.Value = 'COM1';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'text');
            app.EditField.ValueChangedFcn = createCallbackFcn(app, @EditFieldValueChanged, true);
            app.EditField.ValueChangingFcn = createCallbackFcn(app, @EditFieldValueChanging, true);
            app.EditField.Editable = 'off';
            app.EditField.Position = [171 265 100 22];
            app.EditField.Value = 'Not connected';

            % Create ConnectButton
            app.ConnectButton = uibutton(app.UIFigure, 'state');
            app.ConnectButton.ValueChangedFcn = createCallbackFcn(app, @ConnectButtonValueChanged, true);
            app.ConnectButton.Text = 'Connect';
            app.ConnectButton.Position = [59 265 100 22];

            % Create EditField_2
            app.EditField_2 = uieditfield(app.UIFigure, 'text');
            app.EditField_2.ValueChangedFcn = createCallbackFcn(app, @EditField_2ValueChanged, true);
            app.EditField_2.Editable = 'off';
            app.EditField_2.Position = [171 235 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Pump_controller_v2

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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