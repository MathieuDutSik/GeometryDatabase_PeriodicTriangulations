n:=4;


eSimp:=NullMat(n+1,n+1);
for i in [1..n+1]
do
  eSimp[i][1]:=1;
  eSimp[i][i]:=1;
od;

ListRecAnswer:=[];
for m in [1..20]
do
  NewVert:= - eSimp[1] + eSimp[2] + (m+1)*eSimp[3] - m*eSimp[4];
  NewSimp:=Concatenation([NewVert], eSimp{[2..n+1]});
  eTest:=TRIG_TestIntersectionPairSimplices(eSimp, NewSimp);
  Print("m=", m, " test=", eTest.Answer, "\n");
  eRecAnswer:=rec(m:=m, Answer:=eTest.Answer);
  Add(ListRecAnswer, eRecAnswer);
od;
