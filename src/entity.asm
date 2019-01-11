                MODULE          ENTITY

                INCLUDE         "entity_macros.asm"

K_IS_UP                         EQU 0
K_IS_UP_RIGHT                   EQU 1
K_IS_RIGHT                      EQU 2
K_IS_DOWN_RIGHT                 EQU 3
K_IS_DOWN                       EQU 4
K_IS_DOWN_LEFT                  EQU 5
K_IS_LEFT                       EQU 6
K_IS_UP_LEFT                    EQU 7


;ENTITIES TYPES
K_ENTITY_PLAYER_SHOOT           EQU 1
K_ENTITY_EXIT_UP                EQU 2
K_ENTITY_EXIT_LEFT              EQU 3
K_ENTITY_EXIT_RIGHT             EQU 4
K_ENTITY_EXIT_DOWN              EQU 5
K_ENTITY_COUNTDOWN              EQU 6
K_ENTITY_CREATE_ZOMBIES_HOUSE   EQU 7
K_ENTITY_EXPLOSION              EQU 8
K_ENTITY_HEART                  EQU 9
K_ENTITY_COIN                   EQU 10
K_ENTITY_SURVIVOR               EQU 11
K_ENTITY_CREATE_ZOMBIES_TERRAIN EQU 12
K_ENTITY_ITEM_TRIPLE_SHOOT      EQU 13
K_ENTITY_PLAYER_SHOOT_FIREBALL  EQU 14
K_ENTITY_ITEM_NORMAL_SHOOT      EQU 15
K_ENTITY_ITEM_DOUBLE_SHOOT      EQU 16
K_ENTITY_ITEM_FIREBALL          EQU 17
K_END_OF_CONTROL_ENTITIES       EQU 18
K_ENTITY_ZOMBIE                 EQU 18
K_ZOMBIE_STANDARD               EQU 0
K_ZOMBIE_STRONG                 EQU 1

; ENTITY STRUCTURE
;TYPE                           0
K_OFFSET_IS_VISIBLE             EQU 1
K_OFFSET_Y                      EQU 2
K_OFFSET_X                      EQU 3
K_OFFSET_MAP_Y                  EQU 4
K_OFFSET_MAP_X                  EQU 5
K_OFFSET_INCREMENT_Y            EQU 4
K_OFFSET_INCREMENT_X            EQU 5
K_OFFSET_STATE                  EQU 6
K_OFFSET_CREATE_FREQUENCY       EQU 7
K_OFFSET_COUNTER                EQU 7
K_OFFSET_ZOMBIE_DIR             EQU 7
K_OFFSET_NOVISIBLE_COUNTER      EQU 8
K_OFFSET_SHOOTS_COUNT           EQU 9
K_OFFSET_TICK_REFRESH           EQU 10

K_NORMAL_SHOOT                  EQU 0
K_DOUBLE_SHOOT                  EQU 1
K_TRIPLE_SHOOT                  EQU 3

K_TICKS_TO_QUIT_ITEM            EQU 250
K_TICKS_TO_QUIT_NOVISIBLE       EQU 80

K_ZOMBIE_UP                     EQU 0
K_ZOMBIE_UP_RIGHT               EQU 1
K_ZOMBIE_RIGHT                  EQU 2
K_ZOMBIE_DOWN_RIGHT             EQU 3
K_ZOMBIE_DOWN                   EQU 4
K_ZOMBIE_DOWN_LEFT              EQU 5
K_ZOMBIE_LEFT                   EQU 6
K_ZOMBIE_UP_LEFT                EQU 7

K_TIME_ZERO_TILE                EQU 180

SPRITES_TABLE_SEQUENCES_COUNT   EQU 8
SPRITES_TABLE_SEQUENCES 
        DW  MWORK.SPRITES_TABLE_0, MWORK.SPRITES_TABLE_1, MWORK.SPRITES_TABLE_2, MWORK.SPRITES_TABLE_3, MWORK.SPRITES_TABLE_4, MWORK.SPRITES_TABLE_5, MWORK.SPRITES_TABLE_6, MWORK.SPRITES_TABLE_7, MWORK.SPRITES_TABLE_8, MWORK.SPRITES_TABLE_9, MWORK.SPRITES_TABLE_10, MWORK.SPRITES_TABLE_11
        DW  MWORK.SPRITES_TABLE_4, MWORK.SPRITES_TABLE_5, MWORK.SPRITES_TABLE_6, MWORK.SPRITES_TABLE_7, MWORK.SPRITES_TABLE_0, MWORK.SPRITES_TABLE_1, MWORK.SPRITES_TABLE_2, MWORK.SPRITES_TABLE_3, MWORK.SPRITES_TABLE_8, MWORK.SPRITES_TABLE_9, MWORK.SPRITES_TABLE_10, MWORK.SPRITES_TABLE_11
        DW  MWORK.SPRITES_TABLE_2, MWORK.SPRITES_TABLE_3, MWORK.SPRITES_TABLE_0, MWORK.SPRITES_TABLE_1, MWORK.SPRITES_TABLE_4, MWORK.SPRITES_TABLE_5, MWORK.SPRITES_TABLE_6, MWORK.SPRITES_TABLE_7, MWORK.SPRITES_TABLE_8, MWORK.SPRITES_TABLE_9, MWORK.SPRITES_TABLE_10, MWORK.SPRITES_TABLE_11
        DW  MWORK.SPRITES_TABLE_6, MWORK.SPRITES_TABLE_7, MWORK.SPRITES_TABLE_4, MWORK.SPRITES_TABLE_5, MWORK.SPRITES_TABLE_0, MWORK.SPRITES_TABLE_1, MWORK.SPRITES_TABLE_2, MWORK.SPRITES_TABLE_3, MWORK.SPRITES_TABLE_8, MWORK.SPRITES_TABLE_9, MWORK.SPRITES_TABLE_10, MWORK.SPRITES_TABLE_11
        DB  MWORK.K_EOF, MWORK.K_EOF

;====================================
;::RESETENTITIES
;======================================
RESET_ENTITIES
                LD              DE, MWORK.LIST_ENTITIES_DATA
                LD              BC, MWORK.K_ENTITIES_LENGTH*MWORK.K_DATA_PER_ENTITY
                CALL            MSUPPORT.RESET_BIG_RAM
                RET

;==========================================
;::GET_NEXT_EMPTY_INDESTRUCTIBLE
;   OUT->HL
;===========================================
GET_NEXT_EMPTY_INDESTRUCTIBLE
                                LD      HL, MWORK.LIST_INDESTRUCTIBLE_ENTITIES_DATA
.SLOOP                          LD      A, [HL]
                                CP      0
                                RET     Z
                                CP      MWORK.K_EOF
                                JP      Z, .SOVERFLOWASSERT
                                LD      BC, MWORK.K_DATA_PER_ENTITY
                                ADD     HL, BC
                                JP      .SLOOP

.SOVERFLOWASSERT                JR      .SOVERFLOWASSERT



;===================================
;::GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
;===================================
GET_NEXT_EMPTY_INDESTRUCTIBLE_IN_GAME
                                LD      HL, MWORK.LIST_SHOOTS
.SLOOP                          LD      A, [HL]
                                CP      0
                                RET     Z
                                CP      MWORK.K_EOF
                                JP      Z, .SOVERFLOWASSERT 
                                LD      BC, MWORK.K_DATA_PER_ENTITY
                                ADD     HL, BC
                                JP      .SLOOP

.SOVERFLOWASSERT                JR      .SOVERFLOWASSERT

;==========================================
;::GET_NEXT_EMPTY_DESTRUCTIBLE
;   OUT->HL, Z
;===========================================
GET_NEXT_EMPTY_DESTRUCTIBLE
                                LD      A, [MWORK.CURRENT_NUMBER_OF_ZOMBIES]
                                CP      MWORK.K_MAX_NUMBER_OF_ZOMBIES
                                JP      Z, SNOFREESPACE
                                INC     A
                                LD      [MWORK.CURRENT_NUMBER_OF_ZOMBIES], A
                                LD      HL, MWORK.LIST_DESTRUCTIBLE_ENTITIES_DATA
                                LD      BC, MWORK.K_DATA_PER_ENTITY
.SLOOP
                                LD      A, [HL]
                                CP      0
                                RET     Z

