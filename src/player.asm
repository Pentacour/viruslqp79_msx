                MODULE          MPLAYER

 include "player_macros.asm" 

K_KEY_NO_KEY EQU 0
K_KEY_UP EQU 1
K_KEY_UPRIGHT EQU 2
K_KEY_RIGHT EQU 3
K_KEY_DOWNRIGHT equ 4
K_KEY_DOWN EQU 5
K_KEY_DOWNLEFT equ 6
K_KEY_LEFT  EQU 7
K_KEY_UPLEFT  EQU 8
K_KEY_SPACE EQU 10

K_SHOOT_WAIT               equ 8
K_FIREBALL_COST            equ 13
K_SOLID_TILE               equ 128
K_ITEMS_TILES              EQU 32
K_ZOMBIES_TILES            EQU 96
K_CHARGE_BULLETS_FREQUENCY equ 30
K_MAX_BULLETS_COUNT        equ 24


K_COOL_GIRL_INCREMENT equ  2

K_LEFT_MARGIN_SCROLL  equ  8*8+K_COOL_GIRL_INCREMENT
K_RIGHT_MARGIN_SCROLL equ 24*8
K_DOWN_MARGIN_SCROLL  equ 18*8
K_UP_MARGIN_SCROLL    equ  6*8+K_COOL_GIRL_INCREMENT




;====================================
;::MOVE_PLAYER
;====================================
MOVE_PLAYER
    LD    a, [MWORK.PLAYER_IMMUNITY]
    CP    0
    JP    z, .TrateShoot
    DEC   a
    LD    [MWORK.PLAYER_IMMUNITY], a
    LD    a, [MWORK.PRE_GAME_OVER]
    CP    1
    RET   z

.TrateShoot
    MCHECK_M
    LD    a, [MWORK.PLAYER_SHOOT_WAIT]
    CP    0
    JP    z, .CheckShoot
    DEC   a
    LD    [MWORK.PLAYER_SHOOT_WAIT], a
    JP    .CheckMove
.CheckShoot
    MCHECK_SHOOT

.CheckMove
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PLAYER_PREVIOUS_Y], bc
    XOR   a
    CALL  GTSTCK
    CP    0
    JP    nz, .CheckMoveTrate

    LD    a, 1
    CALL  GTSTCK
.CheckMoveTrate
    LD    [MWORK.PLAYER_KEY_PRESSED], a
    CP    K_KEY_NO_KEY
    JP    z, .NoKey
    CP    K_KEY_RIGHT
    JP    z, .SRight
    CP    K_KEY_LEFT
    JP    z, .SLeft
    CP    K_KEY_UP
    JP    z, .SUp
    CP    K_KEY_DOWN
    JP    z, .SDown
    CP    K_KEY_UPRIGHT
    JP    z, .UpRight
    CP    K_KEY_DOWNRIGHT
    JP    z, .DownRight
    CP    K_KEY_DOWNLEFT
    JP    z, .DownLeft
    CP    K_KEY_UPLEFT
    JP    z, .UpLeft
    RET

.SRight
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveRightPlayer
    RET

.SLeft
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveLeftPlayer
    RET

.SUp
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveUpPlayer
    RET
.SDown
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveDownPlayer
    RET

.UpRight
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveUpRightPlayer
    RET

.DownRight
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveDownRightPlayer
    RET

.DownLeft
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveDownLeftPlayer
    RET

.UpLeft
    LD    [MWORK.PLAYER_DIRECTION], a
    CALL  MoveUpLeftPlayer
    RET

.NoKey
    RET

;==================================
;::MoveUpRightPlayer
;==================================
MoveUpRightPlayer
    CALL  MoveUpPlayer
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PLAYER_PREVIOUS_Y], bc
    CALL  MoveRightPlayer
    RET

