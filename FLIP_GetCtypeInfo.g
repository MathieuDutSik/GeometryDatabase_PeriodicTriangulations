n:=5;

eFile:=Concatenation("DATA/ListFlips_dim", String(n));

U:=ReadAsFunction(eFile)();
nbTriang:=Length(U);


FileSave:=Concatenation("DATA/ListCtype_info_dim", String(n));
if IsExistingFilePlusTouch(FileSave) then
  RecCtype_info:=ReadAsFunction(FileSave)();
else
  ListCtype_info:=[];
  ListConf:=[];
  ListInv:=[];
  for iTriang in [1..nbTriang]
  do
    Print("iTriang = ", iTriang, " / ", nbTriang, "\n");
    eListTrig:=U[iTriang];
    eConf:=TRIG_GetCtypeHedgehobConfiguration(eListTrig);
    eInv:=LinPolytope_Invariant(eConf);
    Add(ListConf, eConf);
    Add(ListInv, eInv);
  od;
  ListStatus:=ListWithIdenticalEntries(nbTriang,0);
  ListClasses:=[];
  for iTriang in [1..nbTriang]
  do
    if ListStatus[iTriang]=0 then
      eClass:=[iTriang];
      Print("iTriang=", iTriang, " |ListClasses|=", Length(ListClasses), "\n");
      ListStatus[iTriang]:=1;
      for jTriang in [iTriang+1..nbTriang]
      do
        if ListInv[iTriang]=ListInv[jTriang] then
          eIsom:=LinPolytopeIntegral_Isomorphism(ListConf[iTriang], ListConf[jTriang]);
          if eIsom<>false then
            ListStatus[jTriang]:=1;
            Print("  jTriang=", jTriang, "\n");
            Add(eClass, jTriang);
          fi;
        fi;
      od;
      Add(ListClasses, eClass);
    fi;
  od;
  Print("|ListClasses|=", Length(ListClasses), "\n");
  RecCtype_info:=rec(ListClasses:=ListClasses, ListConf:=ListConf);
  SaveDataToFilePlusTouch(FileSave, RecCtype_info);
fi;