.ASSERT                         CP      MWORK.K_EOF       
                                JR      Z, .ASSERT
                                
                                ADD     HL, BC
                                JP      .SLOOP

SNOFREESPACE                    XOR     A
                                CP      1
                                RET


;================================
;::CHECK_IF_VISIBLE
;   IX POINTER TO DATA
;================================
CHECK_IF_VISIBLE
                                LD      A, [MWORK.CAMERA_TILE_X_LEFT]
                                LD      B, [IX+K_OFFSET_MAP_X]
                                CP      B
                                RET     NC
                                LD      A, [MWORK.CAMERA_TILE_X_RIGHT]
                                CP      B
                                RET     C
                                LD      A, [MWORK.CAMERA_TILE_Y_TOP]
                                LD      B, [IX+K_OFFSET_MAP_Y]
                                CP      B
                                RET     NC
                                LD      A, [MWORK.CAMERA_TILE_Y_DOWN]
                                CP      B
                                RET     C

                                ;NOT VISIBLE TO VISIBLE
                                LD      [IX+K_OFFSET_IS_VISIBLE], 1
                                LD      A, [MWORK.CAMERA_TILE_X_LEFT]
                                LD      B, A
                                LD      A, [IX+K_OFFSET_MAP_X]
                                SUB     B
                                SLA     A
                                SLA     A
                                SLA     A
                                LD      [IX+K_OFFSET_X], A
                                LD      A, [MWORK.CAMERA_TILE_Y_TOP]
                                LD      B, A
                                LD      A, [IX+K_OFFSET_MAP_Y]
                                SUB     B
                                SLA     A
                                SLA     A
                                SLA     A
                                ADD     MSCREEN.K_CAMERA_LINES_OFFSET_UP*8
                                LD      [IX+K_OFFSET_Y], A
                                RET

;=====================================
;::GET_NEXT_INDEX_SPRITE_HL
;   OUT->HL NEXTLISTINDEX
;====================================
GET_NEXT_INDEX_SPRITE_HL
                                PUSH    DE
                                LD      HL, [MWORK.CURRENT_SPRITES_TABLE_POSITION]
                                LD      E, [HL]
                                INC     HL
                                LD      D, [HL]
                                INC     HL
                                LD      [MWORK.CURRENT_SPRITES_TABLE_POSITION], HL
                                EX      DE, HL
                                POP     DE
                                RET

;=====================================
;::GET_NEXT_INDEX_SPRITE_DE
;   OUT->DE NEXTLISTINDEX
;====================================
GET_NEXT_INDEX_SPRITE_DE
                                PUSH    HL
                                LD      HL, [MWORK.CURRENT_SPRITES_TABLE_POSITION]
                                LD      E, [HL]
                                INC     HL
                                LD      D, [HL]
                                INC     HL
                                LD      [MWORK.CURRENT_SPRITES_TABLE_POSITION], HL
                                POP     HL
                                RET


;=======================================
;::TRATE_ENTITIES
;========================================
TRATE_ENTITIES
                                LD      B, MWORK.K_ENTITIES_LENGTH 
                                LD      IX, MWORK.LIST_ENTITIES_DATA
TRATEENTITIES_LOOP              PUSH    BC
                                LD      A, [IX] ;TYPE
                                CP      0
                                JP      Z, END_TRATE_ENTITY
                                SLA     A
                                LD      C, A
                                LD      B, 0
                                LD      HL, TRATE_ENTITIES_TABLE
                                ADD     HL, BC
                                LD      E, [HL]
                                INC     HL
                                LD      D, [HL]
                                EX      DE, HL
                                JP      HL

END_TRATE_ENTITY                LD      BC, MWORK.K_DATA_PER_ENTITY
                                ADD     IX, BC
                                POP     BC
                                DJNZ    TRATEENTITIES_LOOP

TRATEENTITIES_FINISH            RET

TRATE_ENTITIES_TABLE
    DW    0, TRATE_PLAYER_SHOOT, TRATE_EXIT, TRATE_EXIT, TRATE_EXIT
    DW    TRATE_EXIT, TRATE_COUNT_DOWN, TRATE_CREATE_ZOMBIES, TRATE_EXPLOSION, TRATE_HEART
    DW      TRATE_COIN, TRATE_SURVIVOR, TRATE_CREATE_ZOMBIES, TRATE_ITEM_SHOOT, TRATE_FIREBALL_SHOOT
    DW   TRATE_ITEM_SHOOT, TRATE_ITEM_SHOOT, TRATE_ITEM_SHOOT, TRATE_ZOMBIE


;================================
;::TRATE_FIREBALL_SHOOT
;===============================
TRATE_FIREBALL_SHOOT
                                LD      A,[IX+K_OFFSET_X]
                                ADD     [IX+K_OFFSET_INCREMENT_X]
                                LD      [IX+K_OFFSET_X], A
                                LD      B, A
                                LD      A, [IX+K_OFFSET_Y]
                                ADD     [IX+K_OFFSET_INCREMENT_Y]
                                LD      [IX+K_OFFSET_Y], A
                                LD      C, A
                                LD      A, 4
                                CP      B
                                JP      NC, .QUITSHOOT
                                CP      C
                                JP      NC, .QUITSHOOT
                                LD      A, 31*8-4
                                CP      B
                                JP      C, .QUITSHOOT
                                LD      A, 23*8-4
                                CP      C
                                JP      C, .QUITSHOOT

                                CALL    MSUPPORT.YX_TO_OFFSET
                                LD      HL, MWORK.CAMERA_SCREEN
                                ADD     HL, DE
                                LD      A, [HL]
                                CP      MPLAYER.K_SOLID_TILE
                                JP      NC, .QUITSHOOT

                                CALL    CHECK_IF_PLAYER_SHOOT_KILLS
                                JP      Z, .EXPLODEZOMBIE

                                CALL    ENTITY.GET_NEXT_INDEX_SPRITE_DE
                                LD      A, [IX+K_OFFSET_Y]   ;Y
                                ADD     -8
                                LD      [DE], A
                                LD      A, [IX+K_OFFSET_X]   ;X
                                ADD     -8
                                INC     DE
                                LD      [DE], A
                                INC     DE
                                LD      A, 24
                                LD      [DE], A
                                INC     DE
                                LD      A, 15
                                LD      [DE], A     ;COLOR
                                JP      END_TRATE_ENTITY

.EXPLODEZOMBIE                  LD      [HL], K_ENTITY_EXPLOSION
                                LD      BC, K_OFFSET_STATE
                                ADD     HL, BC
                                LD      [HL], 0
                                LD      A, 1
                                LD      HL, MWORK.PLAYER_POINTS
                                CALL    ADD_POINTS
                                JP      END_TRATE_ENTITY

.QUITSHOOT                      LD      [IX], 0

                                MDEC_CURRENT_NUMBER_OF_SHOOTS

                                JP      END_TRATE_ENTITY

;==================================
;::TRATE_PLAYER_SHOOT
;==================================
TRATE_PLAYER_SHOOT
                                LD      A,[IX+K_OFFSET_X]
                                ADD     [IX+K_OFFSET_INCREMENT_X]
                                LD      [IX+K_OFFSET_X], A
                                LD      B, A
                                LD      A, [IX+K_OFFSET_Y]
                                ADD     [IX+K_OFFSET_INCREMENT_Y]
                                LD      [IX+K_OFFSET_Y], A
                                LD      C, A
                                LD      A, 4
                                CP      B
                                JP      NC, .QUITSHOOT
                                CP      C
                                JP      NC, .QUITSHOOT
                                LD      A, 31*8-4
                                CP      B
                                JP      C, .QUITSHOOT
                                LD      A, 23*8-4
                                CP      C
                                JP      C, .QUITSHOOT

                                CALL    MSUPPORT.YX_TO_OFFSET
                                LD      HL, MWORK.CAMERA_SCREEN
                                ADD     HL, DE
                                LD      A, [HL]
                                CP      MPLAYER.K_SOLID_TILE
                                JP      NC, .QUITSHOOT

                                CP      MPLAYER.K_ITEMS_TILES
                                JP      C, .CONTINUE
                                CP      MPLAYER.K_ZOMBIES_TILES
                                JP      NC, .CONTINUE
                                CALL    CHECK_IF_PLAYER_SHOOT_KILLS
                                JP      Z, .CHECKEXPLODEZOMBIE
    