;==================================
;::MoveDownRightPlayer
;==================================
MoveDownRightPlayer
    CALL  MoveDownPlayer
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PLAYER_PREVIOUS_Y], bc
    CALL  MoveRightPlayer
    RET

;==================================
;::MoveDownLeftPlayer
;==================================
MoveDownLeftPlayer
    CALL  MoveDownPlayer
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PLAYER_PREVIOUS_Y], bc
    CALL  MoveLeftPlayer
    RET

;==================================
;::MoveUpLeftPlayer
;==================================
MoveUpLeftPlayer
    CALL  MoveUpPlayer
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PLAYER_PREVIOUS_Y], bc
    CALL  MoveLeftPlayer
    RET

;==================================
;::MoveRightPlayer
;==================================
MoveRightPlayer
    LD    a, [MWORK.PLAYER_X]
    CP    K_RIGHT_MARGIN_SCROLL
    JP    nc, .SCheckIfScroll

.SMovePlayer
    ;Move the player, not the camera.
    LD    a, [MWORK.CAMERA_TILE_X_RIGHT]
    CP    MSCREEN.K_MAP_MAX_RIGHT
    JP    c, .SMoveLess

.SDoMove
    LD    a, [MWORK.PLAYER_X]
    ADD   K_COOL_GIRL_INCREMENT
    LD    [MWORK.PLAYER_X], a
    ;Mira si puede ir
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP    nz, UndoMovement
    RET

.SMoveLess ;Move without arrive to the max right
    LD    a, [MWORK.PLAYER_X]
    CP    248-8
    JP    nc, UndoMovement
    JP    .SDoMove

.SCheckIfScroll
    ;Checks if the camera is at maximum right
    LD    a, [MWORK.CAMERA_TILE_X_RIGHT]
    CP    MSCREEN.K_MAP_MAX_RIGHT;-1
    JP    z, .SMovePlayer

    ;Checks if scroll causes background colision
    LD    bc, [MWORK.PLAYER_Y]
    LD    a, 8
    ADD   b
    LD    b, a
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP    nz, .UndoMovement

    ;Increments Interscroll counter
    LD    a, [MWORK.INTER_SCROLL_COUNTER_X]
    ADD   K_COOL_GIRL_INCREMENT
    AND   7
    LD    [MWORK.INTER_SCROLL_COUNTER_X], a
    CP    0
    RET   nz

    ;Do Scroll: Move camera on the right
    LD    a, K_KEY_RIGHT
    LD    [MWORK.CAMERA_CHANGED], a
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    INC   a
    LD    [MWORK.CAMERA_TILE_X_LEFT], a
    ADD   MSCREEN.K_CAMERA_WIDTH-1
    LD    [MWORK.CAMERA_TILE_X_RIGHT], a
    CALL  MSCREEN.UPDATE_CAMERA
    CALL  SCROLL_ENTITIES
    RET

.UndoMovement
    LD    a, 8 - K_COOL_GIRL_INCREMENT
    LD    [MWORK.INTER_SCROLL_COUNTER_X], a
    JP    UndoMovement

;==================================
;::MoveLeftPlayer
;==================================
MoveLeftPlayer
    LD    a, [MWORK.PLAYER_X]
    CP    K_LEFT_MARGIN_SCROLL
    JP    c, .SCheckIfScroll

.SMovePlayer
    ;Move the player, not the camera.
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    CP    1
    JP    nc, .SMoveLess
.SDoMove
    LD    a, [MWORK.PLAYER_X]
    SUB   K_COOL_GIRL_INCREMENT
    LD    [MWORK.PLAYER_X], a

    ;Mira si puede ir
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP    nz, UndoMovement
    RET

.SMoveLess ;Move without arrive to the max left
    LD    a, [MWORK.PLAYER_X]
    CP    16+8
    JP    c, UndoMovement
    JP    .SDoMove

