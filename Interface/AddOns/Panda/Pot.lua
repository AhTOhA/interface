﻿
local L = Panda.locale
local panel = Panda.panel:NewPanel(true)


panel:RegisterFrame(L["Flasks (Cat)"], Panda.PanelFactory(2259,
[[58085 3371x1 52329x8 52983x8 52987x8 0 0 62288 58085x1 58086x1 58087x1 58088x1 58142x8
  58086 3371x1 52329x8 52985x8 52987x8 0 0 65460 58085x3 58086x3 58087x3 58088x3
  58087 3371x1 52329x8 52985x8 52988x8
  58088 3371x1 52329x8 52983x8 52988x8
  67438 3371x1 52329x8 52984x8 52986x8
]]))


panel:RegisterFrame(L["Elixirs (Cat)"], Panda.PanelFactory(2259,
[[
  58084 3371x1 52983x2   0     0 0 58093 3371x1 52986x2
  58089 3371x1 52984x1 52985x1 0 0 58143 3371x1 52983x1 52988x1
  58092 3371x1 52983x1 52985x1
  58094 3371x1 52983x1 52986x1
  58144 3371x1 52984x1 52987x1
  58148 3371x1 52986x1 52987x1
]]))


panel:RegisterFrame(L["Flasks"], Panda.PanelFactory(2259,
[[40079  3371 36901 37921   0    0  33208  3371 22794 22791 22786  0  13513 8925 13468 13465 13467
  44939  3371 39970   0     0    0  22851  3371 22794 22793 22790  0  13510 8925 13468 13423  8846
  46379  3371 36908 37704 36905  0  22853  3371 22794 22793 22786  0  13511 8925 13468 13467 13463
  46378  3371 36908 40195 36906  0  22854  3371 22794 22793 22789  0  13506 8925 13468 13465 13423
  46377  3371 36908 36901 36905  0  22861  3371 22794 22793 22791  0  13512 8925 13468 13465 13463
  46376  3371 36908 36905 36906  0  22866  3371 22794 22793 22792
]]))


panel:RegisterFrame(L["Battle Elixirs (Wrath)"], Panda.PanelFactory(2259,
[[40068  3371 36901 37921 37921   0   0 44327  3371 36901 36903 36903
  40076  3371 40195 40195 40195   0   0 44330  3371 36904 36904
  40073  3371 36904 36904   0     0   0 44329  3371 36901 36903 36903
  39666  3371 36901 36901 36903 36903 0 40070  3371 36901 36904
  44325  3371 36907 36904 36904   0   0 44331  3371 37921 37704
		0     0     0     0     0     0   0
]]))


panel:RegisterFrame(L["Guardian Elixirs (Wrath)"], Panda.PanelFactory(2259,
[[40072  3371 36907 36907 36907 0 40078  3371 36901 36901 36901 36901
  44332  3371 36907 37921 37921 0 40097  3371 37701 36906 36906
  40109  3371 36901 36905 36905 0 44328  3371 37704 36906 36906
	  0
   8827  3371 44958 44958 44958
]]))


panel:RegisterFrame(L["Battle Elixirs (BC)"], Panda.PanelFactory(2259,
[[22825  3371 13464 22786   0   0 28102  3371 22785 13465
  22833  3371 22790 22574 22574 0 28103  3371 22785 13463
  22824  3371 22785 13465   0   0 28104  3371 22785 22789 22789 22789
  31679  3371 22789 22792 22792 0 22831  3371 22789 22785 22785
  22827  3371 22790 22578 22578
  22835  3371 22790 22792
]]))


panel:RegisterFrame(L["Guardian Elixirs (BC)"], Panda.PanelFactory(2259,
[[32062  3371 22785 22787 22787 0 22834  3371 22789 22790 22790
  32067  3371 22785 22789   0   0 22840  3371 22790 22791
  32063  3371 22786 22787 22787 0 22848  3371 22791 22793
  32068  3371 22790 22787
]]))