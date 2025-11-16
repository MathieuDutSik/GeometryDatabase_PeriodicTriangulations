n:=5;

eFile:=Concatenation("DATA/ListFlips_dim", String(n));
U:=ReadAsFunction(eFile)();

FileSave:=Concatenation("DATA/ListDelaunayCentSymm_dim", String(n));
ListInfo:=ReadAsFunction(FileSave)();

siz:=2;
ListRangeIndices:=[];
for i in [1..n]
do
  eRec:=rec(eMin:=0, eMax:=siz);
  Add(ListRangeIndices, eRec);
od;



nbTriang:=Length(U);
ListTest:=[];
for iTriang in [1..nbTriang]
do
  eListTrig:=U[iTriang];
  Print("iTriang=", iTriang, "/", nbTriang, "\n");
  eInfo:=ListInfo[iTriang];
  if eInfo.IsDelaunay=false then
    RecPeriodicTriang:=TRIG_GetAdjacencyInformationOfTriangulation(eListTrig);
    TheTest:=TRIG_PartialTestRegularity(RecPeriodicTriang, ListRangeIndices);
    Add(ListTest, TheTest);
    if TheTest.Answer=false then
      Print("Victory\n");
      Print(NullMat(5));
    fi;
  fi;
od;
