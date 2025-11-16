List_ListTrig:=ReadAsFunction("List_ListTrig")();


ListInv:=[];
for eListTrig in List_ListTrig
do
  eInv:=TRIG_Invariant(eListTrig);
  Add(ListInv, eInv);
od;