.CONTINUE                       CALL    ENTITY.GET_NEXT_INDEX_SPRITE_DE
                                LD      A, [IX+K_OFFSET_Y]   ; Y
                                ADD     -8
                                LD      [DE], A
                                LD      A, [IX+K_OFFSET_X]   ; X
                                ADD     -8
                                INC     DE
                                LD      [DE], A
                                INC     DE
                                LD      A, 32   ; SPRITE
                                LD      [DE], A
                                INC     DE
                                LD      A, 15
                                LD      [DE], A     ;COLOR
                                JP      END_TRATE_ENTITY

.CHECKEXPLODEZOMBIE             LD      [IX], 0 ; QUIT SHOOT
    
                                MDEC_CURRENT_NUMBER_OF_SHOOTS

                                PUSH    HL ; SAVE POINTER TO KILLED ZOMBIE
                                LD      BC, K_OFFSET_SHOOTS_COUNT
                                ADD     HL, BC
                                LD      B, [HL]
                                LD      A, [MWORK.SHOOTS_TO_KILL_ZOMBIE]
                                CP      B
                                JP      NZ, .ADDCOLLISIONTOZOMBIE

                                LD      A, 1
                                LD      HL, MWORK.PLAYER_POINTS
                                CALL    ADD_POINTS
                                POP   HL
.QUITZOMBIE
                                ;BONUS ITEM?
                                LD      A, [MWORK.ANIMATION_TICK]
                                LD      B, A
                                AND     31
                                CP      28
                                JP      NC, .ADDWEAPON
                                LD      A, B
                                AND     15
                                CP      15
                                JP      Z, .ADDHEART
                                LD      A, B
                                AND     3
                                CP      3
                                JP      NZ, .QUITWITHEXPLOSION

.ADDCOIN                        LD      [HL], K_ENTITY_COIN
                                LD      BC, K_OFFSET_STATE
                                ADD     HL, BC
                                LD      [HL], 23
                                INC     HL
                                LD      [HL], 0 ; COUNTER
                                INC     HL
                                LD      [HL], 0 ; VISIBLE_COUNTER
                                JP      END_TRATE_ENTITY

.ADDHEART                       LD      [HL], K_ENTITY_HEART
                                LD      BC, K_OFFSET_STATE
                                ADD     HL, BC
                                LD      [HL], 115
                                INC     HL
                                LD      [HL], 0 ;COUNTER
                                INC     HL
                                LD      [HL], 0 ;VISIBLE_COUNTER
                                JP      END_TRATE_ENTITY

.ADDWEAPON                      LD      A, [MWORK.PLAYER_POINTS] ;RANDOM...
                                AND     3
                                CP      0
                                JP      Z, .ADDNORMALSHOOTITEM
                                CP      1
                                JP      Z, .ADDDOUBLESHOOTITEM

.ADDTRIPLESHOOTITEM             LD      [HL], K_ENTITY_ITEM_TRIPLE_SHOOT
                                LD      BC, K_OFFSET_STATE
                                ADD     HL, BC
                                LD      [HL], 0
                                INC     HL
                                LD      [HL], 0
                                JP      END_TRATE_ENTITY

.ADDDOUBLESHOOTITEM             LD      [HL], K_ENTITY_ITEM_DOUBLE_SHOOT
                                LD      BC, K_OFFSET_STATE
                                ADD     HL, BC
                                LD      [HL], 0
                                INC     HL
                                LD      [HL], 0
                                JP      END_TRATE_ENTITY

.ADDNORMALSHOOTITEM             LD      [HL], K_ENTITY_ITEM_DOUBLE_SHOOT
                                LD      BC, K_OFFSET_STATE
                                ADD     HL, BC
                                LD      [HL], 0
                                INC     HL
                                LD      [HL], 0
                                JP      END_TRATE_ENTITY

.QUITWITHEXPLOSION              LD      [HL], K_ENTITY_EXPLOSION
                                LD      BC, K_OFFSET_STATE
                                ADD     HL, BC
                                LD      [HL], 0
                                JP      END_TRATE_ENTITY

.QUITSHOOT                      LD      [IX], 0
                                MDEC_CURRENT_NUMBER_OF_SHOOTS
                                JP      END_TRATE_ENTITY

.ADDCOLLISIONTOZOMBIE            INC     [HL]
                                POP     HL
                                LD      [IX], 0 
                                JP      END_TRATE_ENTITY


;====================================
;::CHECK_IF_PLAYER_SHOOT_KILLS
;    IN->IX ENTITY
;    OUT-> Z IF TRUE, HL POINT TO TYPE
;=====================================*
CHECK_IF_PLAYER_SHOOT_KILLS
    LD    D, [IX+K_OFFSET_X]
    LD    E, [IX+K_OFFSET_Y]
    LD    [MWORK.CHECK_COLISION_POS], DE
    LD    HL, MWORK.LIST_DESTRUCTIBLE_ENTITIES_DATA
    LD    B, MWORK.K_MAX_NUMBER_OF_ZOMBIES
.SLOOP
    PUSH  BC
    LD    A, [HL]
    CP    ENTITY.K_END_OF_CONTROL_ENTITIES
    JP    C, .SNEXT
    INC   HL  ;ISVISIBLE
    LD    A, [HL]
    CP    0
    JP    Z, .SNEXTCAUSENOVISIBLE
    INC   HL  ;Y
    LD    C, [HL]
    INC   HL  ;X
    LD    B, [HL]
    LD    A, [IX]
    CP    K_ENTITY_PLAYER_SHOOT_FIREBALL
    JP    Z, .TRATESHOOTFIREBALL
 
    LD    DE, [MWORK.CHECK_COLISION_POS] 
    CALL  IS_COLISION_PLAYER_SHOOT_ENTITY
    JP    Z, .SRETYES
    LD    BC, MWORK.K_DATA_PER_ENTITY - 3
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP
    JP    .SEXIT

.TRATESHOOTFIREBALL
    LD    DE, [MWORK.CHECK_COLISION_POS]
    CALL  IS_COLISION_PLAYER_BIG_SHOOT_ENTITY
    JP    Z, .SRETYES
    LD    BC, MWORK.K_DATA_PER_ENTITY - 3
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP
    JP    .SEXIT

.SNEXT
    LD    BC, MWORK.K_DATA_PER_ENTITY
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP
    JP    .SEXIT

.SNEXTCAUSENOVISIBLE
    LD    BC, MWORK.K_DATA_PER_ENTITY - 1
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP

.SEXIT
    XOR   A
    CP    1
    RET   ;RET NO

.SRETYES
    POP   BC
    DEC   HL  ;Y
    DEC   HL  ;ISVISIBLE
    DEC   HL  ;ENTITY
    XOR   A
    CP    0
    RET

;===================================
;::ADD_POINTS
;   A->POINTS TO ADD, HL->POINTS
;===================================
ADD_POINTS
    ADD   A, [HL]
    DAA
    LD    [HL], A
    INC   HL
    LD    A, 0
    ADC   A, [HL]
    DAA
    LD    [HL], A
    INC   HL
    LD    A, 0
    ADC   A, [HL]
    DAA
    LD    [HL], A
    RET

;====================================
;::IS_COLISION_PLAYER_LITTLE_ENTITY
;    IN-> DE PLAYER [YX], IX
;    OUT->Z COLLISION
;=====================================
IS_COLISION_PLAYER_LITTLE_ENTITY
.K_PLAYER_WIDTH EQU 7
.K_ENTITY_WIDTH EQU 4
    PUSH   IX
    POP    HL
    INC    HL
    INC    HL
    ; Y
    LD     A, -.K_PLAYER_WIDTH
    ADD    E
    LD     E, A
    LD     A, .K_ENTITY_WIDTH
    ADD    [HL] ;Y
    CP     E
    JP     C, .SRETNO1

    LD     A, .K_PLAYER_WIDTH*2
    ADD    E
    LD     E, A
    LD     A, -.K_ENTITY_WIDTH*2
    ADD    [HL] ;Y
    CP     E
    JP     NC, .SRETNO1
    
    ; X
    INC    HL ;X
    LD     A, -.K_PLAYER_WIDTH
    ADD    D
    LD     D, A
    LD     A, .K_ENTITY_WIDTH
    ADD    [HL] ;X
    CP     D
    JP     C, .SRETNO2

    LD     A, .K_PLAYER_WIDTH*2
    ADD    D
    LD     D, A
    LD     A, -.K_ENTITY_WIDTH*2
    ADD    [HL] ;X
    CP     D
    JP     NC, .SRETNO2
