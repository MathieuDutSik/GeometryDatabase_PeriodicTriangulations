n:=5;

eFile:=Concatenation("DATA/ListFlips_dim", String(n));

U:=ReadAsFunction(eFile)();


FileDATA_Publi:=Concatenation("TEX/ListOfTriangulation_", String(n));
ListTrigPubli:=ReadAsFunction(FileDATA_Publi)();


nbTriang:=Length(U);
ListHyperm:=[];
ListOtherInfo:=[];
for iTriang in [1..nbTriang]
do
  eListTrig:=U[iTriang];
  Print("iTriang=", iTriang, "/", nbTriang, "\n");
  RecPeriodicTriang:=TRIG_GetAdjacencyInformationOfTriangulation(eListTrig);
  nbTrig:=Length(eListTrig);
  for iTrig in [1..nbTrig]
  do
    eTrig:=eListTrig[iTrig];
    if AbsInt(DeterminantMat(eTrig))=1 then
      eInfo:=RecPeriodicTriang.ListSimplices_FormalDelaunay[iTrig];
      for eAdj in eInfo.Adjacencies
      do
        EXTadj:=eListTrig[eAdj.iDelaunay]*eAdj.eBigMat;
        DiffVert1:=Difference(Set(EXTadj), Set(eTrig));
        if Length(DiffVert1)<>1 then
          Error("Adjacency scheme incorrect 1");
        fi;
        eVertOth:=DiffVert1[1];
        DiffVert2:=Difference(Set(eTrig), Set(EXTadj));
        if Length(DiffVert2)<>1 then
          Error("Adjacency scheme incorrect 2");
        fi;
        eVertNative:=DiffVert2[1];
        pos:=Position(eTrig, eVertNative);
        eSol:=SolutionMat(eTrig, eVertOth);
        ePerm:=SortingPerm(eSol);
        eSolOrd:=Permuted(eSol, ePerm);
        posOrd:=OnPoints(pos, ePerm);
        ThePair:=rec(Hypermetric:=eSolOrd, pos:=posOrd);
        if Position(ListHyperm, ThePair)=fail then
          pos:=Position(ListTrigPubli, eListTrig);
          Print("Inserting ThePair=", ThePair, " from iTriang=", iTriang, " pos=", pos, "\n");
          Add(ListHyperm, ThePair);
          Add(ListOtherInfo, [ThePair, iTriang, pos]);
        fi;
      od;
    fi;
  od;
od;

FileSave:=Concatenation("DATA/GeneralizedHypermetric_dim", String(n));
SaveDataToFile(FileSave, ListHyperm);
