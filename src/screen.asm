                MODULE          MSCREEN

 include "screen_macros.asm"

K_CAMERA_WIDTH            equ 32
K_CAMERA_HEIGHT           equ 22
K_CAMERA_LINES_OFFSET_UP  equ 2
K_CAMERA_PIXELS_OFFSET_UP equ K_CAMERA_LINES_OFFSET_UP*8
K_MAP_MAX_RIGHT           equ 63
K_MAP_MAX_DOWN            equ 31

K_HEART_EMPTY_TILE    equ 219
K_HEART_FULL_TILE     equ 220
K_HEART_MEDIUM_TILE   equ 221
K_NUMBER_ZERO_TILE    equ 170
K_TIME_ZERO_TILE      equ 180


;========================================
;::CLEAR_SCREEN
;========================================
CLEAR_SCREEN
                CALL            CLEAR_CAMERA

                LD              A, 209                          ; SPRITES
                LD              HL, SPRATR
                LD              BC, 4*MWORK.K_MAX_NUMBER_OF_SPRITES
                CALL            FILVRM

                LD              HL, MWORK.CAMERA_SCREEN         ; TILES
                LD              DE, NAMTBL
                LD              B, 48
                CALL            MSUPPORT.UFLDIRVM
                RET

;======================================
;::CLEAR_CAMERA
;======================================
CLEAR_CAMERA
                LD              BC, 32*24
                LD              DE, MWORK.CAMERA_SCREEN
                JP              MSUPPORT.RESET_BIG_RAM

;==========================================
;::RENDER_TEXT
;  IN->HL TEXT, DE->CAMERA POSITION
;==========================================
RENDER_TEXT
                LD              C, [HL]
                LD              B, 0
                INC             HL
                LDIR
                RET

;==========================================
;::LOAD_TILESET_ONE_BANK
;   IN->hl Patterns, de, Colors
;==========================================
LOAD_TILESET_ONE_BANK
    PUSH    de
    LD  de, MWORK.TMP_UNZIP
    CALL    PLETTER.UNPACK

    LD  HL, MWORK.TMP_UNZIP
    LD  de, CHRTBL
    LD  bc, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  de, CHRTBL+32*8*8
    LD  bc, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  de, CHRTBL+32*8*8*2
    LD  bc, 32*8*8
    CALL    LDIRVM

    POP hl
    LD  de, MWORK.TMP_UNZIP
    CALL    PLETTER.UNPACK

    LD  HL, MWORK.TMP_UNZIP
    LD  de, CLRTBL
    LD  bc, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  de, CLRTBL+32*8*8
    LD  bc, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  de, CLRTBL+32*8*8*2
    LD  bc, 32*8*8
    CALL    LDIRVM

    RET

;============================================
;::UPDATE_CAMERA
;============================================
UPDATE_CAMERA
    ; Locate the camera
    LD    hl, MWORK.THE_MAP
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    EX    de, hl
    LD    l, a
    LD    h, 0
    ADD   hl,hl   ;Mul64
    ADD   hl,hl
    ADD   hl,hl
    ADD   hl,hl
    ADD   hl,hl
    ADD   hl,hl
    ADD   hl, de

    ;X
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    LD    c, a
    LD    b, 0
    ADD   hl, bc
    LD    de, MWORK.CAMERA_SCREEN+K_CAMERA_LINES_OFFSET_UP*32
    LD    b, K_CAMERA_HEIGHT
.SLoopRows
    PUSH  bc
    LD    bc, K_CAMERA_WIDTH
    LDIR
    LD    bc, 32
    ADD   hl, bc
    POP   bc
    DJNZ  .SLoopRows
    RET


;============================================
;::RENDER
;=============================================
RENDER
    MRENDER_SCOREBOARD
    LD    a, [MWORK.ANIMATION_TICK]
    AND   3
    CP    0
    JP    z, .RenderAll

    HALT
    
    ;Render Sprites
    LD    hl, MWORK.SPRITES_TABLE
    LD    de, SPRATR
    LD    b, 51
    CALL  MSUPPORT.UFLDIRVM
    LD    hl, [MWORK.PLAYER_PATTERN]
    LD    de, SPRTBL
    LD    b, 68 
    CALL  MSUPPORT.UFLDIRVM
    RET

.RenderAll
    HALT
    ;Render Sprites
    LD    hl, MWORK.SPRITES_TABLE
    LD    de, SPRATR
    LD    b, 51
    CALL  MSUPPORT.UFLDIRVM
    LD    hl, [MWORK.PLAYER_PATTERN]
    LD    de, SPRTBL
    LD    b, 68 
    CALL  MSUPPORT.UFLDIRVM
  
    ;Render Tiles
    LD    hl, MWORK.CAMERA_SCREEN
    LD    de, NAMTBL
    LD    b, 48
    CALL  MSUPPORT.UFLDIRVM
    RET