.SCheckIfScroll
    ;Checks if the camera is at maximum left
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    CP    0 ;MAP_MAX_LEFT
    JP    z, .SDoMove ;.SMovePlayer

    ;Checks if scrolls causes background colision
    LD    bc, [MWORK.PLAYER_Y]
    LD    a, b
    ADD   -8
    LD    b, a
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP    nz, .UndoMovement

    ;Decrements Interscroll counter
    LD    a, [MWORK.INTER_SCROLL_COUNTER_X]
    SUB   K_COOL_GIRL_INCREMENT
    AND   7
    LD    [MWORK.INTER_SCROLL_COUNTER_X], a
    CP    0
    RET   nz

.DoScroll
    ;Move camera on the left
    LD    a, K_KEY_LEFT
    LD    [MWORK.CAMERA_CHANGED], a
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    DEC   a
    LD    [MWORK.CAMERA_TILE_X_LEFT], a
    ADD   MSCREEN.K_CAMERA_WIDTH-1
    LD    [MWORK.CAMERA_TILE_X_RIGHT], a
    CALL  MSCREEN.UPDATE_CAMERA
    CALL  SCROLL_ENTITIES
    RET

.UndoMovement
    LD    a, K_COOL_GIRL_INCREMENT
    LD    [MWORK.INTER_SCROLL_COUNTER_X], a
    JP    UndoMovement

;==================================
;::MoveDownPlayer
;==================================
MoveDownPlayer
    LD    a, [MWORK.PLAYER_Y]
    CP    K_DOWN_MARGIN_SCROLL
    JP    nc, .SCheckIfScroll

.SMovePlayer
    ;Move the player, not the camera.
    LD    a, [MWORK.CAMERA_TILE_Y_DOWN]
    CP    MSCREEN.K_MAP_MAX_DOWN
    JP    c, .SMoveLess
.SDoMove
    LD    a, [MWORK.PLAYER_Y]
    ADD   K_COOL_GIRL_INCREMENT
    LD    [MWORK.PLAYER_Y], a
    ;Miro si puede ir
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP    nz, UndoMovement
    RET

.SMoveLess ;Move without arrive to the max down
    LD    a, [MWORK.PLAYER_Y]
    CP    24*8-8*2
    JP    nc, UndoMovement
    JP    .SDoMove

.SCheckIfScroll
    ;Check if the camera is at maximum down
    LD    a, [MWORK.CAMERA_TILE_Y_DOWN]
    CP    MSCREEN.K_MAP_MAX_DOWN;-1
    JP    z, .SMovePlayer

    ;Checks if scrolls causes background colision
    LD    bc, [MWORK.PLAYER_Y]
    LD    a, 8
    ADD   c
    LD    c, a
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP    nz, .UndoMovement

    ;Increments Interscroll counter
    LD    a, [MWORK.INTER_SCROLL_COUNTER_Y]
    ADD   K_COOL_GIRL_INCREMENT
    AND   7
    LD    [MWORK.INTER_SCROLL_COUNTER_Y], a
    CP    0
    RET   nz

;.DoScroll
    ;Move camera down
    LD    a, K_KEY_DOWN
    LD    [MWORK.CAMERA_CHANGED], a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    INC   a
    LD    [MWORK.CAMERA_TILE_Y_TOP], a
    ADD   MSCREEN.K_CAMERA_HEIGHT-1
    LD    [MWORK.CAMERA_TILE_Y_DOWN], a
    CALL  MSCREEN.UPDATE_CAMERA
    CALL  SCROLL_ENTITIES
    RET

.UndoMovement
    LD    a, 8 - K_COOL_GIRL_INCREMENT
    LD    [MWORK.INTER_SCROLL_COUNTER_Y], a
    JP    UndoMovement



;==================================
;::MoveUpPlayer
;==================================
MoveUpPlayer
    LD    a, [MWORK.PLAYER_Y]
    CP    K_UP_MARGIN_SCROLL
    JP    c, .SCheckIfScroll