.SRETYES
    XOR    A
    CP     0
    RET
.SRETNO1
    INC    HL
.SRETNO2
    XOR    A
    CP     1
    RET


;=======================================
;::IS_COLISION_PLAYER_EXIT
;       IX
;=======================================
IS_COLISION_PLAYER_EXIT
    LD    DE, [MWORK.CAMERA_TILE_Y_TOP] ; D=XLEFT, E=YTOP
    LD    A, [MWORK.PLAYER_Y]    ;PUT PLAYER ON MAP
    SRL   A   ;DIV8
    SRL   A
    SRL   A
    SUB   MSCREEN.K_CAMERA_LINES_OFFSET_UP
    ADD   E
    LD    L, A
    LD    H, 0
    ADD   HL, HL ;*64
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    LD    A, [MWORK.PLAYER_X]
    SRL   A
    SRL   A
    SRL   A
    ADD   D
    LD    C, A
    LD    B, 0
    ADD   HL, BC
    LD    BC, MWORK.THE_MAP
    ADD   HL, BC
    LD    A, [HL] ;GET THE TILE WHERE THE PLAYER IS
    CP    7   ;FIRST TILE WITH ARROW
    JP    C, .RETNO
    CP    23  ;LAST TILE WITH ARROW+1
    JP    NC, .RETNO
.RETYES
    XOR   A
    CP    0
    RET
.RETNO
    XOR   A
    CP    1
    RET



;*====================================
;::IS_COLISION_PLAYER_ENTITY
;    IN-> DE PLAYER [YX], IX
;    OUT->Z COLLISION
;=====================================
IS_COLISION_PLAYER_ENTITY   
        ;8, 6)
.K_PLAYER_WIDTH EQU 4
.K_ENTITY_WIDTH EQU 4
    PUSH   IX
    POP    HL
    INC    HL
    INC    HL
    ; Y
    LD     A, -.K_PLAYER_WIDTH
    ADD    E
    LD     E, A
    LD     A, .K_ENTITY_WIDTH
    ADD    [HL] ;Y
    CP     E
    JP     C, .SRETNO1
    
    LD     A, .K_PLAYER_WIDTH*2
    ADD    E
    LD     E, A
    LD     A, -.K_ENTITY_WIDTH*2
    ADD    [HL] ;Y
    CP     E
    JP     NC, .SRETNO1

    ;X
    INC    HL 
    LD     A, -.K_PLAYER_WIDTH
    ADD    D
    LD     D, A
    LD     A, .K_ENTITY_WIDTH
    ADD    [HL] ;X
    CP     D
    JP     C, .SRETNO2

    LD     A, .K_PLAYER_WIDTH*2
    ADD    D
    LD     D, A
    LD     A, -.K_ENTITY_WIDTH*2
    ADD    [HL] ;X
    CP     D
    JP     NC, .SRETNO2

.SRETYES
    XOR    A
    CP     0
    RET
.SRETNO1
    INC    HL
.SRETNO2
    XOR    A
    CP     1
    RET  


;=====================================
;::IS_COLISION_PLAYER_SHOOT_ENTITY
;   IN-> DE PLAYER SHOOT [YX], BC [YX]
;   OUT->Z COLLISION
;=====================================
IS_COLISION_PLAYER_SHOOT_ENTITY
        ;4,8
.K_SHOOT_WIDTH  EQU 5
.K_ENTITY_WIDTH EQU 8
    LD    A, -.K_SHOOT_WIDTH
    ADD   D
    LD    D, A    ;IZQUIERDA FIRST
    LD    A, .K_ENTITY_WIDTH
    ADD   B       ;DERECHA SECOND
    CP    D
    JP    C, .SRETNO

    SUB   .K_ENTITY_WIDTH*2 ;IZQUIERDA SECOND
    LD    B, A
    LD    A, .K_SHOOT_WIDTH*2 ;DERECHA FIRST
    ADD   D
    CP    B
    JP    C, .SRETNO

    LD    A, -.K_SHOOT_WIDTH
    ADD   E
    LD    E, A    ;ARRIBA FIRST
    LD    A, .K_ENTITY_WIDTH
    ADD   C   ;ABAJO SECOND
    CP    E
    JP    C, .SRETNO

    SUB   .K_ENTITY_WIDTH*2 ;ARRIBA SECOND
    LD    C, A
    LD    A, .K_SHOOT_WIDTH*2 ;ABAJO FIRST
    ADD   E
    CP    C
    JP    C, .SRETNO

.SRETYES
    XOR   A
    CP    0
    RET
.SRETNO
    XOR   A
    CP  1
    RET

;=====================================
;::IS_COLISION_PLAYER_BIG_SHOOT_ENTITY
;   IN-> DE PLAYER SHOOT [YX], BC [YX]
;   OUT->Z COLLISION
;=====================================
IS_COLISION_PLAYER_BIG_SHOOT_ENTITY
.K_SHOOT_WIDTH  EQU 8
.K_ENTITY_WIDTH EQU 8
    LD    A, -.K_SHOOT_WIDTH
    ADD   D
    LD    D, A    ;IZQUIERDA FIRST
    LD    A, .K_ENTITY_WIDTH
    ADD   B       ;DERECHA SECOND
    CP    D
    JP    C, .SRETNO

    SUB   .K_ENTITY_WIDTH*2 ;IZQUIERDA SECOND
    LD    B, A
    LD    A, .K_SHOOT_WIDTH*2 ;DERECHA FIRST
    ADD   D
    CP    B
    JP    C, .SRETNO

    LD    A, -.K_SHOOT_WIDTH
    ADD   E
    LD    E, A    ;ARRIBA FIRST
    LD    A, .K_ENTITY_WIDTH
    ADD   C   ;ABAJO SECOND
    CP    E
    JP    C, .SRETNO

    SUB   .K_ENTITY_WIDTH*2 ;ARRIBA SECOND
    LD    C, A
    LD    A, .K_SHOOT_WIDTH*2 ;ABAJO FIRST
    ADD   E
    CP    C
    JP    C, .SRETNO
.SRETYES
    XOR   A
    CP    0
    RET
.SRETNO
    XOR   A
    CP    1
    RET


;==================================
;::TRATE_CREATE_ZOMBIES
;==================================
TRATE_CREATE_ZOMBIES
    LD    A, [IX+K_OFFSET_IS_VISIBLE]
    CP    0
    JP    Z, END_TRATE_ENTITY

    LD    A, [IX+ENTITY.K_OFFSET_STATE]
    CP    1
    JP    NZ, .TRATECREATIONSEQUENCE

    LD    B, [IX+K_OFFSET_CREATE_FREQUENCY]
    LD    A, [MWORK.ANIMATION_TICK]
    AND   B
    CP    B
    JP    NZ, .RENDERCLOSEDDOOR

.TRATECREATIONSEQUENCE
    LD    A, [IX+K_OFFSET_STATE]
    INC   [IX+K_OFFSET_STATE]
    LD    A, [IX+K_OFFSET_STATE]
    CP    50
    JP    Z, .CREATEZOMBIE
    CP    100
    JP    C, .RENDEROPENDOOR
    LD    [IX+ENTITY.K_OFFSET_STATE], 1 
.RENDERCLOSEDDOOR
    LD    A, [IX]
    CP    K_ENTITY_CREATE_ZOMBIES_HOUSE
    JP    Z, .RENDERCLOSEDDOORHOUSE
.RENDERCLOSEDDOORTERRAIN
    LD    DE, CLOSED_DOOR_TERRAIN_TILES
    CALL  MSCREEN.RENDER_BACKGROUND_ENTITY
    JP    END_TRATE_ENTITY

.RENDERCLOSEDDOORHOUSE
    LD    DE, CLOSED_DOOR_HOUSE_TILES
    CALL  MSCREEN.RENDER_BACKGROUND_DOOR_HOUSE
    JP    END_TRATE_ENTITY
.RENDEROPENDOOR
    LD    A, [IX]
    CP    K_ENTITY_CREATE_ZOMBIES_HOUSE
    JP    Z, .RENDEROPENDOORHOUSE
