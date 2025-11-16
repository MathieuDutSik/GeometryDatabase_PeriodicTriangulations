n:=4;
U:=ReadAsFunction("ForDEBUG")();

RecPeriodicTriang:=U.RecPeriodicTriang;
TheCheck:=TRIG_TestDelaunayNessOfPeriodicTriangulation(RecPeriodicTriang);


eRepartitioning:=ReadAsFunction("DEBUG_eRepartitioning")();

LLtrig:=GetAllTriangulations(eRepartitioning);




LL_ListCont1:=[];
LL_ListCont2:=[];
LL_Vert:=[];
LL_Simp:=[];
ListProblematicSimplices:=[];
for eLtrig in LLtrig
do
  L_ListCont1:=[];
  L_ListCont2:=[];
  L_Vert:=[];
  L_Simp:=[];
  for eTrig in eLtrig
  do
    eSimp:=eRepartitioning{eTrig};
    ListCont1:=TRIG_FindTriangles(TheCheck.RecTransClass.TotalListDelaunay, eSimp);
    ListCont2:=TRIG_FindTriangles(RecPeriodicTriang.ListTrig, eSimp);
    if Length(ListCont2)>0 then
      Add(ListProblematicSimplices, ListCont2[1].eTrig);
    fi;
    Add(L_ListCont1, ListCont1);
    Add(L_ListCont2, ListCont2);
    eVert:=Difference([1..Length(eRepartitioning)], eTrig)[1];
    Add(L_Vert, eVert);
    Add(L_Simp, eSimp);
  od;
  Add(LL_ListCont1, L_ListCont1);
  Add(LL_ListCont2, L_ListCont2);
  Add(LL_Vert, L_Vert);
  Add(LL_Simp, L_Simp);
od;

LFC:=DelaunayComputationStandardFunctions(TheCheck.GramMat);

GRP_big:=ArithmeticAutomorphismGroup([TheCheck.GramMat]); 
GRP_sma:=Group([IdentityMat(n)]);
InvariantBasis:=__ExtractInvariantZBasisShortVectorNoGroup(TheCheck.GramMat);


DelCO_big:=LFC.GetDelaunayDescription();
DelCO_sma:=SymmetryBreakingDelaunayDecomposition(DelCO_big, GRP_big, GRP_sma, InvariantBasis);

eCase:=GetStandardIntegralVoronoiSpace(n);
eRecIneq:=WriteFaceInequalities(DelCO_sma, eCase);

TheDim:=Length(eCase.Basis);
ListIneq_redund:=List(eRecIneq.ListInequalities, x->x{[2..TheDim+1]});
EXT:=DualDescription(ListIneq_redund);
ListIneq:=DualDescription(EXT);


ListCasesFound:=[];
for i in [1..10]
do
  eDiff:=Difference([1..10], [i]);
  eSumVect:=ListWithIdenticalEntries(10, 0);
  for eIdx in eDiff
  do
    eSumVect:=eSumVect + EXT[eIdx];
  od;
  eGramMatFace:=NullMat(n,n);
  for iDim in [1..10]
  do
    eGramMatFace:=eGramMatFace + eSumVect[iDim]*eCase.Basis[iDim];
  od;
  LFCface:=DelaunayComputationStandardFunctions(eGramMatFace);
  RecTransClass:=LFCface.GetAllTranslationClassesDelaunay();
  nbMatch:=0;
  for eSimp in ListProblematicSimplices
  do
    ListCont:=TRIG_FindTriangles(RecTransClass.TotalListDelaunay, eSimp);
    if Length(ListCont)=0 then
      nbMatch:=nbMatch+1;
    fi;
  od;
  if nbMatch=2 then
    eCase:=rec(eGramMatFace:=eGramMatFace, LFCface:=LFCface);
    Add(ListCasesFound, eCase);
  fi;
od;


TheSpace:=LinearDeterminedByInequalities(ListIneq);






#Collection_ListTrig:=TRIG_ComputeAllFlipping(RecPeriodicTriang);

