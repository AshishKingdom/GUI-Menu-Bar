'    '@@:
'   @@@@@@              #@                   @@@@@@@
'  #@@  @@'             #@'               :@@@@@@@@@
'  @@`  +@#             '@#               ,@@@@  #@@
' #@#   +@@             ,@@     ,           .@@ +@@
' @@    '@#             `@@   +@@@      @@: .@@@@@@@           @# .@,      #@
' @@        .@@@+    @@# @@  .@@@@`  '@'@@@ `@@@@@@@@  #@@@   .@+ @@: :@@@@@@
':@#        @@@@@:  @@@@@@@  @@,@@   #@@@    @@@   @@@ @@@@@  #@. @@  @@@@@@.
'+@#        @@ `@@ #@# @@@@ @@@@@+   +@@:    @@     @@'@@ #@@ @@ `@@     @@+
''@@       .@@  '@:@@   @@@.@@@@+ `@,'@@     @@    `@@#@:  @@ @@ @@#    @@@
' @@,    @@.@#  .@'@@.  `@@ #@    @@.'@@     @@   '@@@#@`  #@ @@@@@@   @@@
' #@@@@@@@@.@@ #@@ #@@@@@@@ :@@@@@@@ +@+    +@@@@@@@@ #@# @@@ @@@@@@  @@@@+  @
'  @@@@@@#  @@@@@   @@@@@    @@@@@#  #@,    @@@@@@@@  .@@@@@   @  @@ '@@@@@@@@
'                                            @                    @@:`@  ,@@@`
'                                                            @,   ,@@
'                                                            @#    @@
'                                                            @@,  `@@
'                                                             @@@@@@#
'                                                             `@@@@@
'GUI Menu Bar v0.98
'Copyright <c> 2017-18
'By Ashish
'Last Update 4/30/2017


SUB addMenu (exp$)
    IF exp$ = "" THEN EXIT SUB

    SHARED GUIMenuItems() AS __MenuItemsType

    n = UBOUND(guimenuitems)
    GUIMenuItems(n).exp = exp$
    initMenuItems n
    REDIM _PRESERVE GUIMenuItems(n + 1) AS __MenuItemsType

END SUB

SUB initMenuItems (i)
    SHARED GUIMenuItems() AS __MenuItemsType
    IF i < 1 OR i > UBOUND(Guimenuitems) THEN EXIT SUB
    FOR j = 1 TO LEN(RTRIM$(GUIMenuItems(i).exp))
        ca$ = MID$(GUIMenuItems(i).exp, j, 1)
        IF ca$ = "[" THEN EXIT FOR
        tmp$ = tmp$ + ca$
    NEXT
    GUIMenuItems(i).shortKey = "!"
    FOR j = 1 TO LEN(tmp$)
        ca$ = MID$(tmp$, j, 1)
        IF ca$ = "#" THEN
            GUIMenuItems(i).shortKey = MID$(tmp$, j + 1, 1)
            GUIMenuItems(i).shortKeyPos = j - 1
            tmp2$ = LEFT$(tmp$, j - 1) + MID$(tmp$, j + 1, LEN(tmp$) - j)
            EXIT FOR
        END IF
    NEXT
    IF tmp2$ = "" THEN tmp2$ = tmp$
    GUIMenuItems(i).name = tmp2$
    IF i = 1 THEN GUIMenuItems(i).x = 10 ELSE GUIMenuItems(i).x = (GUIMenuItems(i - 1).x - 10) + LEN(RTRIM$(GUIMenuItems(i - 1).name)) * _FONTWIDTH + 30

END SUB