.RENDEROPENDOORTERRAIN
    LD    DE, OPEN_DOOR_TERRAIN_TILES
    CALL  MSCREEN.RENDER_BACKGROUND_ENTITY
    JP    END_TRATE_ENTITY

.RENDEROPENDOORHOUSE
    LD    DE, OPEN_DOOR_HOUSE_TILES
    CALL  MSCREEN.RENDER_BACKGROUND_DOOR_HOUSE
    JP    END_TRATE_ENTITY

.CREATEZOMBIE
    LD    B, [IX+K_OFFSET_X]
    LD    C, [IX+K_OFFSET_Y]
    CALL  MSUPPORT.YX_TO_OFFSET
    LD    HL, MWORK.CAMERA_SCREEN-33
    ADD   HL, DE
    
    ; MIRA SI HAY ALGUNO YA PARA NO PISARLO
    CALL  IS_FREE_OF_ZOMBIE
    JP    NZ, .RENDEROPENDOOR
    CALL  GET_NEXT_EMPTY_DESTRUCTIBLE
    JP    NZ, .RENDEROPENDOOR

    LD    [HL], K_ENTITY_ZOMBIE
    INC   HL
    LD    [HL], 1
    INC   HL
    LD    A, [IX+K_OFFSET_Y]
    LD    [HL], A
    INC   HL
    LD    A, [IX+K_OFFSET_X]
    LD    [HL], A
    INC   HL
    INC   HL
    INC   HL
    LD    [HL], 0 ;STATE
    INC   HL

    ; DIRECCION
    LD    A, [IX+K_OFFSET_X]
    CP    16
    JP    NC, .LOOKLEFT

    LD    [HL], MPLAYER.K_KEY_RIGHT
    JP   .CONTINUECREATING

.LOOKLEFT
    LD   [HL], MPLAYER.K_KEY_LEFT
.CONTINUECREATING
    INC  HL
    LD   [HL], 0 ;NO VISIBLE COUNTER
    INC  HL
    LD   [HL], 0 ;SHOOTS COUNT
    JP  .RENDEROPENDOOR

OPEN_DOOR_TERRAIN_TILES
    DB 29, 30, 31, 112
CLOSED_DOOR_TERRAIN_TILES
    DB 125, 126, 127, 113
CLOSED_DOOR_HOUSE_TILES
    DB  154, 155, 158, 159
OPEN_DOOR_HOUSE_TILES
    DB  224, 225, 226, 227

;==========================================
;::IS_FREE_OF_ZOMBIE
;             IN->IX ENTE ACTUAL
;==========================================
IS_FREE_OF_ZOMBIE
    LD    A, [IX]
    PUSH  AF
    LD    [IX], 0 ;ANULA MOMENTANEAMENTE EL ACTUAL
    LD    A, [IX+K_OFFSET_Y]
    LD    [MWORK.TMP_Y], A
    LD    A, [IX+K_OFFSET_X]
    LD    [MWORK.TMP_X], A
    LD    HL, MWORK.LIST_DESTRUCTIBLE_ENTITIES_DATA
    LD    B, MWORK.K_MAX_NUMBER_OF_ZOMBIES
.SLOOP
    PUSH  BC
    LD    A, [HL]
    CP    K_END_OF_CONTROL_ENTITIES
    JP    C, .SNEXT
    
    ; MIRA SI HAY OTRO
    INC   HL  ;OFFSET_IS_VISIBLE
    LD    A, [HL]
    CP    0
    JP    Z, .SNEXTFROMVISIBLE

    INC   HL  ; Y
    LD    A, [MWORK.TMP_Y]
    ADD   15
    CP    [HL]
    JP    C, .SNEXTFROMY
    SUB   30
    CP    [HL]
    JP    NC, .SNEXTFROMY

    ; X
    INC   HL
    LD    A, [MWORK.TMP_X]
    ADD   15
    CP    [HL]
    JP    C, .SNEXTFROMX
    SUB   30
    CP    [HL]
    JP    NC, .SNEXTFROMX
    JP    .SFOUNDRETNO

.SNEXT
    LD    BC, MWORK.K_DATA_PER_ENTITY
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP
    JP   .SRETYES

.SNEXTFROMX
    LD    BC, MWORK.K_DATA_PER_ENTITY - 3
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP
    JP    .SRETYES

.SNEXTFROMY
    LD    BC, MWORK.K_DATA_PER_ENTITY - 2
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP
    JP    .SRETYES

.SNEXTFROMVISIBLE
    LD    BC, MWORK.K_DATA_PER_ENTITY - 1
    ADD   HL, BC
    POP   BC
    DJNZ  .SLOOP
    JP    .SRETYES

.SFOUNDRETNO
    POP   BC
.SRETNO
    POP   AF
    LD    [IX], A
    XOR   A
    CP    1
    RET

.SRETYES
    POP   AF
    LD    [IX], A
    XOR   A
    CP    0
    RET

;====================================
;::TRATE_ZOMBIE
;====================================
TRATE_ZOMBIE
    LD    A, [IX+K_OFFSET_IS_VISIBLE]
    CP    0
    JP    NZ, .CONTINUE
    INC   [IX+K_OFFSET_NOVISIBLE_COUNTER]
    LD    A, [IX+K_OFFSET_NOVISIBLE_COUNTER]
    CP    K_TICKS_TO_QUIT_NOVISIBLE
    JP    NZ, END_TRATE_ENTITY
    
    ;QUIT ZOMBIE
    LD    [IX], 0
    MDEC_CURRENT_NUMBER_OF_ZOMBIES
    JP    END_TRATE_ENTITY

.CONTINUE
    LD    DE, [MWORK.PLAYER_Y]
    CALL  IS_COLISION_PLAYER_ENTITY
    JP    Z, TRATEZOMBIE_TRATECOLISIONPLAYER

    LD    A, [MWORK.ZOMBIES_ANIMATION_TICK]
    CP    [IX+K_OFFSET_TICK_REFRESH]
    JP    NZ, TRATE_ZOMBIE_RENDER

    LD    B, [IX+K_OFFSET_X]
    LD    C, [IX+K_OFFSET_Y]
    LD    [MWORK.TRATE_ZOMBIE_PREV_POS], BC

    CALL  WHERE_IS_PLAYER
    CP    K_IS_RIGHT
    JP    Z, .RIGHT
    CP    K_IS_LEFT
    JP    Z, .LEFT
    CP    K_IS_UP
    JP    Z, .UP
    CP    K_IS_DOWN
    JP    Z, .DOWN
    CP    K_IS_DOWN_RIGHT
    JP    Z, .DOWNRIGHT
    CP    K_IS_DOWN_LEFT
    JP    Z, .DOWNLEFT
    CP    K_IS_UP_RIGHT
    JP    Z, .UPRIGHT

