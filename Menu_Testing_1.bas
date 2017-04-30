'$include:'GUIMenubar_Global.bas'
'Custom settings
_TITLE "Menu_Testing_1"
SCREEN _NEWIMAGE(600, 400, 32)

addMenu "#File[{#New File}{#Open File}{***}{#Save}{Save #As}{***}{E#xit}]"
addMenu "#Insert[{#Line}{***}{#Circle}{#Rectangle}{#Triangle}{***}{#Polygon}{Pol#yline}]"
addMenu "#View[{HTML #Code}{#Browser Output}]"
addMenu "#Options[{#Language}{#Theme}{***}{#Help}{About A#uthor}{***}{#Version}]"
DO
    WHILE _MOUSEINPUT: WEND
    GUIMouseX = _MOUSEX
    GUIMouseY = _MOUSEY
    GUIMouseClick = _MOUSEBUTTON(1)
    GUIKeyHit$ = INKEY$
    IF GUIMouseY < _FONTHEIGHT OR GUIKeyHit$ <> "" THEN GUIMenubarShow
    _DISPLAY
    _LIMIT 30
LOOP
'$include:'GUIMenubar_Method.bas'
