clc; clear; close all;
exp1 = LaserExperiment(061120115023,'G:\.shortcut-targets-by-id\1EvfKa8tBidzgjdNARKNImsu2yD8J9I5j\laser defence plasan\exp\exp_system_first_run\061120115023');
exp1.LoadSensorData;
exp1.LoadVideoData;
exp1.SetTCParam(15, 5);
exp1.plotTCPmovieOverTime ;
exp1.plotTC;
exp1.plotTCtimediff;
exp1.plotTCProfileOverTime;
exp1.CheckClockValidSensor;
exp1.CheckClockValidVideo;