;============================
;::RENDER_BACKGROUND_ENTITY
;  IN-> ix, de->Tiles
;============================
RENDER_BACKGROUND_ENTITY
    LD    a, [ix+ENTITY.K_OFFSET_X]
    SRL   a
    SRL   a
    SRL   a
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    ADD   b
    LD    [MWORK.TMP_X], a
    LD    a, [ix+ENTITY.K_OFFSET_Y]
    SUB   K_CAMERA_PIXELS_OFFSET_UP
    SRL   a
    SRL   a
    SRL   a
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    ADD   b
    LD    l, a
    LD    h, 0
    ADD   hl, hl ;*64
    ADD   hl, hl
    ADD   hl, hl
    ADD   hl, hl
    ADD   hl, hl
    ADD   hl, hl
    LD    a, [MWORK.TMP_X]
    LD    c, a
    LD    b, 0
    ADD   hl, bc
    LD    bc, MWORK.THE_MAP-64-1
    ADD   hl, bc
    LD    a, [de]
    LD    [hl], a
    INC   hl
    INC   de
    LD    a, [de]
    LD    [hl], a
    LD    bc, 63
    ADD   hl, bc
    INC   de
    LD    a, [de]
    LD    [hl], a
    INC   hl
    INC   de
    LD    a, [de]
    LD    [hl], a
    RET


;============================
;::RENDER_BACKGROOUND_DOOR_HOUSE
;  IN-> ix, de->Tiles
;============================
RENDER_BACKGROUND_DOOR_HOUSE
    LD    a, [ix+ENTITY.K_OFFSET_X]
    SRL   a
    SRL   a
    SRL   a
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    ADD   b
    LD    [MWORK.TMP_X], a
    LD    a, [ix+ENTITY.K_OFFSET_Y]
    SUB   K_CAMERA_PIXELS_OFFSET_UP
    SRL   a
    SRL   a
    SRL   a
    LD    b, a
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    ADD   b
    LD    l, a
    LD    h, 0
    ADD   hl, hl ;*64
    ADD   hl, hl
    ADD   hl, hl
    ADD   hl, hl
    ADD   hl, hl
    ADD   hl, hl
    LD    a, [MWORK.TMP_X]
    LD    c, a
    LD    b, 0
    ADD   hl, bc
    LD    bc, MWORK.THE_MAP-64*3-1
    ADD   hl, bc
    LD    a, [de]
    LD    [hl], a
    INC   hl
    INC   de
    LD    a, [de]
    LD    [hl], a
    LD    bc, 63
    ADD   hl, bc
    INC   de
    LD    a, [de]
    LD    [hl], a
    INC   hl
    INC   de
    LD    a, [de]
    LD    [hl], a
    RET

;=========================================
;::RENDER_SPRITES
;=========================================
RENDER_SPRITES
    LD    HL, MWORK.SPRITES_TABLE
    LD    de, SPRATR
    LD    b, 51
    CALL  MSUPPORT.UFLDIRVM
    LD    HL, [MWORK.PLAYER_PATTERN]
    LD    de, SPRTBL
    LD    b, 68 ;//Revisar pq solo escribe 2 bytes
    CALL  MSUPPORT.UFLDIRVM
    RET

;============================================
;::RENDER_LIVES
;   IN->de VRAM position, a Lives
;============================================
RENDER_LIVES
    LD    a, [MWORK.PLAYER_LIVES]
    LD    b, a
    SLA   a
    SLA   a
    ADD   b
    LD    c, a
    LD    b, 0
    LD    hl, SCORE_HEARTS
    ADD   hl, bc
    LD    bc, 5
    LDIR
    RET

SCORE_HEARTS
    DB  K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE ;0
    DB  K_HEART_MEDIUM_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE ;1
    DB  K_HEART_FULL_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE ;2
    DB  K_HEART_FULL_TILE, K_HEART_MEDIUM_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE ;3
    DB  K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE ;4
    DB  K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_MEDIUM_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE ;5
    DB  K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_EMPTY_TILE, K_HEART_EMPTY_TILE ;6
    DB  K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_MEDIUM_TILE, K_HEART_EMPTY_TILE ;7
    DB  K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_EMPTY_TILE ;8    
    DB  K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_MEDIUM_TILE ;9    
    DB  K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE, K_HEART_FULL_TILE ;10       
