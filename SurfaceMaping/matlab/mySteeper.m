classdef mySteeper < handle
    %mySteeper this class handle the stepper interface with the arduino
    %   properties:
    %   arduino - arduino object
    %   StepPin - the pin that connected to the PUL in the driver ('D11')
    %   DirPin - the pin that connect to the DIR int the driver ('D11')
    %   XperStep - the distance that the motor travel per one pin (in mm)
    %   Tpulse -  the pulse width (in sec)
    
    properties
       a
       StepPin
       DirPin
       XperStep
       tPulse
    end
    
    methods
        function obj = mySteeper(a,StepPin,DirPin,XperStep,tPulse)
            %bulder mathod for my step
            %   a - arduino object
            %   StepPin - the pin that connected to the PUL in the driver ('D11')
            %   DirPin - the pin that connect to the DIR int the driver ('D11')
            %   XperStep - the distance that the motor travel per one pin
            obj.a =  a;
            obj.DirPin = DirPin;
            obj.StepPin = StepPin;
            obj.XperStep = XperStep;
            obj.tPulse = tPulse;
        end
        
        function Move(obj,X,V,D)
            %S-struct with tho motor data
            %X - distance
            %V - velocity
            %D - dirction (1 -forword, 0 - backword)
            
            writeDigitalPin(obj.a, obj.DirPin, D);
            N = X / obj.XperStep;
%             deltaT = X /(N*V) - obj.tPulse;
            deltaT = X /(2*(N*V));
            
            for i = 1:N
              writeDigitalPin(obj.a, obj.StepPin, 1);
              pause(deltaT);
              writeDigitalPin(obj.a, obj.StepPin, 0);
              pause(deltaT);
            end
        end
    end
end

