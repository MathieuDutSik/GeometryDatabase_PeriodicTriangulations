n:=5;

eFile:=Concatenation("DATA/ListFlips_dim", String(n));

U:=ReadAsFunction(eFile)();
nbTriang:=Length(U);


FileSave:=Concatenation("DATA/ListGRPinfo_dim", String(n));
if IsExistingFilePlusTouch(FileSave) then
  ListGRPinfo:=ReadAsFunction(FileSave)();
else
  ListGRPinfo:=[];
  for iTriang in [1..nbTriang]
  do
    Print("iTriang = ", iTriang, " / ", nbTriang, "\n");
    eListTrig:=U[iTriang];
    Print("iTriang=", iTriang, "/", nbTriang, "\n");
    GRPinfo:=TRIG_GetSymmetryGroupTriangulation(eListTrig);
    Add(ListGRPinfo, GRPinfo);
  od;
  SaveDataToFilePlusTouch(FileSave, ListGRPinfo);
fi;

