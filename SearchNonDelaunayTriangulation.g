n:=4;
GRPtriv:=Group([-IdentityMat(n)]);
TheBasis:=InvariantFormDutourVersion(GeneratorsOfGroup(GRPtriv));
eCase:=rec(Basis:=TheBasis);

ListLtype:=VOR_LTYPE_GetPrimitiveLtype(n);

eLtype:=ListLtype[2].Ltype;
Print("We have eLtype\n");

ListTrig:=TRIG_GetTriangulationFromLtype(eLtype);
Print("We have ListTrig\n");


RecPeriodicTriang:=TRIG_GetAdjacencyInformationOfTriangulation(ListTrig);
Print("We have RecPeriodicTriang\n");
eCheckKnown:=TRIG_TestDelaunayNessOfPeriodicTriangulation(RecPeriodicTriang);
GramMat:=eCheckKnown.GramMat;
LFC:=DelaunayComputationStandardFunctions(GramMat);
#DelCO:=LFC.GetDelaunayDescription();
DelCO:=LFC.GetDelaunayDescriptionSmallerGroup(GRPtriv);
RecIneq:=WriteFaceInequalities(DelCO, eCase);
ListIneq:=RecIneq.ListInequalities;
Print(NullMat(5));

while(true)
do
  ListPairSwitch:=TRIG_GetRandomAntisymmetricPair(RecPeriodicTriang);
  Print("ListPairSwitch=", ListPairSwitch, "\n");
  #
  RecPeriodicTriang:=TRIG_DoFlippingTriangulation(RecPeriodicTriang, ListPairSwitch);
  #
  eCheck:=TRIG_TestDelaunayNessOfPeriodicTriangulation(RecPeriodicTriang);
  if eCheck.Answer=false then
    Print("We found the sought tesselation");
    Print("Please celebrate");
    Print(NullMat(5));
  fi;
od;
