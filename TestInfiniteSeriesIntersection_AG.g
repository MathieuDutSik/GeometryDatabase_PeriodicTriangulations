n:=4;



ptO:=[0,0,0,0,0];
ptX:=[-1,0,0,0,0];
ptA:=[0,1,0,0,0];
ptB:=[0,0,1,0,0];
ptC:=[0,0,0,1,0];
ptD:=[0,0,0,0,1];


eSimp1:=List([ptO, ptA, ptB, ptC, ptD, ptX], x->Concatenation([1], x));

ListResult:=[];
for n in [0..20]
do
  ptXprime:=[1,1,1,1,n+1];
  eSimp2:=List([ptO, ptA, ptB, ptC, ptD, ptXprime], x->Concatenation([1], x));
  eTest:=TRIG_TestIntersectionPairSimplices(eSimp1, eSimp2);
  Print("n=", n, " test=", eTest.Answer, "\n");
  Add(ListResult, eTest);
od;

