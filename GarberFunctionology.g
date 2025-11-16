d:=5;

eRec:=TRIG_GetGarberCubeTiling(d);
ListTrig:=eRec.ListTrig;
eCheckA:=TRIG_CheckCentralSymmetry(ListTrig);

RecTriang:=TRIG_GetAdjacencyInformationOfTriangulation(eRec.ListTrig);
eCheckB:=TRIG_TestDelaunayNessOfPeriodicTriangulation(RecTriang);

