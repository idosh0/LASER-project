classdef LaserExperiment < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        ExpNumber
        FolderPath
        Date
        Time
        Operator
        TargetMat
        SpecimenNum
        LaserVoltage
        Duration
        BeamDiameter
        TCActiveTCNum
        TCData
        TCspacing
        
        SensorTime
        FrontDio
        RearDio
        
        VideoTime
        VideoFrame
        
    end
    
    properties (Access = private)
        DataHederSize = 8;
    end
    
 
    %% ===================handle data loading======================
    methods %handle data loading
        function obj = LaserExperiment(number, path)
            obj.ExpNumber = number;
            obj.FolderPath = path;
        end
        
        
        function LoadSensorData(obj)
            filename = [obj.FolderPath '\' 'SensorData-' num2str(obj.ExpNumber,'%012.f') '.csv'];
            % save header
            RangeStr = ['A1:B' num2str(obj.DataHederSize)];
            HeaderData = readcell(filename,'Range',RangeStr);
            obj.Date = HeaderData{1,2};
            obj.Time = HeaderData{2,2};
            obj.Operator = HeaderData{3,2};
            obj.TargetMat = HeaderData{4,2};
            obj.SpecimenNum = HeaderData{5,2};
            obj.LaserVoltage = HeaderData{6,2};
            obj.Duration = HeaderData{7,2};
            obj.BeamDiameter = HeaderData{8,2};
            % save reads
            RangeStr = ['A' num2str(obj.DataHederSize+2)];
            ReadsData = readmatrix(filename,'Range',RangeStr);
            obj.SensorTime = ReadsData(:,1);
            obj.TCData =  ReadsData(:,2:9);
            obj.FrontDio =  ReadsData(:,10);
            obj.RearDio =  ReadsData(:,11);
            
        end
        function LoadVideoData(obj)
            filename = [obj.FolderPath '\' 'CamData-' num2str(obj.ExpNumber,'%012.f') '.csv'];
            RangeStr = 'A2';
            Videomat = readmatrix(filename,'Range',RangeStr);
            obj.VideoTime = Videomat(:,2);
            obj.VideoFrame = Videomat(:,1);
        end
    end
    
    %% ===================handle TC ploting======================
    methods
        function SetTCParam(obj, spacing, TCnumber)
            obj.TCActiveTCNum = TCnumber;
            obj.TCspacing = spacing;
        end
        function plotTC(obj)
            All_TC = obj.TCData;
            RunTime=obj.SensorTime;
            RunTime=RunTime-RunTime(1);
            figure('Name', 'all TC plot');
            plot( RunTime, All_TC(:,1:obj. TCActiveTCNum));
            xlabel('time[sec]');
            ylabel('Temperator[c]');
            grid on ;
            
        end
        function plotTCtimediff(obj)
            All_TC = obj.TCData;
            RunTime=obj.SensorTime;
            RunTime=RunTime-RunTime(1);
            figure;
            TC_def =diff(All_TC);
            figure;
            hold on ;
            plot( RunTime(1:end-1), TC_def(:,1:obj. TCActiveTCNum));
            grid on ;
            xlabel('t [sec]');
            ylabel('dT [0c]');
            
          
        end
        
        function plotTCProfileOverTime(obj)
            All_TC = obj.TCData;
            RunTime=obj.SensorTime;
            RunTime=RunTime-RunTime(1);
            n=5 ;
            end_line=size(RunTime,1) ;
            time_pos= round((end_line/ n))-1;
            distance=obj.TCspacing ;
            x_dis=0: distance: distance*obj.TCActiveTCNum-1 ;
            figure;
            for s=1: n
                x_position(s,:)=All_TC(time_pos*s,1:5);
                subplot(n,1,s)
                plot( x_dis,x_position(s,:));
                 hold on ; grid on ; xlabel('t [sec]');ylabel('T [0C]');
                legend_str{s} = ['t = ' num2str(RunTime(time_pos*s)) '[sec]'];
            end
            figure;
            plot(x_dis, x_position')
            opengl software
            legend(legend_str)
            opengl hardware
            hold on ; grid on ; xlabel('t [sec]');ylabel('T [0C]');
        end
        
         function plotTCPmovieOverTime(obj)
             
            All_TC = obj.TCData;%get the temperatore valiue
            RunTime=obj.SensorTime;%t axis
            RunTime=RunTime-RunTime(1);%start from 0 point
            %n=10 ;
            end_line=size(RunTime,1) ;
            %time_pos= round((end_line/ n))-1;
            distance=obj.TCspacing ;
            x_dis=0: distance: distance*obj.TCActiveTCNum-1 ;
            h = figure('Name','TCmovie');
            for s=1: end_line
                x_position(s,:)=All_TC(s,1:5);
               figure(h);
                plot(x_dis,x_position(s,:),'-o');
                hold on ;
                xlim([0 60]);ylim([0 350]);grid on ;xlabel('t [sec]');ylabel('T [0C]');
                pause(0.00005);
               
                hold off ;
                
            end
            figure;
            plot(x_dis, x_position)
        end
        
    end
    %% ===================handle video processing======================
    methods
        
        function GrayVideoParsing(obj)
            FileName = ['\BW-' num2str(obj.ExpNumber,'%012.f') '.AVI'];
            disp(' Dont worry be happy.... it will take some time    :o)  ....  ')
            LaserExperiment.aviread(fullfile(obj.FolderPath,FileName));
        end
        
    end
    %% ===================data validation functions======================
    methods
        function CheckClockValidSensor(obj)
            t = obj.SensorTime;
            t_diff_sensor = diff(t);
            figure('Name','SensorClockDiff');
            plot(t(1:end-1),t_diff_sensor);
            xlabel('t [sec]','Interpreter','tex')
            ylabel('^{dt}/_{dSample}')
            diff_mean = mean(t_diff_sensor);
            diff_std = std(t_diff_sensor);
            dim = [0.5,0.8,0.3,0.1];
            str ={['Clock diff mean =' num2str(diff_mean)], ['Clock diff std =' num2str(diff_std)], ['Average frequency =' num2str(1/diff_mean)]};
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
            
        end
        function CheckClockValidVideo(obj)
            t = obj.VideoTime;
            t_diff_sensor = diff(t);
            figure('Name','VideoClockDiff');
            plot(t(1:end-1),t_diff_sensor);
            xlabel('t [sec]','Interpreter','tex')
            ylabel('^{dt}/_{dSample}')
            diff_mean = mean(t_diff_sensor);
            diff_std = std(t_diff_sensor);
            dim = [0.5,0.8,0.3,0.1];
            str ={['clock diff mean =' num2str(diff_mean)], ['clock diff std =' num2str(diff_std)], ['Average frequency =' num2str(1/diff_mean)]};
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
        end
    end
    %% ===================class static methods======================
    methods(Static)
        function aviread(f)
            % Construct a multimedia reader object associated with file
            vidObj = VideoReader(f);
            % Create an axes
            currAxes = axes;
            i=1;
            % Read video frames until available
            bar = waitbar(0,'Please wait...');
            while hasFrame(vidObj)
                vidFrame = readFrame(vidObj);
                image(vidFrame, 'Parent', currAxes);
                colormap('Gray')
                currAxes.Visible = 'off';
                axis equal
                if i < 10
                    fig_num=['00' num2str(i)];
                elseif (i>10) & (i<99)
                    fig_num=['0' num2str(i)];
                elseif i>99
                    fig_num=num2str(i);
                end
                pause(1/vidObj.FrameRate);
                waitbar(i/vidObj.NumFrames,bar,num2str(i))
                imwrite(vidFrame,[f(1:end-4) '-' fig_num '.jpg'],'jpg');
                i=i+1;
            end
            
        end
    end
end

