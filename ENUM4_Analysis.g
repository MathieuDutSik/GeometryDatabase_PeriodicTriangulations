eFile:="DATA/ListTriangulation_dim4";
U:=ReadAsFunction(eFile)();

nbTriang:=Length(U);
ListInfo:=[];
for iTriang in [1..nbTriang]
do
  eListTrig:=U[iTriang].ListTrig;
  Print("iTriang=", iTriang, "/", nbTriang, "\n");
  eGRP:=TRIG_GetSymmetryGroupTriangulation(eListTrig).eGRP;
  RecPeriodicTriang:=TRIG_GetAdjacencyInformationOfTriangulation(eListTrig);
  RecDelaunay:=TRIG_TestDelaunayNessOfPeriodicTriangulation(RecPeriodicTriang);
  testCent:=TRIG_CheckCentralSymmetry(eListTrig);
  eInfo:=rec(IsDelaunay:=RecDelaunay.Answer, testCent:=testCent, eGRP:=eGRP);
  Add(ListInfo, eInfo);
od;
for iTriang in [1..nbTriang]
do
  eListTrig:=U[iTriang];
  eRec:=ListInfo[iTriang];
  Print("iTriang=", iTriang, "/", nbTriang, "\n");
  Print("  |eGRP|=", Order(eRec.eGRP), "\n");
  Print("  testDelaunay=", eRec.IsDelaunay, " testCent=", eRec.testCent, "\n");
od;