.SMovePlayer
    ;Move the player, not the camera.
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    CP    1
    JP    nc, .SMoveLess

.SDoMove
    LD    a, [MWORK.PLAYER_Y]
    SUB   K_COOL_GIRL_INCREMENT
    LD    [MWORK.PLAYER_Y], a

    ;Mira si puede ir
    LD    bc, [MWORK.PLAYER_Y]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP    nz, UndoMovement
    RET

.SMoveLess ;Move without arrive to the max top
    LD    a, [MWORK.PLAYER_Y]
    CP    MSCREEN.K_CAMERA_PIXELS_OFFSET_UP+8*3
    JP    c, UndoMovement
    JP    .SDoMove

.SCheckIfScroll
    ;Checks if the camera is at maximum left
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    CP    0 ;MAP_MAX_TOP
    JP    z, .SMovePlayer

    ;Checks if scrolls causes background colision
    LD    bc, [MWORK.PLAYER_Y]
    LD    a, -8
    ADD   c
    LD    c, a
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  CAN_GO
    JP  nz, .UndoMovement

    ;Decrements Interscroll counter
    LD    a, [MWORK.INTER_SCROLL_COUNTER_Y]
    SUB   K_COOL_GIRL_INCREMENT
    AND   7
    LD    [MWORK.INTER_SCROLL_COUNTER_Y], a
    CP    0
    RET   nz
.DoScroll
    ;Move camera up
    LD    a, K_KEY_UP
    LD    [MWORK.CAMERA_CHANGED], a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    DEC   a
    LD    [MWORK.CAMERA_TILE_Y_TOP], a
    ADD   MSCREEN.K_CAMERA_HEIGHT-1
    LD    [MWORK.CAMERA_TILE_Y_DOWN], a
    CALL  MSCREEN.UPDATE_CAMERA
    CALL  SCROLL_ENTITIES
    RET

.UndoMovement
    LD    a, K_COOL_GIRL_INCREMENT
    LD    [MWORK.INTER_SCROLL_COUNTER_Y], a
    JP    UndoMovement

;=======================================================
;::UndoMovement
;========================================================
UndoMovement
    LD    bc, [MWORK.PLAYER_PREVIOUS_Y]
    LD    [MWORK.PLAYER_Y], bc
    RET



;=======================================================
;::CAN_GO
;========================================================
CAN_GO
        LD    bc, [MWORK.PARAM_CAN_GO_Y]
        CALL  MSUPPORT.YX_TO_OFFSET
    LD    hl, MWORK.CAMERA_SCREEN
    ADD   hl, de
    LD    a, [hl]
    CP    32
    JP    c, .Continue
    CP    96
    JP    c, CollisionWithEnte

.Continue
        ; Si X%8=0 ...
        LD    a, [MWORK.PARAM_CAN_GO_X]
        AND       7
        CP      0
        JP      z, .ModX0

        ; Si X%8 != 0 mira la Y
        LD        a, [MWORK.PARAM_CAN_GO_Y]
        AND       7
        CP      0
        JP      z, .ModXNo0Y0

.ModXNo0YNo0    ; Mira actual, siguiente y anterior en X y en Y
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        DEC   hl
        DEC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        LD    bc, -32
        ADD   hl, bc    ;Linea superior
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        LD    bc, 64
        ADD   hl, bc    ;Linea inferior a la central
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        DEC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        DEC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
    JP    RetYes

.ModXNo0Y0 ; //X%8 != 0 y Y%8=0-> Mira actual, siguiente y anterior
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        DEC   hl
        DEC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        LD    bc, -32
        ADD   hl, bc    ;Linea superior
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        JP    RetYes

.ModX0  ;//X%8=0. Mira la Y...
        LD    a, [MWORK.PARAM_CAN_GO_Y]
        AND   7
        CP    0
        JP    z, .ModXY0

