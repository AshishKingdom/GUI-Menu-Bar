'$include:'GUIMenubar_Global.bas'

_TITLE "Menu_Testing_1"
SCREEN _NEWIMAGE(600, 400, 32)
'Custom theme settings
GUIMenubarTheme.defaultFG = _RGB(255, 255, 255)
GUIMenubarTheme.defaultBG = _RGB(40, 40, 40)
GUIMenubarTheme.hoverBG = _RGB(255, 150, 0)
GUIMenubarTheme.hoverFG = _RGB(255, 255, 255)
GUIMenubarTheme.divider = _RGB(255, 255, 255)
GUIMenubarTheme.shortcutKey = _RGB(255, 255, 0)

addMenu "#File[{#New File}{#Open File}{***}{#Save}{Save #As}{***}{E#xit}]"
addMenu "#Insert[{#Line}{***}{#Circle}{#Rectangle}{#Triangle}{***}{#Polygon}{Pol#yline}]"
addMenu "#View[{HTML #Code}{#Browser Output}]"
addMenu "#Options[{#Language}{#Theme}{***}{#Help}{About A#uthor}{***}{#Version}]"
_PRINTSTRING (150, 200), "Try to select any menuitem"
DO
    WHILE _MOUSEINPUT: WEND
    GUIMouseX = _MOUSEX
    GUIMouseY = _MOUSEY
    GUIMouseClick = _MOUSEBUTTON(1)
    GUIKeyHit$ = INKEY$
    IF GUIMouseY < _FONTHEIGHT OR GUIKeyHit$ <> "" THEN GUIMenubarShow
    IF GUISelected$ <> "" THEN
        COLOR _RGB(255, 255, 255), _RGB(0, 0, 0)
        _PRINTSTRING (150, 200), SPACE$(50)
        _PRINTSTRING (150, 230), SPACE$(50)
        a = INSTR(GUISelected$, "#")
        _PRINTSTRING (150, 200), "You have selected " + LEFT$(GUISelected$, a - 1) + "-->" + MID$(GUISelected$, a + 1, LEN(GUISelected$) - a)
        COLOR _RGB(0, 200, 255)
        _PRINTSTRING (150, 230), "GuiSelected$ = " + CHR$(34) + GUISelected$ + CHR$(34)
        GUISelected$ = ""
    END IF
    _DISPLAY
    _LIMIT 30
LOOP
'$include:'GUIMenubar_Method.bas'
