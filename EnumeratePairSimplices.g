n:=5;
MaxVal:=4;

TheResult:=TRIG_EnumeratePossiblePairsSimplicesVolumeOne(n, MaxVal);

ListOrbitMatch:=TheResult.ListOrbitSimplices[1].ListOrbitPoint[1].ListOrbitMatch;

ListHYP:=List(ListOrbitMatch, x->x.eHyp);
Print("HYP=\n");
PrintArray(ListHYP);

ListPairs:=[];
eSimp:=TheResult.ListOrbitSimplices[1].eSimp;
for eOrbit in ListOrbitMatch
do
  nSimp:=eSimp*eOrbit.eBigMat;
  ePair:=[eSimp, nSimp];
  Add(ListPairs, ePair);
od;


