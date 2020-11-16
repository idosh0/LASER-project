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
        ActiveTCNum
        SensorTime
        TCDataexp1
        FrontDio
        RearDio
        VideoTime
        VideoFrame
    end
    
    properties (Access = private)
        DataHederSize = 8;
    end
    
    methods
        function obj = LaserExperiment(number, path)
            obj.ExpNumber = number;
            obj.FolderPath = path;
        end
        
        function LoadSensorData(obj)
            filename = [obj.FolderPath '\' 'SensorData-' num2str(obj.ExpNumber,'%012.f') '.csv'];
            %% save header
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
            %% save reads
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
        function CheckClockValid(obj)
            
        end
        function GrayVideoParsing(obj)
            FileName = ['\BW-' num2str(obj.ExpNumber,'%012.f') '.AVI'];
            disp(' Dont worry be happy.... it will take some time    :o)  ....  ')
            LaserExperiment.aviread(fullfile(obj.FolderPath,FileName));
        end
        
        function plotTC(obj)
            All_TC = obj.TCData;
            RunTime=obj.SensorTime;
            RunTime=RunTime-RunTime(1);
            
            TC_def =diff(All_TC);
            
            figure;
            plot( RunTime, All_TC(:,1:5));
            xlabel('time[sec]');
            ylabel('Temperator[c]');
            grid on ;
            figure;
            plot( RunTime(1:end-1), TC_def(:,1:5));
            
            
            n=10 ;
            end_line=size(RunTime,1) ;
            time_pos= round((end_line/ n))-1;
            
            %don't forget to delete !!!
            obj. ActiveTCNum=5 ;
            
            distance=15 ;
            x_dis=0: distance: distance*obj. ActiveTCNum-1 ;
            figure;
            for s=1: n
                x_position(s,:)=All_TC(time_pos*s,1:5);
                subplot(10,1,s)
                plot( x_dis,x_position(s,:));
            end
        end
    end
    
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