.ModX0YNo0 ;//X%8 = 0 y Y%8 != 0 -> Mira los actuales y los anteriores en X y actuales, anteriores y posteriores en Y
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        DEC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        LD    bc, -32
        ADD   hl, bc    ; Linea superior
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        LD    bc, 64
        ADD   hl, bc    ; Linea inferior a la central
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        DEC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        JP    RetYes

.ModXY0 ;//X%8=0 y Y%8=0 -> Mira los actuales y los anteriores
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        DEC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        LD    bc, -32
        ADD   hl, bc
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        INC   hl
        LD    a, [hl]
        CP    K_SOLID_TILE
        JP    nc, RetNo
        JP    RetYes

RetYes
        XOR   a
        CP    0
        RET

CollisionWithEnte
RetNo
        XOR   a
        CP    1
        RET

;===================================
;::SET_PLAYER_FRAME
;===================================
SET_PLAYER_FRAME
    LD    a, [MWORK.PLAYER_IMMUNITY]
    CP    0
    JP    z, .Continue
    LD    a, [MWORK.ANIMATION_TICK]
    AND   7
    CP    4
    RET   c
.Continue
    LD    a, [MWORK.PRE_GAME_OVER]
    CP    1
    CALL  z, CHECK_GAME_OVER

    CALL  ENTITY.GET_NEXT_INDEX_SPRITE_DE
    CALL  ENTITY.GET_NEXT_INDEX_SPRITE_HL 
    LD    bc, [MWORK.PLAYER_Y]
    LD    a, -8
    ADD   c
    LD    [de], a ;Y
    LD    [hl], a ;Y
    INC   de  ;Positions on X
    INC   hl
    LD    a, -8
    ADD   b
    LD    [de], a ;X
    LD    [hl], a ;X
    INC   de  ;Positions on frame
    INC   hl
    PUSH  de
    PUSH  hl

    ;Set Frame
    LD    a, [MWORK.PLAYER_DIRECTION]
    DEC   a
    LD    l, a
    XOR   a
    SRL   l
    RRA
    LD    h, l
    LD    l, a ;hl=a*128
    LD    bc, MDATA.SPRITE_GIRL_0
    ADD   hl, bc

    ;Check animation Frame
    LD    a, [MWORK.PLAYER_KEY_PRESSED]
    CP    K_KEY_NO_KEY
    JP    z, .SetFrame

    LD    a, [MWORK.ANIMATION_TICK]
    AND   8
    CP    0
    JP    z, .SetFrame

    LD    bc, 64
    ADD   hl, bc
.SetFrame
    LD    [MWORK.PLAYER_PATTERN], hl
    POP   hl  ;Retrieve frame position
    POP   de
    LD    [hl], 0
    LD    a, 4
    LD    [de], a
    INC   hl  ;Positions on color
    INC   de
    LD    [hl], 6
    LD    a, 15
    LD    [de], a
.SetFrameContinue
    RET


;=====================================
;::CHECK_GAME_OVER 
;=====================================
CHECK_GAME_OVER 
                                LD      A, [MWORK.PLAYER_IMMUNITY]
                                CP      2
                                RET     NC
    
                                POP     BC  ;RET
                                JP      MGAME.SHOW_GAME_OVER


;=================================
;::ADD_NEW_NORMAL_PLAYER_SHOOT
;=================================
ADD_NEW_NORMAL_PLAYER_SHOOT
    LD    a, [MWORK.CURRENT_NUMBER_OF_SHOOTS]
    INC   a
    LD    [MWORK.CURRENT_NUMBER_OF_SHOOTS], a
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_DIRECTION]
    CP    K_KEY_UP
    JP    z, .SUp
    CP    K_KEY_UPRIGHT
    JP    z, .SUpRight
    CP    K_KEY_RIGHT
    JP    z, .SRight
    CP    K_KEY_DOWNRIGHT
    JP    z, .SDownRight
    CP    K_KEY_DOWN
    JP    z, .SDown
    CP    K_KEY_DOWNLEFT
    JP    z, .SDownLeft
    CP    K_KEY_LEFT
    JP    z, .SLeft

