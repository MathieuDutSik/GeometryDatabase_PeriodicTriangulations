eTrig1:=[
[1,0,0,0],
[1,1,0,0],
[1,0,1,0],
[1,0,0,1]];

nVert:=eTrig1[1] + eTrig1[2] - eTrig1[3];
eTrig2:=[eTrig1[1], eTrig1[2], nVert, eTrig1[4]];

eReply:=TRIG_TestFacednessPairSimplices(eTrig1, eTrig2);