SUB GUIMenubarShow ()
    '  IF NOT allowMenuBar THEN EXIT SUB

     LINE (0, 0)-(_WIDTH, _FONTHEIGHT), GUIMenubarTheme.defaultBG, BF

    FOR i = 1 TO UBOUND(guimenuitems) - 1
        IF GUIMouseY > 0 AND GUIMouseY < _FONTHEIGHT AND GUIMouseX > GUIMenuItems(i).x - 10 AND GUIMouseX < GUIMenuItems(i).x + LEN(RTRIM$(GUIMenuItems(i).name)) * _FONTWIDTH + 10 OR UCASE$(GUIKeyHit$) = UCASE$(GUIMenuItems(i).shortKey) THEN
            IF GUIMouseClick OR UCASE$(GUIKeyHit$) = UCASE$(GUIMenuItems(i).shortKey) THEN
                'now, we have to draw  submenus
                GUIKeyHit$ = ""
                FOR j = 1 TO UBOUND(guimenuitems) - 1
                    COLOR GUIMenubarTheme.defaultFG, GUIMenubarTheme.defaultBG
                    _PRINTSTRING (GUIMenuItems(j).x, 0), RTRIM$(GUIMenuItems(j).name)
                    IF GUIMenuItems(j).shortKey <> "!" THEN
                        COLOR GUIMenubarTheme.shortcutKey
                        _PRINTSTRING (GUIMenuItems(j).x + (GUIMenuItems(j).shortKeyPos * _FONTWIDTH), 0), GUIMenuItems(j).shortKey
                    END IF

                NEXT
                backup& = _COPYIMAGE(0)
                FOR j = LEN(RTRIM$(GUIMenuItems(i).name)) + 1 TO LEN(RTRIM$(GUIMenuItems(i).exp))

                    ca$ = MID$(GUIMenuItems(i).exp, j, 1)
                    IF ca$ = "{" THEN cb = -1
                    IF ca$ = "}" AND cb THEN d = d + 1: cb = 0

                NEXT

                DIM Menus(d) AS __MenuItemsType
                n = 1
                FOR j = LEN(RTRIM$(GUIMenuItems(i).name)) + 1 TO LEN(RTRIM$(GUIMenuItems(i).exp))
                    ca$ = MID$(GUIMenuItems(i).exp, j, 1)
                    IF ca$ = "{" THEN cb = -1: ca$ = ""
                    IF ca$ = "}" AND cb THEN cb = 0: ca$ = "": Menus(n).name = tmps$: n = n + 1: tmps$ = ""
                    IF cb THEN tmps$ = tmps$ + ca$
                NEXT

                FOR j = 1 TO d
                    IF RTRIM$(Menus(j).name) = "***" THEN ELSE h = h + 1
                NEXT
                totalHeight = h * (_FONTHEIGHT + 8) + 10
                FOR j = 1 TO d
                    G = LEN(RTRIM$(Menus(j).name))
                    IF G > pg THEN fg = G
                    pg = G
                NEXT
                totalWidth = (fg * _FONTWIDTH) + 70
                Menus(0).x = _FONTHEIGHT / 2
                LINE (GUIMenuItems(i).x - 10, _FONTHEIGHT)-(totalWidth + GUIMenuItems(i).x, totalHeight + _FONTHEIGHT), GUIMenubarTheme.defaultBG, BF
                FOR j = 1 TO d
                    IF j = 1 THEN
                        Menus(j).x = _FONTHEIGHT + 8
                    ELSE
                        IF RTRIM$(Menus(j).name) = "***" THEN Menus(j).x = Menus(j - 1).x + 8 ELSE Menus(j).x = Menus(j - 1).x + _FONTHEIGHT + 8
                    END IF
                NEXT
                FOR j = 1 TO d
                    tmp$ = RTRIM$(Menus(j).name)
                    FOR k = 1 TO LEN(tmp$)
                        ca$ = MID$(tmp$, k, 1)
                        IF ca$ = "#" THEN
                            Menus(j).shortKey = MID$(tmp$, k + 1, 1)
                            Menus(j).shortKeyPos = k - 1
                            Menus(j).name = LEFT$(tmp$, k - 1) + MID$(tmp$, k + 1, LEN(tmp$) - k)
                            EXIT FOR
                        END IF
                    NEXT
                NEXT
                GUIMouseClick = 0
                GUIMouseX = 0
                GUIMouseY = 0
                DO
                    WHILE _MOUSEINPUT: WEND
                    GUIMouseX = _MOUSEX
                    GUIMouseY = _MOUSEY
                    GUIMouseClick = _MOUSEBUTTON(1)
                    k$ = INKEY$
                    IF GUIMouseX > GUIMenuItems(i).x + totalWidth AND GUIMouseClick OR GUIMouseY > _FONTHEIGHT + totalHeight AND GUIMouseClick OR GUIMouseX < GUIMenuItems(i).x - 10 AND GUIMouseClick OR GUIMouseY <= _FONTHEIGHT AND GUIMouseX > GUIMenuItems(i).x + LEN(RTRIM$(GUIMenuItems(i).name)) * _FONTWIDTH + 10 AND GUIMouseClick OR GUIMouseY <= _FONTHEIGHT AND GUIMouseX < GUIMenuItems(i).x - 10 AND GUIMouseClick THEN

                        GUISelected$ = ""
                        EXIT DO

                    END IF
                    FOR j = 1 TO d
                        IF RTRIM$(Menus(j).name) = "***" THEN
                            LINE (GUIMenuItems(i).x - 10, (Menus(j).x + _FONTHEIGHT) - 4)-STEP(totalWidth + 10, 0), GUIMenubarTheme.divider
                        ELSE
                            IF GUIMouseX > GUIMenuItems(i).x - 10 AND GUIMouseX < GUIMenuItems(i).x + totalWidth AND GUIMouseY > Menus(j).x - 8 AND GUIMouseY < Menus(j).x + _FONTHEIGHT THEN
                                GUISelected$ = RTRIM$(GUIMenuItems(i).name) + "^" + RTRIM$(Menus(j).name)
                                IF GUIMouseClick THEN
                                    GUISelected$ = RTRIM$(GUIMenuItems(i).name) + "#" + RTRIM$(Menus(j).name)
                                    EXIT DO
                                END IF
                                LINE (GUIMenuItems(i).x - 10, Menus(j).x - 8)-(GUIMenuItems(i).x + totalWidth, Menus(j).x + _FONTHEIGHT), GUIMenubarTheme.hoverBG, BF
                                COLOR GUIMenubarTheme.hoverFG, GUIMenubarTheme.hoverBG
                            ELSE
                                LINE (GUIMenuItems(i).x - 10, Menus(j).x - 8)-(GUIMenuItems(i).x + totalWidth, Menus(j).x + _FONTHEIGHT), GUIMenubarTheme.defaultBG, BF
                                COLOR GUIMenubarTheme.defaultFG, GUIMenubarTheme.defaultBG
                            END IF
                            _PRINTSTRING (GUIMenuItems(i).x, Menus(j).x - 4), RTRIM$(Menus(j).name)
                            IF GUIMenuItems(i).shortKey <> "!" THEN
                                COLOR GUIMenubarTheme.shortcutKey
                                _PRINTSTRING (GUIMenuItems(i).x + (Menus(j).shortKeyPos * _FONTWIDTH), Menus(j).x - 4), Menus(j).shortKey
                            END IF
                            IF UCASE$(k$) = UCASE$(Menus(j).shortKey) THEN GUISelected$ = RTRIM$(GUIMenuItems(i).name) + "#" + RTRIM$(Menus(j).name): EXIT DO
                        END IF
                    NEXT
                    _DISPLAY
                    _LIMIT 30
                LOOP
                CLS , _RGB(0, 0, 0)
                _PUTIMAGE , backup&
                _FREEIMAGE backup&
                ERASE Menus
                EXIT SUB
            END IF
            COLOR GUIMenubarTheme.hoverFG, GUIMenubarTheme.hoverBG
            LINE (GUIMenuItems(i).x - 10, 0)-(GUIMenuItems(i).x + LEN(RTRIM$(GUIMenuItems(i).name)) * _FONTWIDTH + 10, _FONTHEIGHT), GUIMenubarTheme.hoverBG, BF
        ELSE
            COLOR GUIMenubarTheme.defaultFG, GUIMenubarTheme.defaultBG
        END IF
        _PRINTSTRING (GUIMenuItems(i).x, 0), RTRIM$(GUIMenuItems(i).name)
        IF GUIMenuItems(i).shortKey <> "!" THEN
            COLOR GUIMenubarTheme.shortcutKey
            _PRINTSTRING (GUIMenuItems(i).x + (GUIMenuItems(i).shortKeyPos * _FONTWIDTH), 0), GUIMenuItems(i).shortKey
        END IF
    NEXT
END SUB
