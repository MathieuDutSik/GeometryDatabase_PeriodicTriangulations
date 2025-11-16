n:=5;

eFile:=Concatenation("DATA/ListFlips_dim", String(n));

U:=ReadAsFunction(eFile)();

nbTriang:=Length(U);
ListInfo:=[];
for iTriang in [1..nbTriang]
do
  eListTrig:=U[iTriang];
  Print("iTriang=", iTriang, "/", nbTriang, "\n");
  RecPeriodicTriang:=TRIG_GetAdjacencyInformationOfTriangulation(eListTrig);
  RecDelaunay:=TRIG_TestDelaunayNessOfPeriodicTriangulation(RecPeriodicTriang);
  testCent:=TRIG_CheckCentralSymmetry(eListTrig);
  eInfo:=rec(IsDelaunay:=RecDelaunay.Answer, testCent:=testCent);
  Add(ListInfo, eInfo);
od;

FileSave:=Concatenation("DATA/ListDelaunayCentSymm_dim", String(n));
SaveDataToFile(FileSave, ListInfo);
