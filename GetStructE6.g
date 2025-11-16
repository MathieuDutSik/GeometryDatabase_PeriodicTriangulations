#TheGramMat:=IdentityMat(5);
#TheGramMat:=ClassicalSporadicLattices("E6");
#TheGramMat:=ClassicalSporadicLattices("E7");
TheGramMat:=ClassicalSporadicLattices("E8");

LFC:=DelaunayComputationStandardFunctions(TheGramMat);

eRec:=LFC.GetFreeVectors();

#ListBelt:=eRec.GetBelt_Equivariant();
#EXTvoronoi:=LFC.GetVoronoiVertices();
#GRP:=LinPolytope_Automorphism(EXTvoronoi);
#FAC:=DualDescription(EXTvoronoi);
#TheResult:=CreateK_skeletton(GRP, EXTvoronoi, FAC);



TheInfo:=eRec.ComputeGarber_Gavrilyuk_Magazinov_Condition();



