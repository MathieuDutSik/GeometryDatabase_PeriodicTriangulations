EXT:=ClassicalExtremeDelaunayPolytopes("G6");




#TriangulationRecursiveDelaunay:=function(EXT)


GetPeriodic_Strateg1:=function()
  local ListSimpInfo, ListSimplices, EXTred, EXT1, EXT2, eRec, SumVol;
  ListSimpInfo:=GetTriangulationFromLRS(EXT);
  ListSimplices:=[];
  SumVol:=0;
  for eRec in ListSimpInfo
  do
    EXT1:=EXT{eRec.LV};
    EXTred:=List(EXT1, x->x{[2..7]});
    EXT2:=List(EXTred, x->Concatenation([1], -x));
    Add(ListSimplices, EXT1);
    Add(ListSimplices, EXT2);
    SumVol:=SumVol + 2*eRec.det;
  od;
  Print("SumVol=", SumVol, "\n");
  Print("|ListSimplices|=", Length(ListSimplices), "\n");
  Print("|ListSimpInfo|=", Length(ListSimpInfo), "\n");
  return ListSimplices;
end;

GetStructureFromSimplices:=function(ListSimplices)
  local ListVertices, eDim, eSimplex, eSimplexRed, i, j, eDiff, SetVertices, ListSets, eList, eSet, pos;
  ListVertices:=[];
  eDim:=Length(ListSimplices[1]);
  for eSimplex in ListSimplices
  do
    eSimplexRed:=List(eSimplex, x->x{[2..eDim]});
    for i in [1..eDim]
    do
      for j in [1..eDim]
      do
        if i<>j then
          eDiff:=eSimplexRed[i] - eSimplexRed[j];
          Add(ListVertices, eDiff);
        fi;
      od;
    od;
  od;
  SetVertices:=Set(ListVertices);
  Print("|SetVertices|=", Length(SetVertices), "\n");
  #
  ListSets:=[];
  for eSimplex in ListSimplices
  do
    eSimplexRed:=List(eSimplex, x->x{[2..eDim]});
    for i in [1..eDim]
    do
      eList:=[];
      for j in [1..eDim]
      do
        if i<>j then
          eDiff:=eSimplexRed[i] - eSimplexRed[j];
          pos:=Position(SetVertices, eDiff);
          Add(eList, pos);
        fi;
      od;
      eSet:=Set(eList);
      Add(ListSets, eSet);
    od;
  od;
  Print("|ListSets|=", Length(ListSets), "\n");
  #
  return rec(SetVertices:=SetVertices, ListSets:=ListSets);
end;




ListSimplices:=GetPeriodic_Strateg1();
TheCompl:=GetStructureFromSimplices(ListSimplices);
