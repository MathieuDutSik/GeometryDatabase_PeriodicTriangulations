n:=5;

eFile:=Concatenation("DATA/ListFlips_dim", String(n));
U:=ReadAsFunction(eFile)();

FileSave:=Concatenation("DATA/ListDelaunayCentSymm_dim", String(n));
ListInfo:=ReadAsFunction(FileSave)();

FileDATA_Publi:=Concatenation("TEX/ListOfTriangulation_", String(n));
ListTrigPubli:=ReadAsFunction(FileDATA_Publi)();


siz:=2;
ListRangeIndices:=[];
for i in [1..n]
do
  eRec:=rec(eMin:=0, eMax:=siz);
  Add(ListRangeIndices, eRec);
od;



nbTriang:=Length(U);
ListTest:=[];
iTriang:=21;

  eListTrig:=U[iTriang];
  pos:=Position(ListTrigPubli, eListTrig);
  Print("iTriang=", iTriang, "/", nbTriang, " pos=", pos, "\n");
    RecPeriodicTriang:=TRIG_GetAdjacencyInformationOfTriangulation(eListTrig);
    TheTest:=TRIG_PartialTestRegularity(RecPeriodicTriang, ListRangeIndices);
    Add(ListTest, TheTest);
    if TheTest.Answer=false then
      Print("Victory\n");
      Print(NullMat(5));
    fi;