.SUpLeft
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], -8
    RET

.SUp
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 0
    RET

.SUpRight
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 8
    RET

.SRight
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], 8
    RET

.SDownRight
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 8
    RET

.SDown
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 0
    RET

.SDownLeft
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], -8
    RET

.SLeft
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], -8
    RET

;=========================================
;::SCROLL_ENTITIES
;=========================================
SCROLL_ENTITIES
    PUSH  ix
    LD    ix, MWORK.LIST_ENTITIES_DATA
.LoopScrollEntity
    ;Scroll Entity In camera
    LD    a, [ix]
    CP    0
    JP    z, .NextEntity

    LD    a, [ix+ENTITY.K_OFFSET_IS_VISIBLE]
    CP    1
    JP    z, .TrateVisibleEntity

    ; Trate no visible entity
    LD    a, [MWORK.CAMERA_CHANGED]
    CP    K_KEY_RIGHT
    JP    z, .NoVisibleEntityRight
    CP    K_KEY_LEFT
    JP    z, .NoVisibleEntityLeft
    CP    K_KEY_UP
    JP    z, .NoVisibleEntityUp
    JP    .NoVisibleEntityDown

.NoVisibleEntityRight
    MCHECK_IF_VISIBLE
    JP    .TrateNotToVisible

.NoVisibleEntityLeft
    MCHECK_IF_VISIBLE
    JP    .TrateNotToVisible

.NoVisibleEntityUp
    MCHECK_IF_VISIBLE
    JP    .TrateNotToVisible

.NoVisibleEntityDown
    MCHECK_IF_VISIBLE
    JP    .TrateNotToVisible

.TrateNotToVisible
    LD    [ix+ENTITY.K_OFFSET_IS_VISIBLE], 1
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    LD    b, a
    LD    a, [ix+ENTITY.K_OFFSET_MAP_X]
    SUB   b
    SLA   a
    SLA   a
    SLA   a
    LD    [ix+ENTITY.K_OFFSET_X], a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    LD    b, a
    LD    a, [ix+ENTITY.K_OFFSET_MAP_Y]
    SUB   b
    SLA   a
    SLA   a
    SLA   a
    ADD   MSCREEN.K_CAMERA_LINES_OFFSET_UP*8
    LD    [ix+ENTITY.K_OFFSET_Y], a
    JP    .NextEntity

    ;Trate visible entities
.TrateVisibleEntity
    LD    a, [MWORK.CAMERA_CHANGED]
    CP    K_KEY_RIGHT
    JP    z, .ScrollEntityRight
    CP    K_KEY_LEFT
    JP    z, .ScrollEntityLeft
    CP    K_KEY_UP
    JP    z, .ScrollEntityUp
    JP    .ScrollEntityDown

.ScrollEntityRight
    LD    [ix+ENTITY.K_OFFSET_NOVISIBLE_COUNTER], 0
    LD    a, [ix+ENTITY.K_OFFSET_X]
    CP    8
    JP    z, .TrateVisibleToNotByLeft
    SUB   8
    LD    [ix+ENTITY.K_OFFSET_X], a
    JP    .NextEntity

.ScrollEntityLeft
    LD    [ix+ENTITY.K_OFFSET_NOVISIBLE_COUNTER], 0
    LD    a, [ix+ENTITY.K_OFFSET_X]
    CP    31*8
    JP    z, .TrateVisibleToNotByRight
    ADD   8
    LD    [ix+ENTITY.K_OFFSET_X], a
    JP    .NextEntity

.ScrollEntityUp
    LD    [ix+ENTITY.K_OFFSET_NOVISIBLE_COUNTER], 0
    LD    a, [ix+ENTITY.K_OFFSET_Y]
    CP    23*8
    JP    z, .TrateVisibleToNotByDown
    ADD   8
    LD    [ix+ENTITY.K_OFFSET_Y], a
    JP    .NextEntity

