GramMat:=LatticeDn(5).TheGram;

LFC:=DelaunayComputationStandardFunctions(GramMat);

ListEXT:=List(LFC.GetDelaunayDescription(), x->x.EXT);

EXT16:=First(ListEXT, x->Length(x)=16);
GRP16:=LinPolytope_Automorphism(EXT16);

L_ListTrig:=GetAllTriangulations(EXT16, GRP16);
Print("|L_ListTrig|=", Length(L_ListTrig), "\n");

RecTransClass:=LFC.GetAllTranslationClassesDelaunay();
DelCO:=LFC.GetDelaunayDescription();
EXTspec:=EXT16;
L_ListTrigSpec:=L_ListTrig;
#L_ListTrigSpec:=L_ListTrig;

ListCases:=TRIG_CentralTriangulationDelaunay(RecTransClass, DelCO, EXTspec, L_ListTrigSpec);
