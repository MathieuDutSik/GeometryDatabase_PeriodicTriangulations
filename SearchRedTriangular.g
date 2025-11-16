# See 3.4 in Erdahl, Ryshkov "The Empty Sphere II"
#
# A modification of it is given in Alexeev paper on degeneration
# of Abelian varieties Example 5.13.1 (reported by Pacos Santos)



n:=4;
rnk:=9;

FileSave:="DATA_TEMP/RedTriangular";
#RemoveFileIfExist(FileSave);
if IsExistingFilePlusTouch(FileSave)=false then
  #
  eFile:=Concatenation("DATA_TEMP/List", String(n), "_rnk", String(rnk));
  eRecEnum:=ReadAsFunction(eFile)();
  #
  ListGram:=[];
  ListCollLen:=[];
  for eCase in eRecEnum.ListConfiguration
  do
    GramMat:=Sum(eCase);
    Add(ListGram, GramMat);
    LFC:=DelaunayComputationStandardFunctions(GramMat);
    ListDel:=LFC.GetAllTranslationClassesDelaunay().TotalListDelaunay;
    CollLen:=Collected(List(ListDel, Length));
    Add(ListCollLen, CollLen);
  od;
  #
  TheSearch:=[ [ 5, 18 ], [ 6, 2 ] ];
  #
  pos:=Position(ListCollLen, TheSearch);
  TheGram:=ListGram[pos];
  eCase:=eRecEnum.ListConfiguration[pos];
  LFC:=DelaunayComputationStandardFunctions(GramMat);
  ListDel:=LFC.GetAllTranslationClassesDelaunay().TotalListDelaunay;
  #
  ListDel5:=Filtered(ListDel, x->Length(x)=5);
  ListDel6:=Filtered(ListDel, x->Length(x)=6);
  #
  ListListTriang:=[];
  ListMultiple:=[];
  for eDel in ListDel6
  do
    ListTriang:=GetAllTriangulations(eDel);
    Add(ListListTriang, ListTriang);
    Add(ListMultiple, [1..Length(ListTriang)]);
  od;
  #
  OneDel6:=ListDel6[1];
  ListVector:=List(eCase, ReverseProduct);
  OneBasis:=RowReduction(ListVector).EXT;
  ListRankOneMat:=List(OneBasis, x->TransposedMat([x])*[x]);
  TheSumMat:=Sum(ListRankOneMat);
  #
  LFC:=DelaunayComputationStandardFunctions(TheSumMat);
  TheCube:=LFC.GetAllTranslationClassesDelaunay().TotalListDelaunay[1];
  ListEmbedding:=[];
  for eVert in TheCube
  do
    eDiff:=eVert - OneDel6[1];
    TheImage:=List(OneDel6, x->x+eDiff);
    if IsSubset(Set(TheCube), Set(TheImage)) then
      eSet:=Set(List(TheImage, x->Position(TheCube, x)));
      Add(ListEmbedding, rec(TheImage:=TheImage, eSet:=eSet));
    fi;
  od;
  StandardCube:=List(BuildSet(4, [0,1]), x->Concatenation([1], x));
  eEquiv:=LinPolytope_Isomorphism(TheCube, StandardCube);
  eSetImg:=OnSets(ListEmbedding[1].eSet, eEquiv);
  TheMat:=FindTransformation(TheCube, StandardCube, eEquiv);
  TheDel6_spec:=StandardCube{eSetImg};
  #
  ListInfos:=[];
  for eVect in BuildSetMultiple(ListMultiple)
  do
    NewListTrig:=[];
    for iDel in [1..Length(ListDel6)]
    do
      for eSet in ListListTriang[iDel][eVect[iDel]]
      do
        Add(NewListTrig, ListDel6[iDel]{eSet});
      od;
    od;
    Append(NewListTrig, ListDel5);
    #
    eCheckCentSym:=TRIG_CheckCentralSymmetry(NewListTrig);
    eRecPer:=TRIG_GetAdjacencyInformationOfTriangulation(NewListTrig);
    CheckDel:=TRIG_TestDelaunayNessOfPeriodicTriangulation(eRecPer);
    NewRec:=rec(ListTrig:=NewListTrig,
                eRecPer:=eRecPer,
                TheGram:=TheGram,
                eCase:=eCase, 
                ListVector:=ListVector, 
                ListDel6:=ListDel6, 
                ListDel5:=ListDel5, 
                ListEmbedding:=ListEmbedding, 
                TheDel6_spec:=TheDel6_spec,
                CheckDel:=CheckDel);
    Add(ListInfos, NewRec);
  od;
  TheNonDelaunay:=First(ListInfos, x->x.CheckDel.Answer=false);
  SaveDataToFilePlusTouch(FileSave, TheNonDelaunay);
