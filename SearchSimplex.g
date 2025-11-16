ListDelaunay:=ReadAsFunction("DELAUNAY/Delaunay_Dimension5")();

ListSize:=List(ListDelaunay, Length);
ePerm:=SortingPerm(ListSize);
ListDelaunayOrd:=Permuted(ListDelaunay, ePerm);


FileSave:="DATA/ListCases";
#RemoveFileIfExist(FileSave);
if IsExistingFilePlusTouch(FileSave) then
  ListCases:=ReadAsFunction(FileSave)();
else
  ListCases:=[];
  nbDelaunay:=Length(ListDelaunay);
  for iDelaunay in [1..nbDelaunay]
  do
    Print("iDelaunay=", iDelaunay, " / ", nbDelaunay, "\n");
    eDelaunay:=ListDelaunay[iDelaunay];
    len:=Length(eDelaunay);
    GRP:=LinPolytope_Automorphism(eDelaunay);
    eIso:=Isobarycenter(eDelaunay);
    ListSets:=[];
    IsCorrectSimplex:=function(eSet)
      local ListVect, eTest, ListExpr, ListIdx, eVert1, eVert2;
      if IsCentrallySymmetric(eDelaunay)=false then
        return true;
      fi;
      ListVect:=Concatenation(eDelaunay{eSet}, [-eIso]);
      eTest:=SearchPositiveRelationSimple(ListVect);
      if eTest=false then
        return true;
      fi;
      ListExpr:=eTest{[1..Length(eSet)]};
      ListIdx:=Filtered([1..Length(eSet)], x->ListExpr[x]<>0);
      eVert1:=eSet[ListIdx[1]];
      eVert2:=eSet[ListIdx[2]];
      if 2*eIso=eDelaunay[eVert1] + eDelaunay[eVert2] then
        return true;
      fi;
      return false;
    end;
    Meth1:=function()
      ListSets:=[];
      for eSet in Combinations([1..len], 6)
      do
        EXTred:=eDelaunay{eSet};
        if AbsInt(DeterminantMat(EXTred))>2 then
          if IsCorrectSimplex(eSet) then
            Add(ListSets, eSet);
          fi;
        fi;
      od;
      for eO in ListSets
      do
        eCase:=rec(eDelaunay:=eDelaunay, eSet:=eO[1]);
        Add(ListCases, eCase);
      od;
    end;
    Meth2:=function()
      O:=Orbits(GRP, Combinations([1..len],6), OnSets);
      for eO in O
      do
        eSet:=eO[1];
        EXTred:=eDelaunay{eSet};
        if AbsInt(DeterminantMat(EXTred))>2 then
          if IsCorrectSimplex(eSet) then
            eCase:=rec(eDelaunay:=eDelaunay, eSet:=eSet);
            Add(ListCases, eCase);
          fi;
        fi;
      od;
    end;
#    Meth1();
    Meth2();
  od;
  SaveDataToFilePlusTouch(FileSave, ListCases);
fi;
Print("|ListCases|=", Length(ListCases), "\n");

FileOut:="ListCases";
RemoveFileIfExist(FileOut);
output:=OutputTextFile(FileOut, true);
nbCase:=Length(ListCases);
for iCase in [1..nbCase]
do
  eCase:=ListCases[iCase];
  AppendTo(output, "iCase=", iCase, " / ", nbCase, "\n");
  GRP:=LinPolytope_Automorphism(eCase.eDelaunay);
  IsCent:=IsCentrallySymmetric(eCase.eDelaunay);
  ListFacSets:=DualDescriptionSets(eCase.eDelaunay);
  AppendTo(output, "eDelaunay |GRP|=", Order(GRP), " |V|=", Length(eCase.eDelaunay), " IsCent=", IsCent, "\n");
  AppendTo(output, "facsize=", List(ListFacSets, Length), "\n");
  WriteMatrix(output, eCase.eDelaunay);
  #
  eSimplex:=eCase.eDelaunay{eCase.eSet};
  eDet:=AbsInt(DeterminantMat(eSimplex));
  AppendTo(output, "Embedded simplex, det=", eDet, "\n");
  WriteMatrix(output, eSimplex);
  #
  AppendTo(output, "\n\n");
od;
CloseStream(output);

eCase:=ListCases[1];
eDelaunay:=eCase.eDelaunay;

TheFunc:=TestRealizabilityDelaunay(eDelaunay).TheFunc;
GramMat:=InfDel_GetQuadForm(TheFunc);
LFC:=DelaunayComputationStandardFunctions(GramMat);
ListEXT:=List(LFC.GetDelaunayDescription(), x->x.EXT);
EXT12:=First(ListEXT, x->Length(x)=12);

GRP12:=LinPolytope_Automorphism(EXT12);
L_ListTrig:=GetAllTriangulations(EXT12, GRP12);

#eIso:=Isobarycenter(EXT12);
#eList:=List(EXT12, x->Position(EXT12, 2*eIso-x));
#GRPanti:=Group([PermList(eList)]);


#L_ListTrigB:=Filtered(L_ListTrig, x->IsTriangulationInvariant(x, GRPanti));
ListTrigAdmi:=[];
for ListTrig in L_ListTrig
do
  ListVol:=GetVolumesOfTriangulation(EXT12, ListTrig);
  if Position(ListVol, 3)<>fail then
    Add(ListTrigAdmi, ListTrig);
  fi;
od;

RecTransClass:=LFC.GetAllTranslationClassesDelaunay();
DelCO:=LFC.GetDelaunayDescription();
EXTspec:=EXT12;
L_ListTrigSpec:=ListTrigAdmi;
#L_ListTrigSpec:=L_ListTrig;

ListCases:=TRIG_CentralTriangulationDelaunay(RecTransClass, DelCO, EXTspec, L_ListTrigSpec);