.ScrollEntityDown
    LD    [ix+ENTITY.K_OFFSET_NOVISIBLE_COUNTER], 0
    LD    a, [ix+ENTITY.K_OFFSET_Y]
    CP    (MSCREEN.K_CAMERA_LINES_OFFSET_UP)*8+8
    JP    z, .TrateVisibleToNotByUp
    SUB   8
    LD    [ix+ENTITY.K_OFFSET_Y], a
    JP   .NextEntity

.TrateVisibleToNotByUp
    LD    [ix+ENTITY.K_OFFSET_IS_VISIBLE], 0
    LD    a, [ix+ENTITY.K_OFFSET_X]
    SRL   a
    SRL   a
    SRL   a
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    ADD   b
    LD    [ix+ENTITY.K_OFFSET_MAP_X], a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    LD    [ix+ENTITY.K_OFFSET_MAP_Y], a
    JP    .NextEntity

.TrateVisibleToNotByDown
    LD    [ix+ENTITY.K_OFFSET_IS_VISIBLE], 0
    LD    a, [ix+ENTITY.K_OFFSET_X]
    SRL   a
    SRL   a
    SRL   a
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    ADD   b
    LD    [ix+ENTITY.K_OFFSET_MAP_X], a
    LD    a, [MWORK.CAMERA_TILE_Y_DOWN]
    INC   a
    LD    [ix+ENTITY.K_OFFSET_MAP_Y], a
    JP    .NextEntity

.TrateVisibleToNotByLeft
    LD    [ix+ENTITY.K_OFFSET_IS_VISIBLE], 0
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    LD    [ix+ENTITY.K_OFFSET_MAP_X], a
    LD    a, [ix+ENTITY.K_OFFSET_Y]
    SRL   a
    SRL   a
    SRL   a
    SUB   MSCREEN.K_CAMERA_LINES_OFFSET_UP
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    ADD   b
    LD    [ix+ENTITY.K_OFFSET_MAP_Y], a
    JP    .NextEntity

.TrateVisibleToNotByRight
    LD    [ix+ENTITY.K_OFFSET_IS_VISIBLE], 0
    LD    a, [MWORK.CAMERA_TILE_X_RIGHT]
    INC   a
    LD    [ix+ENTITY.K_OFFSET_MAP_X], a
    LD    a, [ix+ENTITY.K_OFFSET_Y]
    SRL   a
    SRL   a
    SRL   a
    SUB   MSCREEN.K_CAMERA_LINES_OFFSET_UP
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    ADD   b
    LD    [ix+ENTITY.K_OFFSET_MAP_Y], a

.NextEntity
    LD    bc, MWORK.K_DATA_PER_ENTITY
    ADD   ix, bc
    LD    a, [ix]
    CP    MWORK.K_EOF
    JP    z, .Ret
    JP    .LoopScrollEntity

.Ret
    POP   ix
    RET

;============================
;::CHARGE_BULLETS
;============================
CHARGE_BULLETS
    LD    a, [MWORK.CHARGE_BULLETS_COUNTER]
    INC   a
    LD    [MWORK.CHARGE_BULLETS_COUNTER], a
    CP    K_CHARGE_BULLETS_FREQUENCY
    RET   nz

    XOR   a
    LD    [MWORK.CHARGE_BULLETS_COUNTER], a
    LD    a, [MWORK.PLAYER_BULLETS]
    CP    K_MAX_BULLETS_COUNT
    RET   nc
    INC   a
    LD    [MWORK.PLAYER_BULLETS], a
    RET