;=======================================
;::RENDER_BULLETS
;   IN->de VRAM position
;=======================================
RENDER_BULLETS
        LD      A, 230
        LD      [DE], A
        INC     DE
    ;
    LD    a, [MWORK.PLAYER_BULLETS]
    CP    MPLAYER.K_FIREBALL_COST
    JP    nc, .RenderFireballAllowed

    LD    b, a
    CP    8
    JP    c, .RenderUnits
    CP    16
    JP    c, .RenderOne
.RenderTwo
    LD    a, 198 ;FULL
    LD    [de], a
    LD    a, b
    SUB   8
    LD    b, a
    INC   de
.RenderOne
    LD    a, 198 ;FULL
    LD    [de], a
    LD    a, b
    SUB   8
    LD    b, a
    INC   de
.RenderUnits
    LD    a, b
    ADD   190 ;Zero
    LD    [de], a
    INC   de
    XOR   a
    LD    [de], a
    INC   de
    LD    [de], a
    RET

.RenderFireballAllowed
    LD    b, a
    CP    8
    JP    c, .RenderFireballRenderUnits
    CP    16
    JP    c, .RenderFireballRenderOne
.RenderFireballRenderTwo
    LD    a, 213 ;FULL
    LD    [de], a
    LD    a, b
    SUB   8
    LD    b, a
    INC   de
.RenderFireballRenderOne
    LD    a, 213 ;FULL
    LD    [de], a
    LD    a, b
    SUB   8
    LD    b, a
    INC   de
.RenderFireballRenderUnits
    LD    a, b
    ADD   205 ;Zero
    LD    [de], a
    INC   de
    XOR   a
    LD    [de], a
    INC   de
    LD    [de], a
    RET

;=========================================
;::RENDER_SURVIVORS
;   IN->de position
;=========================================
RENDER_SURVIVORS
    LD    a, [MWORK.SURVIVORS_TO_SAVE]
    CP    0
    RET   z
    SLA   a
    SLA   a
    LD    c, a
    LD    b, 0
    LD    hl, SURVIVORS_TILES-4
    ADD   hl, bc
    LD    bc, 3
    LDIR
    RET 

SURVIVORS_TILES
    DB  251, 0, 0, 0
    DB  251, 251, 0, 0
    DB  251, 251, 251, 0
    DB  251, 251, 251, 251

;=============================================
;::RENDER_POINTS
;   IN->de VRAM position, Points paremeters, hl->POINTS
;=============================================
RENDER_POINTS 
    LD    a, [hl]
    LD    b, a
    AND   0x0f
    ADD   K_NUMBER_ZERO_TILE
    LD    [de], a
    LD    a, b
    SRL   a
    SRL   a
    SRL   a
    SRL   a
    ADD   K_NUMBER_ZERO_TILE
    DEC   de
    LD    [de], a
    INC   hl
    LD    a, [hl] 
    LD    b, a
    AND   0x0f
    ADD   K_NUMBER_ZERO_TILE
    DEC   de
    LD    [de], a
    LD    a, b
    SRL   a
    SRL   a
    SRL   a
    SRL   a
    ADD   K_NUMBER_ZERO_TILE
    DEC   de
    LD    [de], a
    INC   hl
    LD    a, [hl] 
    LD    b, a
    AND   0x0f
    ADD   K_NUMBER_ZERO_TILE
    DEC   de
    LD    [de], a
    LD    a, b
    SRL   a
    SRL   a
    SRL   a
    SRL   a
    ADD   K_NUMBER_ZERO_TILE
    DEC   de
    LD    [de], a

    RET


;============================
;::TRATE_HI_SCORE
;============================
TRATE_HI_SCORE
                        LD      A, [MWORK.PLAYER_POINTS+2]
                        LD      HL, MWORK.HI_SCORE+2
                        CP      [HL]
                        RET     C     
                        JP      Z, .CONTINUE_CHECKING

.ASSIGN_HI_SCORE        LD      A, [MWORK.PLAYER_POINTS]
                        LD      HL, MWORK.HI_SCORE
                        LD      [HL], A
                        INC     HL
                        LD      A, [MWORK.PLAYER_POINTS+1]
                        LD      [HL], A
                        INC     HL
                        LD      A, [MWORK.PLAYER_POINTS+2]
                        LD      [HL], A
                        RET
                        
.CONTINUE_CHECKING      LD      A, [MWORK.PLAYER_POINTS+1]
                        LD      HL, MWORK.HI_SCORE+1
                        CP      [HL]
                        RET     C     
                        JP      NZ, .ASSIGN_HI_SCORE

                        LD      A, [MWORK.PLAYER_POINTS]
                        LD      HL, MWORK.HI_SCORE
                        CP      [HL]
                        RET     C     
                        JP      .ASSIGN_HI_SCORE




                        RET


                ENDMODULE