.UPLEFT
    LD    A, K_ZOMBIE_UP_LEFT
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    LD    [IX+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_UP_LEFT
    LD    A, [IX+K_OFFSET_Y]
    SUB   8
    LD    C, A
    LD    [IX+K_OFFSET_Y], C
    LD    A, [IX+K_OFFSET_X]
    SUB   8
    LD    B, A
    LD    [IX+K_OFFSET_X], B
    LD    [MWORK.PARAM_CAN_GO_Y], BC
    CALL  MPLAYER.CAN_GO
    CALL  Z, IS_FREE_OF_ZOMBIE
    JP    Z, TRATE_ZOMBIE_RENDER

    ; NO PUEDE IR. LO DEJA DONDE ESTABA
    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_UP
    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_LEFT
    JP  TRATEZOMBIE_UNDO

.UPRIGHT
    LD    A, K_ZOMBIE_UP_RIGHT
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    LD    [IX+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_UP_RIGHT
    LD    A, [IX+K_OFFSET_Y]
    SUB   8
    LD    C, A
    LD    [IX+K_OFFSET_Y], C
    LD    A, [IX+K_OFFSET_X]
    ADD   8
    LD    B, A
    LD    [IX+K_OFFSET_X], B
    LD    [MWORK.PARAM_CAN_GO_Y], BC
    CALL  MPLAYER.CAN_GO
    CALL  Z, IS_FREE_OF_ZOMBIE
    JP    Z, TRATE_ZOMBIE_RENDER

    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_UP
    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_RIGHT
    JP  TRATEZOMBIE_UNDO

.LEFT
    LD    A, K_ZOMBIE_LEFT
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    MMOVE_ZOMBIE_LEFT
    JP    TRATEZOMBIE_UNDO

.RIGHT
    LD    A, K_ZOMBIE_RIGHT
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    MMOVE_ZOMBIE_RIGHT
    JP    TRATEZOMBIE_UNDO

.UP
    LD    A, K_ZOMBIE_UP
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    MMOVE_ZOMBIE_UP
    JP    TRATEZOMBIE_UNDO

.DOWN
    LD    A, K_ZOMBIE_DOWN
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    MMOVE_ZOMBIE_DOWN
    JP    TRATEZOMBIE_UNDO

.DOWNLEFT
    LD    A, K_ZOMBIE_DOWN_LEFT
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    LD    [IX+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_DOWN_LEFT
    LD    A, [IX+K_OFFSET_X]
    SUB   8
    LD    B, A
    LD    [IX+K_OFFSET_X], B
    LD    A, [IX+K_OFFSET_Y]
    ADD   8
    LD    C, A
    LD    [IX+K_OFFSET_Y], C
    LD    [MWORK.PARAM_CAN_GO_Y], BC
    CALL  MPLAYER.CAN_GO
    CALL  Z, IS_FREE_OF_ZOMBIE
    JP    Z, TRATE_ZOMBIE_RENDER

    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_DOWN
    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_LEFT
    JP    TRATEZOMBIE_UNDO

.DOWNRIGHT
    LD    A, K_ZOMBIE_DOWN_RIGHT
    LD    [MWORK.TRATE_ZOMBIE_FIRST_OPTION], A
    LD    [IX+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_DOWN_RIGHT
    LD    A, [IX+K_OFFSET_X]
    ADD   8
    LD    B, A
    LD    [IX+K_OFFSET_X], B
    LD    A, [IX+K_OFFSET_Y]
    ADD   8
    LD    C, A
    LD    [IX+K_OFFSET_Y], C
    LD    [MWORK.PARAM_CAN_GO_Y], BC
    CALL  MPLAYER.CAN_GO
    CALL  Z, IS_FREE_OF_ZOMBIE
    JP    Z, TRATE_ZOMBIE_RENDER
    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_DOWN
    LD    BC, [MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    MMOVE_ZOMBIE_RIGHT
    JP    TRATEZOMBIE_UNDO

TRATEZOMBIE_UNDO
    LD    A, [MWORK.TRATE_ZOMBIE_FIRST_OPTION]
    LD    [IX+K_OFFSET_ZOMBIE_DIR], A
    LD    BC,[MWORK.TRATE_ZOMBIE_PREV_POS]
    LD    [IX+K_OFFSET_Y], C
    LD    [IX+K_OFFSET_X], B
    JP    TRATE_ZOMBIE_RENDER

.SCHECKOTHERZOMBIE
    CALL  IS_FREE_OF_ZOMBIE
    JP    Z, TRATEZOMBIE_UNDO

TRATE_ZOMBIE_RENDER
    LD    B, [IX+K_OFFSET_X]
    LD    C, [IX+K_OFFSET_Y]
    CALL  MSUPPORT.YX_TO_OFFSET
    LD    HL, MWORK.CAMERA_SCREEN-33
    ADD   HL, DE

    ; TILES SEGUN DIR
    LD    A, [IX+K_OFFSET_ZOMBIE_DIR]
    SLA   A
    SLA   A
    SLA   A
    ADD   32
    LD    B, A ;GUARDO TILE
    LD    A, [MWORK.ANIMATION_TICK]
    AND   8
    CP    0
    JP    Z, .SSETFRAME
    INC   B
    INC   B
    INC   B
    INC   B
.SSETFRAME
    LD    A, B
    LD    [HL], A
    INC   HL
    INC   A
    LD    [HL], A
    LD    BC, 31
    ADD   HL, BC
    INC   A
    LD    [HL], A
    INC   HL
    INC   A
    LD    [HL], A
    JP    END_TRATE_ENTITY

TRATEZOMBIE_TRATECOLISIONPLAYER
    LD    A, [MWORK.PLAYER_IMMUNITY]
    CP    0
    JP    NZ, TRATE_ZOMBIE_RENDER
    LD    A, 20
    LD    [MWORK.PLAYER_IMMUNITY], A
    LD    A, [MWORK.PLAYER_LIVES]
    CP    0
    JP    Z, .CONTINUE
    DEC   A
.CONTINUE    
    LD    [MWORK.PLAYER_LIVES], A
    CP    0
    JP    NZ, TRATE_ZOMBIE_RENDER
    ;PREGAMEOVER
    LD    A, 1
    LD    [MWORK.PRE_GAME_OVER], A
    JP    TRATE_ZOMBIE_RENDER


;==========================================
;::WHERE_IS_PLAYER
;               IN->IX, PROTA
;               OUT->A = IS_...
;               REMARKS: SUMA Y RESTA PARA SOLUCIONAR HISTERESIS.
;==========================================
WHERE_IS_PLAYER
    LD    A, [MWORK.PLAYER_X]
    SUB   8
    CP    [IX+K_OFFSET_X]
    JP    NC, .SCHECKRIGHT
    ADD   16
    CP    [IX+K_OFFSET_X]
    JP    C, .SCHECKLEFT

    ; EN MISMA X. MIRA Y.
    LD    A, [MWORK.PLAYER_Y]
    CP    [IX+K_OFFSET_Y]
    JP    NC, .SDOWN

.SUP
    LD    A, K_IS_UP
    RET

.SCHECKRIGHT
    LD    A, [MWORK.PLAYER_Y]
    SUB   8
    CP    [IX+K_OFFSET_Y]
    JP    NC, .SDOWNRIGHT
    ADD   16
    CP    [IX+K_OFFSET_Y]
    JP    C, .SUPRIGHT

.SRIGHT
    LD    A, K_IS_RIGHT
    RET

.SDOWNRIGHT
    LD    A, K_IS_DOWN_RIGHT
    RET

.SUPRIGHT
    LD    A, K_IS_UP_RIGHT
    RET

.SCHECKLEFT
    LD    A, [MWORK.PLAYER_Y]
    SUB   8
    CP    [IX+K_OFFSET_Y]
    JP    NC, .SDOWNLEFT
    ADD   8
    CP    [IX+K_OFFSET_Y]
    JP    C, .SUPLEFT
    ;.SLEFT
    LD    A, K_IS_LEFT
    RET

.SDOWNLEFT
    LD    A, K_IS_DOWN_LEFT
    RET

.SUPLEFT
    LD    A, K_IS_UP_LEFT
    RET

.SDOWN
    LD    A, K_IS_DOWN
    RET

.SLEFT
    LD    A, K_IS_LEFT
    RET

;===========================
;::TRATE_EXPLOSION
;===========================
TRATE_EXPLOSION
    LD    A, [IX+K_OFFSET_STATE]
    CP    0
    JP    Z, .STATE0
    CP    4
    JP    Z, .QUIT
    INC   [IX+K_OFFSET_COUNTER]
    LD    A, [IX+K_OFFSET_COUNTER]
    CP    2
    JP    NZ, .RENDER
    LD    [IX+K_OFFSET_COUNTER], 0
    INC   [IX+K_OFFSET_STATE]
    JP    TRATE_EXPLOSION
.RENDER
    CALL  ENTITY.GET_NEXT_INDEX_SPRITE_DE
    LD    A, [IX+K_OFFSET_Y]
    ADD   -8
    LD    [DE], A
    LD    A, [IX+K_OFFSET_X]
    ADD   -8
    INC   DE
    LD    [DE], A
    INC   DE
    LD    A, [IX+K_OFFSET_STATE]   ;FRAME SPRITE
    SLA   A
    SLA   A
    ADD   16
    LD    [DE], A
    INC   DE
    LD    A, 15
    LD    [DE], A     ;COLOR
    JP    END_TRATE_ENTITY

.STATE0
    LD    [IX+K_OFFSET_COUNTER], 0
    LD    [IX+K_OFFSET_STATE], 1

;    LD    HL, FX_ZOMBIE_EXPLODE
 ;   LD    [PUNTERO_SONIDO], HL
  ;  LD    HL,INTERR       
   ; SET   2,[HL] 
   LD A, 8
   CALL INICIA_SONIDO

    JP    TRATE_EXPLOSION

.QUIT
    MDEC_CURRENT_NUMBER_OF_ZOMBIES
    LD    [IX], 0
    JP    END_TRATE_ENTITY

;===========================
;::TRATE_SURVIVOR
;===========================
TRATE_SURVIVOR
    LD    A, [IX+K_OFFSET_IS_VISIBLE]
    CP    0
    JP    Z, END_TRATE_ENTITY

    LD    DE, [MWORK.PLAYER_Y]
    CALL  IS_COLISION_PLAYER_ENTITY
    JP    Z, .RESCUESURVIVOR

    LD    A, [MWORK.ANIMATION_TICK]
    AND   7
    CP    7
    JP    NZ, .RENDER
    LD    A, [IX+K_OFFSET_STATE]
    ADD   4
    LD    [IX+K_OFFSET_STATE], A
    CP    112
    JP    NZ, .RENDER
    LD    [IX+K_OFFSET_STATE], 96
.RENDER
    LD    B, [IX+K_OFFSET_X]
    LD    C, [IX+K_OFFSET_Y]
    CALL  MSUPPORT.YX_TO_OFFSET
    LD    HL, MWORK.CAMERA_SCREEN-33
    ADD   HL, DE

    ;IF THERE'S A ZOMBIE DON'T RENDER 
    LD    A, [HL]
    CP    32
    JP    C, .CONTINUERENDER
    CP    96
    JP    NC, .CONTINUERENDER
    JP    END_TRATE_ENTITY

.CONTINUERENDER
    LD    A, [IX+K_OFFSET_STATE] ;STATE EQUAL TO TILE CODE (115..120)
    LD    [HL], A
    INC   HL
    INC   A
    LD    [HL], A
    LD    BC, 31
    ADD   HL, BC
    INC   A
    LD    [HL], A
    INC   HL
    INC   A
    LD    [HL], A
    LD    BC, -31
    ADD   HL, BC
    JP    END_TRATE_ENTITY

.RESCUESURVIVOR
    LD    HL, FX_TAKE
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

    LD    A, 0X5
    LD    HL, MWORK.PLAYER_POINTS
    CALL  ADD_POINTS


    LD    A, [MWORK.SURVIVORS_TO_SAVE]
    DEC   A
    LD    [MWORK.SURVIVORS_TO_SAVE], A
    CP    0
    JP    NZ, .QUIT

    ;CREATE ENTITYCOUNTDOWN
    LD    [IX], K_ENTITY_COUNTDOWN
    LD    [IX+K_OFFSET_COUNTER], 0
    LD    A, 0X02
    LD    [MWORK.COUNT_DOWN], A
    LD    A, 0X00
    LD    [MWORK.COUNT_DOWN+1], A
    CALL  MGAME.PUT_EXIT_OPEN_IN_MAP
    
    DI
    PUSH  IX
    LD    A, K_SONG_RUN
    CALL  CARGA_CANCION
    POP   IX
    EI
 
    JP    END_TRATE_ENTITY
.QUIT
    LD    [IX], 0
    JP    END_TRATE_ENTITY


;===========================
;::TRATE_EXIT
;===========================
TRATE_EXIT
    LD    A, [IX+K_OFFSET_IS_VISIBLE]
    CP    1
    JP    NZ, END_TRATE_ENTITY
    LD    A, [MWORK.SURVIVORS_TO_SAVE]
    CP    0
    JP    NZ, END_TRATE_ENTITY

    CALL  IS_COLISION_PLAYER_EXIT
    JP    Z, .PLAYEREXIT

;.RENDER
    LD    A, [MWORK.ANIMATION_TICK]
    AND   3
    CP    3
    JP    NZ, .CONTINUERENDER
    INC   [IX+K_OFFSET_COUNTER]
    LD    A, [IX+K_OFFSET_COUNTER]
    CP    4
    JP    C, .CONTINUERENDER
    LD    [IX+K_OFFSET_COUNTER], 0

.CONTINUERENDER
    LD    B, [IX+K_OFFSET_X]
    LD    C, [IX+K_OFFSET_Y]
    CALL  MSUPPORT.YX_TO_OFFSET
    LD    HL, MWORK.CAMERA_SCREEN
    ADD   HL, DE
    LD    A, [IX]
    CP    K_ENTITY_EXIT_LEFT
    JP    Z, .LEFT
    CP    K_ENTITY_EXIT_DOWN
    JP    Z, .DOWN
    CP    K_ENTITY_EXIT_RIGHT
    JP    Z, .RIGHT

;.UP
    LD    A, 7
    ADD   [IX+K_OFFSET_COUNTER]
    LD    [HL], A
    DEC   HL
    LD    [HL], A
    LD    BC, -32
    ADD   HL, BC
    LD    [HL], A
    INC   HL
    LD    [HL], A
    JP    END_TRATE_ENTITY

.LEFT
    LD    A, 19
    ADD   [IX+K_OFFSET_COUNTER]
    LD    [HL], A
    DEC   HL
    LD    [HL], A
    LD    BC, -32
    ADD   HL, BC
    LD    [HL], A
    INC   HL
    LD    [HL], A
    JP    END_TRATE_ENTITY

.RIGHT
    LD    A, 11
    ADD   [IX+K_OFFSET_COUNTER]
    LD    [HL], A
    DEC   HL
    LD    [HL], A
    LD    BC, -32
    ADD   HL, BC
    LD    [HL], A
    INC   HL
    LD    [HL], A
    JP    END_TRATE_ENTITY


.DOWN
    LD    A, 15
    ADD   [IX+K_OFFSET_COUNTER]
    LD    [HL], A
    DEC   HL
    LD    [HL], A
    LD    BC, -32
    ADD   HL, BC
    LD    [HL], A
    INC   HL
    LD    [HL], A
    JP    END_TRATE_ENTITY

.PLAYEREXIT
    POP   BC  ;FROM TRATEENTITIES
    POP   BC  ;FROM CALL TRATEENTITIES
    CALL  MGAME.SHOW_BONUS_ANIMATION
    LD    A, [MWORK.LEVEL]
    INC   A
    LD    [MWORK.LEVEL], A
    XOR   A
    LD    [MWORK.ALREADY_CONTINUE], A
    JP    MAIN_INIT_LEVEL


;=============================
;::DECREMENT_COUNT_DOWN
;   OUT Z IF 0
;=============================
DECREMENT_COUNT_DOWN
    LD    DE, MWORK.COUNT_DOWN+1
    AND   A   ;CLEAR CARRY
    LD    A, [DE]
    SBC   1
    DAA
    LD    [DE], A
    LD    DE, MWORK.COUNT_DOWN
    LD    A, [DE]
    SBC   0
    DAA
    LD    [DE], A
    LD    A, [MWORK.COUNT_DOWN]
    CP    0
    RET   NZ
    LD    A, [MWORK.COUNT_DOWN+1]
    CP    0
    RET


;==============================
;::TRATE_COUNT_DOWN
;==============================
TRATE_COUNT_DOWN
    LD    A, [MWORK.PRE_GAME_OVER]
    CP    1
    JP    Z, .RENDER
    LD    A, [MWORK.ANIMATION_TICK]
    AND   7
    CP    7
    JP    NZ, .RENDER
    CALL  DECREMENT_COUNT_DOWN
    JP    NZ, .RENDER
    LD    A, 1  
    LD    [MWORK.PRE_GAME_OVER], A
    JP    END_TRATE_ENTITY

.RENDER
    LD    HL, MWORK.CAMERA_SCREEN+26
    LD    A, [MWORK.ANIMATION_TICK]
    AND   8
    CP    0
    JP    Z, .RENDEREXITUNPLUG
    LD    [HL], 222
    INC   HL
    LD    [HL], 223
    JP    .RENDERTIME

.RENDEREXITUNPLUG
    LD    [HL], 0
    INC   HL
    LD    [HL], 0

    ;NUMEROS
.RENDERTIME
    LD    A, [MWORK.COUNT_DOWN]
    AND   0X0F
    ADD   K_TIME_ZERO_TILE
    LD    [MWORK.CAMERA_SCREEN+28], A
    LD    A, [MWORK.COUNT_DOWN+1]
    LD    B, A
    SRL   A
    SRL   A
    SRL   A
    SRL   A
    ADD   K_TIME_ZERO_TILE
    LD    [MWORK.CAMERA_SCREEN+29], A
    LD    A, B
    AND   0X0F
    ADD   K_TIME_ZERO_TILE
    LD    [MWORK.CAMERA_SCREEN+30], A
    JP    END_TRATE_ENTITY



;===========================
;::TRATE_HEART
;===========================
TRATE_HEART
    INC  [IX+K_OFFSET_NOVISIBLE_COUNTER]
    LD   A, [IX+K_OFFSET_NOVISIBLE_COUNTER]
    CP   K_TICKS_TO_QUIT_ITEM
    JP   NZ, .CONTINUE
    
    LD   [IX], 0
    MDEC_CURRENT_NUMBER_OF_ZOMBIES
    JP   END_TRATE_ENTITY

.CONTINUE
    LD   A, [IX+K_OFFSET_IS_VISIBLE]
    CP   0
    JP   Z, END_TRATE_ENTITY

    LD   DE, [MWORK.PLAYER_Y]
    CALL IS_COLISION_PLAYER_LITTLE_ENTITY
    JP   Z, .PLAYERTAKE

    LD   A, [MWORK.ANIMATION_TICK]
    AND  1
    CP   0
    JP   NZ, .RENDER

    LD   [IX+K_OFFSET_COUNTER], 0
    INC  [IX+K_OFFSET_STATE]
    LD   A, [IX+K_OFFSET_STATE]
    CP   121
    JP   NZ, .RENDER
    LD   [IX+K_OFFSET_STATE], 115
.RENDER
    LD   B, [IX+K_OFFSET_X]
    LD   C, [IX+K_OFFSET_Y]
    CALL MSUPPORT.YX_TO_OFFSET
    LD   HL, MWORK.CAMERA_SCREEN
    ADD  HL, DE

    ;IF THERE'S A ZOMBIE DON'T RENDER 
    LD    A, [HL]
    CP    32
    JP    C, .CONTINUERENDER
    CP    96
    JP    NC, .CONTINUERENDER
    JP    END_TRATE_ENTITY

.CONTINUERENDER
    LD    A, [IX+K_OFFSET_STATE] ;STATE EQUAL TO TILE CODE (115..120)
    LD    [HL], A
    JP    END_TRATE_ENTITY

.PLAYERTAKE
    LD    HL, FX_TAKE
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

    MDEC_CURRENT_NUMBER_OF_ZOMBIES
    LD    A, [MWORK.PLAYER_LIVES]
    ADD   2
    LD    [MWORK.PLAYER_LIVES], A
    CP    6
    JP    C, .QUIT
    LD    A, 6
    LD    [MWORK.PLAYER_LIVES], A
.QUIT
    LD    [IX], 0
    JP    END_TRATE_ENTITY

;===========================
;::TRATE_COIN
;===========================
TRATE_COIN
    INC   [IX+K_OFFSET_NOVISIBLE_COUNTER]
    LD    A, [IX+K_OFFSET_NOVISIBLE_COUNTER]
    CP    K_TICKS_TO_QUIT_ITEM
    JP    NZ, .CONTINUE
    
    LD    [IX], 0
    MDEC_CURRENT_NUMBER_OF_ZOMBIES
    JP    END_TRATE_ENTITY

.CONTINUE
    LD    A, [IX+K_OFFSET_IS_VISIBLE]
    CP    0
    JP    Z, END_TRATE_ENTITY

    LD    DE, [MWORK.PLAYER_Y]
    CALL  IS_COLISION_PLAYER_LITTLE_ENTITY
    JP    Z, .PLAYERTAKE

    LD    A, [MWORK.ANIMATION_TICK]
    AND   1
    CP    0
    JP    Z, .RENDER

    LD    [IX+K_OFFSET_COUNTER], 0
    INC   [IX+K_OFFSET_STATE]
    LD    A, [IX+K_OFFSET_STATE]
    CP    29
    JP    NZ, .RENDER
    LD    [IX+K_OFFSET_STATE], 23
.RENDER
    LD    B, [IX+K_OFFSET_X]
    LD    C, [IX+K_OFFSET_Y]
    CALL  MSUPPORT.YX_TO_OFFSET
    LD    HL, MWORK.CAMERA_SCREEN
    ADD   HL, DE

    ;IF THERE'S A ZOMBIE DON'T RENDER
    LD    A, [HL]
    CP    32
    JP    C, .CONTINUERENDER
    CP    96
    JP    NC, .CONTINUERENDER
    JP    END_TRATE_ENTITY

.CONTINUERENDER
    LD    A, [IX+K_OFFSET_STATE] ;STATE EQUAL TO TILE CODE (115..120)
    LD    [HL], A
    JP    END_TRATE_ENTITY

.PLAYERTAKE
    LD    HL, FX_TAKE
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

    LD    A, 0X10
    LD    HL, MWORK.PLAYER_POINTS
    CALL  ADD_POINTS
    MDEC_CURRENT_NUMBER_OF_ZOMBIES
    LD    [IX], 0
    JP    END_TRATE_ENTITY


  ;  PAGE 2

;============================
;::TRATE_ITEM_SHOOT
;============================
TRATE_ITEM_SHOOT
    INC   [IX+K_OFFSET_NOVISIBLE_COUNTER]
    LD    A, [IX+K_OFFSET_NOVISIBLE_COUNTER]
    CP    K_TICKS_TO_QUIT_ITEM
    JP    NZ, .CONTINUE

.QUIT
    LD    [IX], 0
    MDEC_CURRENT_NUMBER_OF_ZOMBIES
    JP    END_TRATE_ENTITY

.CONTINUE
    LD    A, [IX+K_OFFSET_IS_VISIBLE]
    CP    0
    JP    Z, END_TRATE_ENTITY

    ;CHECK IF COLISION
    LD    DE, [MWORK.PLAYER_Y]
    CALL  IS_COLISION_PLAYER_LITTLE_ENTITY
    JP    Z, .PLAYERTAKE

.RENDER
    LD    B, [IX+K_OFFSET_X]
    LD    C, [IX+K_OFFSET_Y]
    CALL  MSUPPORT.YX_TO_OFFSET
    LD    HL, MWORK.CAMERA_SCREEN
    ADD   HL, DE

    ;IF THERE'S A ZOMBIE DON'T RENDER (WORKAROUND TO SPEED COLISION DETECTION)
    LD    A, [HL]
    CP    32
    JP    C, .CONTINUERENDER
    CP    96
    JP    NC, .CONTINUERENDER
    JP    END_TRATE_ENTITY

.CONTINUERENDER
    LD    A, [IX]
    CP    K_ENTITY_ITEM_NORMAL_SHOOT
    JP    Z, .RENDERNORMALSHOOTWEAPON
    CP    K_ENTITY_ITEM_DOUBLE_SHOOT
    JP    Z, .RENDERDOUBLESHOOTWEAPON

;.RENDERTRIPLESHOOTWEAPON
    LD    [HL], 122
    JP    END_TRATE_ENTITY
.RENDERNORMALSHOOTWEAPON
    LD    [HL], 121
    JP    END_TRATE_ENTITY
.RENDERDOUBLESHOOTWEAPON
    LD    [HL], 123
    JP    END_TRATE_ENTITY

.PLAYERTAKE
    LD    HL, FX_TAKE
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 
    
    LD    A, [IX]
    CP    K_ENTITY_ITEM_DOUBLE_SHOOT
    JP    Z, .TAKEDOUBLESHOOT
    CP    K_ENTITY_ITEM_TRIPLE_SHOOT
    JP    Z, .TACKETRIPLESHOOT

;.TAKENORMALSHOOT
    LD    A, K_NORMAL_SHOOT
    LD    [MWORK.PLAYER_SHOOT_TYPE], A
    LD    A, 1
    LD    [MWORK.PLAYER_SHOOT_COST], A
    JP    .QUIT

.TAKEDOUBLESHOOT
    LD    A, K_DOUBLE_SHOOT
    LD    [MWORK.PLAYER_SHOOT_TYPE], A
    LD    A, 2
    LD    [MWORK.PLAYER_SHOOT_COST], A
    JP    .QUIT

.TACKETRIPLESHOOT
    LD    A, K_TRIPLE_SHOOT
    LD    [MWORK.PLAYER_SHOOT_TYPE], A
    LD    A, 3
    LD    [MWORK.PLAYER_SHOOT_COST], A
    JP    .QUIT


                ENDMODULE