;=================================
;::ADD_NEW_PLAYER_DOUBLE_SHOOT
;=================================
ADD_NEW_PLAYER_DOUBLE_SHOOT
    LD    a, [MWORK.CURRENT_NUMBER_OF_SHOOTS]
    CP    0
    RET   nz
    ADD   2
    LD    [MWORK.CURRENT_NUMBER_OF_SHOOTS], a
    LD    a, [MWORK.PLAYER_DIRECTION]
    CP    K_KEY_UP
    JP    z, .SUp
    CP    K_KEY_UPRIGHT
    JP    z, .SUpRight
    CP    K_KEY_RIGHT
    JP    z, .SRight
    CP    K_KEY_DOWNRIGHT
    JP    z, .SDownRight
    CP    K_KEY_DOWN
    JP    z, .SDown
    CP    K_KEY_DOWNLEFT
    JP    z, .SDownLeft
    CP    K_KEY_LEFT
    JP    z, .SLeft

.SUpLeft
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7-6
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], -8

    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    SUB   6
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], -8
    RET

.SUp
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    SUB   4
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 0
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    ADD   4
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 0

    ret

.SUpRight
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7-6
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    ADD   6
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 8
    RET

.SRight
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   6
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], 8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    SUB   2
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], 8
    RET

.SDownRight
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   6
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    ADD   6
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 8
    RET

.SDown
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    ADD   4 
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 0
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    SUB   4
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 0
    RET

.SDownLeft
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   6
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], -8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    SUB   6
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], -8
    RET

.SLeft
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   6
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], -8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    SUB   2
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], -8
    RET


;=================================
;::ADD_NEW_PLAYER_TRIPLE_SHOOT
;=================================
ADD_NEW_PLAYER_TRIPLE_SHOOT
    LD    a, [MWORK.CURRENT_NUMBER_OF_SHOOTS] 
    CP    0
    RET   nz
    LD    a, 3
    LD    [MWORK.CURRENT_NUMBER_OF_SHOOTS], a
    LD    a, [MWORK.PLAYER_DIRECTION]
    CP    K_KEY_UP
    JP    z, .SUp
    CP    K_KEY_UPRIGHT
    JP    z, .SUpRight
    CP    K_KEY_RIGHT
    JP    z, .SRight
    CP    K_KEY_DOWNRIGHT
    JP    z, .SDownRight
    CP    K_KEY_DOWN
    JP    z, .SDown
    CP    K_KEY_DOWNLEFT
    JP    z, .SDownLeft
    CP    K_KEY_LEFT
    JP    z, .SLeft

.SUpLeft
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], -8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -10
    INC   hl
    LD    [hl], -6
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -6
    INC   hl
    LD    [hl], -10
    RET

.SUp
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 0
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], -2
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 2
    RET

.SUpRight
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -8
    INC   hl
    LD    [hl], 8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -10
    INC   hl
    LD    [hl], 6
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   7
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -6
    INC   hl
    LD    [hl], 10
    RET


.SRight
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], 8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -2
    INC   hl
    LD    [hl], 8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 2
    INC   hl
    LD    [hl], 8
    RET

.SDownRight
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 10
    INC   hl
    LD    [hl], 6
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 6
    INC   hl
    LD    [hl], 10
    RET

.SDown
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 0
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], 2
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], -2
    RET

.SDownLeft
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 8
    INC   hl
    LD    [hl], -8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 10
    INC   hl
    LD    [hl], -6
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 6
    INC   hl
    LD    [hl], -10
    RET

.SLeft
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 0
    INC   hl
    LD    [hl], -8
    CALL   ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], -2
    INC   hl
    LD    [hl], -8
    CALL  ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT
    INC   hl
    LD    [hl], 1 ;IsVisible
    INC   hl
    LD    a, [MWORK.PLAYER_Y]
    ADD   3
    LD    [hl], a
    INC   hl
    LD    a, [MWORK.PLAYER_X]
    LD    [hl], a
    INC   hl
    LD    [hl], 2
    INC   hl
    LD    [hl], -8
    RET


                ENDMODULE