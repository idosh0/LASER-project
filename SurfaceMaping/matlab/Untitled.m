a = arduino('COM3');
%%
S1 = mySteeper(a,'D12','D10',0.02,0.5);
%%
S1.Move(250,7.5,1);
