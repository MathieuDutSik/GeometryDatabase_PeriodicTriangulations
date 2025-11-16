ePair:=ReadAsFunction("ForDEBUG_pair")();

eTrig1:=ePair[1];
eTrig2:=ePair[2];


FAC1:=DualDescription(eTrig1);
FAC2:=DualDescription(eTrig2);

EXTintA:=Intersection(Set(eTrig1), Set(eTrig2));
eVert1:=Difference(Set(eTrig1), EXTintA)[1];
eVert2:=Difference(Set(eTrig2), EXTintA)[1];
Print("EXTintA=\n");
PrintArray(EXTintA);
Print("eVert1=", eVert1, "\n");
Print("eVert2=", eVert2, "\n");
pos:=Position(eTrig1, eVert1);

GRPperm:=LinPolytope_Automorphism(eTrig1);
ePerm:=RepresentativeAction(GRPperm, 1, 4, OnPoints);
eMat:=__LemmaFindTransformation(eTrig1, eTrig1, ePerm);

nTrig1:=eTrig1*eMat;
nTrig2:=eTrig2*eMat;

EXTint:=Intersection(Set(nTrig1), Set(nTrig2));
nVert1:=Difference(Set(nTrig1), EXTint)[1];
nVert2:=Difference(Set(nTrig2), EXTint)[1];
Print("EXTint=\n");
PrintArray(EXTint);
Print("nVert1=", nVert1, "\n");
Print("nVert2=", nVert2, "\n");

eReply:=TRIG_TestFacednessPairSimplices(nTrig1, nTrig2);
