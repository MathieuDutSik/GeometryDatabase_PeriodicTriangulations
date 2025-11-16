eChoice:=2;
if eChoice=1 then
  TheSimplex:=SIMPLEX_GetEnumerationResults(5)[1];
  TheDist:=6;
  SavePrefix:="DATAadjacency/Simplex5_1/";
elif eChoice=2 then
  TheSimplex:=SIMPLEX_GetEnumerationResults(5)[2];
  TheDist:=4;
  SavePrefix:="DATAadjacency/Simplex5_2/";
else
  Error("Missing choice in the code");
fi;


ListOrbitChoice:=TRIG_EnumeratePossiblePairsSimplices_General(TheSimplex, TheDist, SavePrefix);


