n:=5;

eFile:=Concatenation("DATA/ListFlips_dim", String(n));

U:=ReadAsFunction(eFile)();



nbTriang:=Length(U);
ListHyperm:=[];
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
        DiffVert:=Difference(Set(EXTadj), Set(eTrig));
        if Length(DiffVert)<>1 then
          Error("Adjacency scheme incorrect");
        fi;
        eVertOth:=DiffVert[1];
        eSol:=SolutionMat(eTrig, eVertOth);
        ePerm:=SortingPerm(eSol);
        eSolOrd:=Permuted(eSol, ePerm);
        if Position(ListHyperm, eSolOrd)=fail then
          Add(ListHyperm, eSolOrd);
        fi;
      od;
    fi;
  od;
od;

FileSave:=Concatenation("DATA/GeneralizedHypermetric_dim", String(n));
SaveDataToFile(FileSave, ListHyperm);
