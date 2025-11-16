PrintLatexInformation:=function(n)
  local eFile, eFileB, PreList_ListTrig, PreListGRP, PreListDelaunayCentSymm, nbTrig, PreListInfo, iTrig, eSum1, eSum2, eInfo, ePerm, List_ListTrig, ListGRP, ListDelaunayCentSymm, FinalFileTex, FinalFileDVI, FinalFileTexB, FinalFileDVIB, FinalFilePSB, output, eFile1, eFile2, eFile3;
  eFile:=Concatenation("ListOfTriangulationsInvariant_", String(n));
  eFile1:=Concatenation("DATA/ListFlips_dim", String(n));
  PreList_ListTrig:=ReadAsFunction(eFile1)();
  eFile2:=Concatenation("DATA/ListGRP_dim", String(n));
  PreListGRP:=ReadAsFunction(eFile2)();
  eFile3:=Concatenation("DATA/ListDelaunayCentSymm_dim", String(n));
  PreListDelaunayCentSymm:=ReadAsFunction(eFile3)();
  #
  nbTrig:=Length(PreList_ListTrig);
  PreListInfo:=[];
  for iTrig in [1..nbTrig]
  do
    eSum1:=0;
    if PreListDelaunayCentSymm[iTrig].IsDelaunay then
      eSum1:=eSum1+1;
    fi;
    eSum2:=0;
    if PreListDelaunayCentSymm[iTrig].testCent then
      eSum2:=eSum2+1;
    fi;
    #
    eInfo:=[1 - eSum1, 1-eSum2, 1/PreListGRP[iTrig].ord];
    Add(PreListInfo, eInfo);
  od;
  ePerm:=SortingPerm(PreListInfo);
  List_ListTrig:=Permuted(PreList_ListTrig, ePerm);
  ListGRP:=Permuted(PreListGRP, ePerm);
  ListDelaunayCentSymm:=Permuted(PreListDelaunayCentSymm, ePerm);
  #
  eFileB:=Concatenation("TEX/", eFile, "_pre.tex");
  RemoveFileIfExist(eFileB);
  output:=OutputTextFile(eFileB, true);
  AppendTo(output, "Dimension n=", n, "\n");
  AppendTo(output, "{\\small\n");

  AppendTo(output, "\\begin{enumerate}\n");
  for iTrig in [1..nbTrig]
  do
    AppendTo(output, "\\item Triangulation ", iTrig, ": ");
    if ListDelaunayCentSymm[iTrig].IsDelaunay then
      AppendTo(output, " Delaunay");
    else
      AppendTo(output, " NOT Delaunay");
    fi;
    #
    AppendTo(output, ", ");
    if ListDelaunayCentSymm[iTrig].testCent then
      AppendTo(output, " Cent. symm.");
    else
      AppendTo(output, " NOT Cent. symm.");
    fi;
    #
    AppendTo(output, " \$\\vert GRP\\vert\$=", ListGRP[iTrig].ord, "\n");
  od;

  AppendTo(output, "\\end{enumerate}\n");
  AppendTo(output, "}\n");
  CloseStream(output);
  #
  SaveDataToFile(Concatenation("TEX/ListOfTriangulation_", String(n)), List_ListTrig);
  #
  FinalFileTex:=Concatenation("TEX/", eFile, ".tex");
  FinalFileDVI:=Concatenation("TEX/", eFile, ".dvi");
  FinalFileTexB:=Concatenation(eFile, ".tex");
  FinalFileDVIB:=Concatenation(eFile, ".dvi");
  FinalFilePSB:=Concatenation(eFile, ".ps");
  Exec("cat TEX/Header.tex ", eFileB, " TEX/Footer.tex > ", FinalFileTex);
  Exec("(cd TEX && latex ", FinalFileTexB, ")");
  Exec("(cd TEX && dvips ", FinalFileDVIB, " -o )");
  Exec("(cd TEX && ps2pdf ", FinalFilePSB, ")");
end;


PrintLatexInformation(5);