else
  TheNonDelaunay:=ReadAsFunction(FileSave)();
fi;

RecPeriodicTriang:=TRIG_GetAdjacencyInformationOfTriangulation(TheNonDelaunay.ListTrig);


TheGram:=TheNonDelaunay.TheGram;


DoCtype:=function()
  local TheRec;
  TheRec:=CTYP_GetLinearEqualities(TheGram);
  Print(NullMat(5));
end;

#DoCtype();



GRP:=TRIG_GetSymmetryGroupTriangulation(TheNonDelaunay.ListTrig).eGRP;
ListGenS3_S3:=Concatenation(GeneratorsOfGroup(SymmetricGroup([1..3])), GeneratorsOfGroup(SymmetricGroup([4..6])));
GRP_S3_S3:=Group(ListGenS3_S3);
ListVector:=TheNonDelaunay.ListVector;
ListVectorTot:=Concatenation(ListVector, -ListVector);
ListGensGRP:=[];
for eGen in GeneratorsOfGroup(GRP)
do
  eList:=List(ListVectorTot, x->Position(ListVectorTot, x*TransposedMat(eGen)));
  Add(ListGensGRP, PermList(eList));
od;
GRPperm:=Group(ListGensGRP);
CJ:=ConjugacyClassesSubgroups(GRPperm);
ListCorrect:=[];
for eCJ in CJ
do
  eRepr:=Representative(eCJ);
  if IsomorphismGroups(eRepr, GRP_S3_S3)<>fail then
    Add(ListCorrect, eRepr);
  fi;
od;

CJ2:=ConjugacyClasses(GRP);
ListElt:=[];
ListSpaces:=[];
ListKernel:=[];
ListVectorSet:=[];
ListSHV:=[];
ListNorm:=[];
for eCJ in CJ2
do
  eRepr:=Representative(eCJ);
  ePol:=CharacteristicPolynomial(eRepr);
  eCoeffChar:=CoefficientsOfUnivariatePolynomial(ePol);
  if eCoeffChar=[ 1, -1, 0, -1, 1 ] then
    for eElt in eCJ
    do
      Add(ListElt, eElt);
      eSpace:=RowReduction(eElt - IdentityMat(4)).EXT;
      eKernel:=NullspaceMat(eElt - IdentityMat(4));
      eSet:=Filtered(ListVector, x->SolutionMat(eKernel, x)<>fail);
      eG:=eSpace*TheGram*TransposedMat(eSpace);
      SHV:=ShortestVectorDutourVersion(eG);
      SHVn:=Set(SHV*eSpace);
      eNorm:=SHVn[1]*TheGram*SHVn[1];
      Add(ListSHV, SHVn);
      Add(ListNorm, eNorm);
      Add(ListSpaces, eSpace);
      Add(ListVectorSet, eSet);
      Add(ListKernel, eKernel);
    od;
  fi;
od;
SHVtot:=ShortestVectorDutourVersion(TheGram);
eNorm:=SHVtot[1]*TheGram*SHVtot[1];

SHVb:=Concatenation(ListSHV[1], ListSHV[3]);

eBasis:=Concatenation(ListSHV[1]{[1..2]}, ListSHV[2]{[1..2]});
RelSet:=Concatenation([ListWithIdenticalEntries(4,0)], eBasis);




DoTest:=function(ListVal)
  local eVal, ListRangeIndices, i, TheReply, ListVertRed, ListLine, eVect, pos, hVal;
  ListRangeIndices:=[];
  for i in [1..n]
  do
    eVal:=ListVal[i];
    Add(ListRangeIndices, rec(eMin:=-eVal, eMax:=eVal));
  od;
  Print("ListRangeIndices=", ListRangeIndices, "\n");
  TheReply:=TRIG_PartialTestRegularity(RecPeriodicTriang, ListRangeIndices);
  Print("Answer=", TheReply.reason, "\n");
  ListVertRed:=List(TheReply.RecInfo.SetVert, x->x{[2..5]});
  ListLine:=[];
  for eVect in SHVb
  do
    pos:=Position(ListVertRed, eVect);
    if pos<>fail then
      eLine:=Concatenation([1], eVect, [TheReply.TheHeightFunction[pos]]);
      Add(ListLine, eLine);
    fi;
  od;
  TheReply.ListLine:=ListLine;
  return TheReply;
end;


#TheReply:=DoTest([2,2,2,2]);
TheReply:=DoTest([2,2,2,3]);
