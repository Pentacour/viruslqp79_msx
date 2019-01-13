                MODULE          MGAME

K_MAX_CONTINUES_FOR_GOOD_ENDING EQU 3   

;===========================================
;::SHOW_INTRO
;===========================================
SHOW_INTRO
                CALL            LOAD_INTRO

                CALL            PLAYER_OFF
                DI
                PUSH            AF
                LD              A, K_SONG_INTRO
                CALL            CARGA_CANCION
                POP             AF

                LD              HL, 0XF000
                LD              [MWORK.TMP_COUNTER], HL
.PRESS_KEY_LOOP
                LD              HL, [MWORK.TMP_COUNTER]
                DEC             HL
                LD              [MWORK.TMP_COUNTER], HL
                LD              A, L
                CP              0
                JP              NZ, .CONTINUE
                LD              A, H
                CP              0
                JP              Z, MAIN_SEL_GAME

.CONTINUE       XOR             A                               ; CHECK SPACE KEY
                CALL            GTTRIG
                CP              0
                JP              Z, .PRESS_KEY_LOOP
                JP              MAIN_SEL_GAME


;==========================================
;::LOAD_INTRO
;==========================================
LOAD_INTRO
                CALL            MSCREEN.CLEAR_SCREEN
                CALL            DISSCR

                CALL            SETGAMEPAGE0
                LD              HL, MDATAP0.INTRO_PATTERNS_0 
                LD              DE, MWORK.TMP_UNZIP
                CALL            PLETTER.UNPACK
                CALL            RESTOREBIOS
                LD              HL, MWORK.TMP_UNZIP
                LD              DE, CHRTBL
                LD              BC, 32*8*8
                CALL            LDIRVM

                CALL            SETGAMEPAGE0
                LD              HL, MDATAP0.INTRO_COLORS_0
                LD              DE, MWORK.TMP_UNZIP
                CALL            PLETTER.UNPACK
                CALL            RESTOREBIOS
                LD              HL, MWORK.TMP_UNZIP
                LD              DE, CLRTBL
                LD              BC, 32*8*8
                CALL            LDIRVM

                CALL            SETGAMEPAGE0
                LD              HL, MDATAP0.INTRO_PATTERNS_1 
                LD              DE, MWORK.TMP_UNZIP
                CALL            PLETTER.UNPACK
                CALL            RESTOREBIOS
                LD              HL, MWORK.TMP_UNZIP
                LD              DE, CHRTBL+32*8*8
                LD              BC, 32*8*8
                CALL            LDIRVM

                CALL            SETGAMEPAGE0
                LD              HL, MDATAP0.INTRO_COLORS_1
                LD              DE, MWORK.TMP_UNZIP
                CALL            PLETTER.UNPACK
                CALL            RESTOREBIOS
                LD              HL, MWORK.TMP_UNZIP
                LD              DE, CLRTBL+32*8*8
                LD              BC, 32*8*8
                CALL            LDIRVM

                CALL            SETGAMEPAGE0
                LD              HL, MDATAP0.INTRO_PATTERNS_2 
                LD              DE, MWORK.TMP_UNZIP
                CALL            PLETTER.UNPACK
                CALL            RESTOREBIOS
                LD              HL, MWORK.TMP_UNZIP
                LD              DE, CHRTBL+32*8*8*2
                LD              BC, 32*8*8
                CALL            LDIRVM

                CALL            SETGAMEPAGE0
                LD              HL, MDATAP0.INTRO_COLORS_2
                LD              DE, MWORK.TMP_UNZIP
                CALL            PLETTER.UNPACK
                CALL            RESTOREBIOS
                LD              HL, MWORK.TMP_UNZIP
                LD              DE, CLRTBL+32*8*8*2
                LD              BC, 32*8*8
                CALL            LDIRVM

                CALL            MSUPPORT.FILL_CAMERA_INCREMENTAL
                CALL            ENASCR

                RET

                

;===========================================
;::SHOW_SELECT_GAME
;===========================================
SHOW_SELECT_GAME
                CALL            DISSCR
                CALL            MSCREEN.CLEAR_SCREEN
                LD              HL, MDATA.SELECT_GAME_PATTERNS
                LD              DE, MDATA.SELECT_GAME_COLORS
                CALL            MSUPPORT.LOAD_TILESET_ONE_BANK
                CALL            ENASCR    

                LD              HL, MWORK.CAMERA_SCREEN+32*4+7
                LD              A, 64
                LD              B, 6

.LOOP_ROWS      PUSH            BC
                LD              B, 18

.LOOP_COL       LD              [HL], A
                INC             HL
                INC             A
                DJNZ            .LOOP_COL

                LD              BC, 14
                ADD             HL, BC
                ADD             C
                POP             BC
                DJNZ            .LOOP_ROWS

                LD              DE, MWORK.CAMERA_SCREEN+32*15+9
                LD              HL, PUSH_SPACE_KEY_TEXT 
                CALL            MSCREEN.RENDER_TEXT
                LD              DE, MWORK.CAMERA_SCREEN+32*16+9
                LD              HL, PUSH_SPACE_KEY_LINE_TEXT
                CALL            MSCREEN.RENDER_TEXT
                LD              HL, 0XC000
                LD              [MWORK.TMP_COUNTER], HL
    
.LOOP_CHECK_KEY
                LD              A, [MWORK.TMP_COUNTER]
                AND             16
                CP              16
                JP              Z, .FLASH_OFF_0
                ;
;FLASH_ON_0
                LD              DE, MWORK.CAMERA_SCREEN+32*15+9
                LD              HL, PLAY_START_TEXT 
                CALL            MSCREEN.RENDER_TEXT
                LD              DE, MWORK.CAMERA_SCREEN+32*16+9
                LD              HL, PLAY_START_LINE_TEXT
                CALL            MSCREEN.RENDER_TEXT
                JP              .RENDER
.FLASH_OFF_0
                LD              DE, MWORK.CAMERA_SCREEN+32*15+9
                LD              HL, BLANK_TEXT 
                CALL            MSCREEN.RENDER_TEXT
                LD              DE, MWORK.CAMERA_SCREEN+32*16+9
                LD              HL, BLANK_TEXT
                CALL            MSCREEN.RENDER_TEXT
                ;
.RENDER
                LD              HL, MWORK.CAMERA_SCREEN
                LD              DE, NAMTBL
                LD              B, 48
                HALT
                CALL            MSUPPORT.UFLDIRVM

                XOR             A
                CALL            GTTRIG
                CP              0
                JP              NZ, .SELECT_GAME
                LD              A, 1
                CALL            GTTRIG
                CP              0
                JP              NZ, .SELECT_GAME

                LD              HL, [MWORK.TMP_COUNTER]
                DEC             HL
                LD              [MWORK.TMP_COUNTER], HL
                LD              A, L 
                CP              0
                ;JP              Z, SHOW_INTRO

                JP              .LOOP_CHECK_KEY
    
.SELECT_GAME    CALL            PLAYER_OFF
               /* LD    HL, FX_ZOMBIE_EXPLODE;FX_TAKE
                LD    [PUNTERO_SONIDO], HL
                LD    HL,INTERR       
                SET   2,[HL] */
                LD              B, 80

.LOOP_SELECT_GAME
                PUSH            BC
                LD              A, B
                AND             4
                CP              4
                JP              Z, .FLASH_OFF
;FLASH_ON
                LD              DE, MWORK.CAMERA_SCREEN+32*15+9
                LD              HL, PLAY_START_TEXT 
                CALL            MSCREEN.RENDER_TEXT
                LD              DE, MWORK.CAMERA_SCREEN+32*16+9
                LD              HL, PLAY_START_LINE_TEXT
                CALL            MSCREEN.RENDER_TEXT
                JP              .CONTINUE_SELECT_GAME
.FLASH_OFF
                LD              DE, MWORK.CAMERA_SCREEN+32*15+9
                LD              HL, BLANK_TEXT 
                CALL            MSCREEN.RENDER_TEXT
                LD              DE, MWORK.CAMERA_SCREEN+32*16+9
                LD              HL, BLANK_TEXT
                CALL            MSCREEN.RENDER_TEXT

.CONTINUE_SELECT_GAME
                HALT
                LD              HL, MWORK.CAMERA_SCREEN
                LD              DE, NAMTBL
                LD              B, 48
                CALL            MSUPPORT.UFLDIRVM
                POP             BC
                DJNZ            .LOOP_SELECT_GAME

                CALL            COOL_CLEAR_SCREEN
                JP              MAIN_INIT_GAME

PUSH_SPACE_KEY_TEXT
                DB    16, 50, 13, 17, 15, 7, 1, 15, 13, 2, 3, 5, 1, 84, 5, 18, 52
PUSH_SPACE_KEY_LINE_TEXT
                DB    16, 0, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 0
PLAY_START_TEXT
                DB    16, 0, 0, 50, 13, 9, 2, 18, 1, 15, 16, 2, 85, 16, 52, 0, 0
PLAY_START_LINE_TEXT
                DB    16, 0, 0, 0, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 0, 0, 0    
BLANK_TEXT
                DB    16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


;================================
;::COOL_CLEAR_SCREEN
;================================
COOL_CLEAR_SCREEN
                LD              HL, NAMTBL
                LD              B, 31
.LOOP_ROW
                HALT
                PUSH            BC
                PUSH            HL    
                LD              B, 23
.LOOP_COL
                PUSH            BC
                XOR             A
                CALL            WRTVRM
                LD              BC, 32
                ADD             HL, BC
                POP             BC
                DJNZ            .LOOP_COL
                POP             HL
                INC             HL
                POP             BC
                DJNZ            .LOOP_ROW
                RET


;===========================================
;::INIT_GAME
;===========================================
INIT_GAME
    CALL  MSCREEN.CLEAR_SCREEN

    XOR   A
    LD    [MWORK.NUM_OF_CONTINUES], A
    LD    A, 1
    LD    [MWORK.ALREADY_CONTINUE], A

    LD    A, MWORK.K_EOF
    LD    [MWORK.LIST_ENTITIES_DATA_END], A
    LD    A, MWORK.K_INITIAL_PLAYER_LIVES
    LD    [MWORK.PLAYER_LIVES], A
    LD    A, MWORK.K_NORMAL_SHOOT
    LD    [MWORK.PLAYER_SHOOT_TYPE], A
    LD    A, 1
    LD    [MWORK.PLAYER_SHOOT_COST], A
    LD    A, MWORK.K_START_MAP
    LD    [MWORK.LEVEL], A
;.INIT_CONTINUE
    XOR   A
    LD    [MWORK.RUN_NUMBER], A
    XOR   A
    LD    [MWORK.PLAYER_POINTS], A
    LD    [MWORK.PLAYER_POINTS+1], A
    LD    [MWORK.PLAYER_POINTS+2], A
    LD    HL, MWORK.THE_MAP
    LD    [MWORK.CAMERA_OFFSET], HL

    LD    HL, MDATA.SPRITE_EXPLOSION_F1   
    LD    DE, SPRTBL+128
    LD    BC, 32*4+32
    CALL  LDIRVM
    ;;

    ;CLEAR SCOREBOARD ZONE
    XOR   A
    LD    DE, MWORK.CAMERA_SCREEN
    LD    B, 64
.LOOPCLEARSCOREBOARD
    LD    [DE], A
    INC   DE
    DJNZ  .LOOPCLEARSCOREBOARD

    LD    HL, ENTITY.SPRITES_TABLE_SEQUENCES
    LD    [MWORK.CURRENT_SPRITES_TABLE], HL
    LD    [MWORK.CURRENT_SPRITES_TABLE_POSITION], HL

    CALL  RESET_SPRITES

    JP MAIN_INIT_LEVEL

;=========================================
;::RESET_SPRITES
;=========================================
RESET_SPRITES
                                LD      HL, ENTITY.SPRITES_TABLE_SEQUENCES
                                LD      [MWORK.CURRENT_SPRITES_TABLE], HL
                                LD      [MWORK.CURRENT_SPRITES_TABLE_POSITION], HL
                                LD      A, 209
                                LD      [MWORK.SPRITES_TABLE_0], A
                                LD      [MWORK.SPRITES_TABLE_1], A
                                LD      [MWORK.SPRITES_TABLE_2], A
                                LD      [MWORK.SPRITES_TABLE_3], A
                                LD      [MWORK.SPRITES_TABLE_4], A
                                LD      [MWORK.SPRITES_TABLE_5], A
                                LD      [MWORK.SPRITES_TABLE_6], A
                                LD      [MWORK.SPRITES_TABLE_7], A
                                CALL    MSUPPORT.INIT_SPRITES_SIZE
                                RET
    
;============================================
;::INIT_LEVEL
;============================================
INIT_LEVEL
                                LD      A, [MWORK.ALREADY_CONTINUE]
                                CP      1
                                JP      Z, INIT_LEVEL_CONTINUE

                                LD      A, [MWORK.LEVEL]
                                CP      16
                                JP      Z, SHOW_HALF_QUEST
                                CP      32
                                JP      Z, SHOW_ENDING
                                AND     3
                                CP      3
                                CALL    Z, SHOW_INTERMISSION

INIT_LEVEL_CONTINUE             XOR     A
                                LD      [MWORK.INTER_SCROLL_COUNTER_Y], A
                                LD      [MWORK.INTER_SCROLL_COUNTER_X], A
                                LD      [MWORK.CHARGE_BULLETS_COUNTER], A
                                LD      [MWORK.CURRENT_NUMBER_OF_ZOMBIES], A
                                LD      [MWORK.PLAYER_IMMUNITY], A
                                LD      [MWORK.CURRENT_NUMBER_OF_SHOOTS], A
                                LD      A, MWORK.K_MAX_BULLETS_COUNT
                                LD      [MWORK.PLAYER_BULLETS], A
                                LD      A, [MWORK.PLAYER_LIVES]
                                ADD     2
                                CP      MWORK.K_INITIAL_PLAYER_LIVES
                                JP      C, INIT_LEVEL_CONTINUE_2
                                LD      A, MWORK.K_INITIAL_PLAYER_LIVES
INIT_LEVEL_CONTINUE_2           LD      [MWORK.PLAYER_LIVES], A
                                CALL    MSCREEN.CLEAR_SCREEN
                                CALL    SHOW_LEVEL_ANIMATION
                                LD      HL, MDATA.TILESET_PATTERNS
                                LD      DE, MDATA.TILESET_COLORS
                                CALL    MSCREEN.LOAD_TILESET_ONE_BANK
                                CALL    CHECK_BLUE_HOUSES
                                CALL    ENTITY.RESET_ENTITIES
                                XOR     A
                                LD      [MWORK.CAMERA_CHANGED], A
                                LD      [MWORK.PLAYER_SHOOT_WAIT], A
                                LD      [MWORK.PRE_GAME_OVER], A
                                LD      A, 1
                                LD      [MWORK.PLAYER_SPACE_KEY_PRESSED], A

                                ;INIT MAP
                                LD      HL, MDATA.MAP_LEVELS
                                LD      A, [MWORK.LEVEL]
                                CP      32
                                JP      C, .PRE_INIT_MAP
                                SUB     32
.PRE_INIT_MAP                   CP      16
                                JP      C, .INIT_MAP
                                LD      HL, MDATA.MAP_LEVELS_P16
.INIT_MAP                       SLA     A   ;*16
                                SLA     A
                                SLA     A
                                SLA     A
                                LD      C, A
                                LD      B, 0
                                ADD     HL, BC
                                CALL    BUILD_MAP

                                ;INIT CAMERA AND PLAYER
                                LD      A, [MWORK.LEVEL]
                                CP      32
                                JP      C, .INITCAMERASTART

                                SUB     32
.INITCAMERASTART                SLA     A
                                SLA     A
                                LD      C, A
                                LD      B, 0
                                LD      HL, MDATA.CAMERA_AND_PLAYER_LOCATIONS
                                ADD     HL, BC
                                ;CAMERA
                                LD      A, [HL]
                                LD      [MWORK.CAMERA_TILE_Y_TOP], A
                                ADD     MSCREEN.K_CAMERA_HEIGHT-1
                                LD      [MWORK.CAMERA_TILE_Y_DOWN], A
                                INC     HL
                                LD      A, [HL]
                                LD      [MWORK.CAMERA_TILE_X_LEFT], A
                                ADD     MSCREEN.K_CAMERA_WIDTH-1
                                LD      [MWORK.CAMERA_TILE_X_RIGHT], A
                                INC     HL

    ;PLAYER
    LD    A, [HL]
    LD    [MWORK.PLAYER_Y], A
    INC   HL
    LD    A, [HL]
    LD    [MWORK.PLAYER_X], A
    LD    A, MPLAYER.K_KEY_RIGHT
    LD    [MWORK.PLAYER_DIRECTION], A

    ;SURVIVORS
    LD    A, [MWORK.LEVEL]
    LD    D, 3;2
    CP    32
    JP    C, .INITSURVIVORSSTART
    SUB   32
    LD    D, 3
.INITSURVIVORSSTART
    LD    B, A
    SLA   A   ;*6
    SLA   A
;    SLA   A
    ADD   B
    ADD   B
    LD    C, A
    LD    B, 0
    LD    HL, MDATA.SURVIVOR_LOCATIONS
    ADD   HL, BC
    LD    B, D
.LOOPINITSURVIVORS
    PUSH  BC
    PUSH  HL
    LD    A, ENTITY.K_ENTITY_SURVIVOR


    CALL  INIT_ENTITY

    PUSH  HL
    POP   IX
    LD    [IX+ENTITY.K_OFFSET_COUNTER], 0
    LD    [IX+ENTITY.K_OFFSET_STATE], 96
    POP   HL
    INC   HL  ;NEXT POSITION
    INC   HL
    POP   BC
    DJNZ  .LOOPINITSURVIVORS
;INITZOMBIES
    LD    A, [MWORK.LEVEL]
    LD    L, A
    LD    H, 0
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    LD    C, A
    LD    B, 0
    ADD   HL, BC
    ADD   HL, BC
    LD    B, H
    LD    C, L
    LD    HL, MDATA.CREATE_ZOMBIES_LOCATIONS_QUEST
    ADD   HL, BC
    LD    A, [HL]
    LD    [MWORK.ZOMBIES_SPEED], A
    INC   HL
    LD    A, [HL]
    INC   HL
    LD    [MWORK.CURRENT_ZOMBIE_TYPE], A
    CP    ENTITY.K_ZOMBIE_STRONG
    JP    Z, .ZOMBIESTRONG
.ZOMBIESTANDARD
    XOR   A
    LD    [MWORK.SHOOTS_TO_KILL_ZOMBIE], A
    JP    .STARTCREATINGZOMBIES
.ZOMBIESTRONG
    LD    A, 1
    LD    [MWORK.SHOOTS_TO_KILL_ZOMBIE], A
    PUSH  HL
    LD    HL, MDATA.STRONG_ZOMBIES_PATTERNS
    LD    DE, MDATA.STRONG_ZOMBIES_COLORS
    CALL  LOAD_STRONG_ZOMBIES_TILE_SET
    POP   HL

.STARTCREATINGZOMBIES
    LD    B, 4
.LOOPINITCREATEZOMBIES
    PUSH  BC
    PUSH  HL
    LD    A, [HL] ;HOUSE OR TERRAIN
    INC   HL
    INC   HL
    CALL  INIT_ENTITY
    LD    [IX+ENTITY.K_OFFSET_STATE], 1
    POP   HL
    INC   HL
    LD    A, [HL]
    LD    [IX+ENTITY.K_OFFSET_CREATE_FREQUENCY], A
    INC   HL
    INC   HL
    INC   HL
    POP   BC
    DJNZ  .LOOPINITCREATEZOMBIES

.TRATEEXIT
                                LD      A, [MWORK.LEVEL]
                                CP      32
                                JP      C, .STARTEXITLOCATIONS
                                SUB     32
.STARTEXITLOCATIONS             LD      C, A
                                ADD     A
                                ADD     C
                                LD      C, A
                                LD      B, 0
                                LD      HL, MDATA.EXIT_LOCATIONS
                                ADD     HL, BC
                                LD      A, [HL]
                                INC     HL
                                CALL    INIT_ENTITY
                                LD      [IX+ENTITY.K_OFFSET_COUNTER], 0 ;FOR ANIMATION
                                CALL    PUT_EXIT_DOOR_IN_MAP
                                LD      A, [IX]
                                LD      [MWORK.ENTITY_EXIT], A
                                LD      A, [IX+ENTITY.K_OFFSET_MAP_Y]
                                LD      [MWORK.ENTITY_EXIT_MAP_Y], A
                                LD      A, [IX+ENTITY.K_OFFSET_MAP_X]
                                LD      [MWORK.ENTITY_EXIT_MAP_X], A
;                                LD      A, [MWORK.LEVEL]
 ;                               CP      32
  ;                              JP      C, .TWOSURVIVORS

.THREESURVIVORS                 LD      A, 3    
                                JR      .ASSIGNSURVIVORS

;.TWOSURVIVORS                   LD      A, 2
.ASSIGNSURVIVORS                LD      [MWORK.SURVIVORS_TO_SAVE], A
                                JP      MAIN_INIT_LEVEL_CONTINUE


;============================================
;::CHECK_BLUE_HOUSES
;============================================
CHECK_BLUE_HOUSES
                                LD      A, [MWORK.LEVEL]   
                                AND     8
                                CP      8
                                RET     NZ

                                CALL    SETGAMEPAGE0
                                LD      HL, MDATAP0.BLUE_HOUSES_PATTERNS
                                LD      DE, MWORK.TMP_UNZIP
                                CALL    PLETTER.UNPACK
                                CALL    RESTOREBIOS
                                LD      HL, MWORK.TMP_UNZIP
                                LD      DE, CHRTBL+146*8
                                LD      BC, 64
                                CALL    LDIRVM
                                LD      HL, MWORK.TMP_UNZIP
                                LD      DE, CHRTBL+256*8+146*8
                                LD      BC, 64
                                CALL    LDIRVM
                                LD      HL, MWORK.TMP_UNZIP
                                LD      DE, CHRTBL+256*8*2+146*8
                                LD      BC, 64
                                CALL    LDIRVM

                                CALL    SETGAMEPAGE0
                                LD      HL, MDATAP0.BLUE_HOUSES_COLOR
                                LD      DE, MWORK.TMP_UNZIP
                                CALL    PLETTER.UNPACK
                                CALL    RESTOREBIOS
                                LD      HL, MWORK.TMP_UNZIP
                                LD      DE, CLRTBL+146*8
                                LD      BC, 64
                                CALL    LDIRVM
                                LD      HL, MWORK.TMP_UNZIP
                                LD      DE, CLRTBL+256*8+146*8
                                LD      BC, 64
                                CALL    LDIRVM
                                LD      HL, MWORK.TMP_UNZIP
                                LD      DE, CLRTBL+256*8*2+146*8
                                LD      BC, 64
                                CALL    LDIRVM
                                RET







;============================================
;::SET_LEVEL_SONG
;============================================
SET_LEVEL_SONG
                                LD      A, [MWORK.LEVEL]
                                CP      32
                                JP      C, .CONTINUE
                                SUB     32
.CONTINUE                       LD      C, A
                                LD      B, 0
                                LD      HL, MDATA.LEVEL_SONGS
                                ADD     HL, BC
                                LD      A, [HL]
                                LD      [MWORK.CURRENT_SONG], A
                                RET
;============================================
;::BUILD_MAP
;============================================
BUILD_MAP
    LD  DE, MWORK.THE_MAP


    LD  B, 4    ;4 MACROTILES PER COLUMN
.SROWSLOOP
    PUSH    BC

    LD  B, 4    ;8 MACROTILES PER ROW
.SCOLSLOOP
    PUSH    BC

    LD  A, [HL] ;LEFT MACROTILE CODE
    SRL A
    SRL A
    SRL A
    SRL A

    CALL    BUILD_MACRO_TILE

    ;INCREMENTS DE
    EX  DE, HL
    LD  BC, 8
    ADD HL, BC
    EX  DE, HL
    ;

    LD  A, [HL]
    AND 0X0F
    CALL    BUILD_MACRO_TILE

    ;INCREMENTS DE
    EX  DE, HL
    LD  BC, 8
    ADD HL, BC
    EX  DE, HL

    ;INCREMENTS HL
    INC HL

    POP BC

    DJNZ    .SCOLSLOOP

    ;NEXT ROW
    EX  DE, HL
    LD  BC, 64*7
    ADD HL, BC
    EX  DE, HL
    ;

    POP BC

    DJNZ    .SROWSLOOP

        RET


;============================================
;::BUILD_MACRO_TILE
;            IN: A MACROTILE CODE
;                DE ADDRESS OF MAP POSITION
;============================================
BUILD_MACRO_TILE
    PUSH    HL
    PUSH    DE

    LD  BC, MDATA.BLOCK_00
    LD  L, A
    LD  H, 0
    ADD HL,HL   ;MUL64
    ADD HL,HL
    ADD HL,HL
    ADD HL,HL
    ADD HL,HL
    ADD HL,HL
    ADD HL, BC

    LD  B, 8    ;8 TILES IN A ROW
.SROWSLOOP
    PUSH    BC

    LD  BC, 8
    LDIR

    ;NEXT ROW
    EX  DE, HL
    LD  BC, 64-8    ;NEXT LINE
    ADD HL, BC
    EX  DE, HL

    POP BC
    DJNZ    .SROWSLOOP

    POP DE
    POP HL

    RET

;=================================
;::PUT_EXIT_DOOR_IN_MAP
;    IX
;================================
PUT_EXIT_DOOR_IN_MAP
    LD    L, [IX+ENTITY.K_OFFSET_MAP_Y]
    LD    H, 0
    ADD   HL, HL ;*64
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    LD    C, [IX+ENTITY.K_OFFSET_MAP_X]
    LD    B, 0
    ADD   HL, BC
    LD    BC, MWORK.THE_MAP
    ADD   HL, BC
    LD    A, [IX]
    CP    ENTITY.K_ENTITY_EXIT_UP
    JP    Z, .UP
    CP    ENTITY.K_ENTITY_EXIT_DOWN
    JP    Z, .DOWN
    CP    ENTITY.K_ENTITY_EXIT_LEFT
    JP    Z, .LEFT
;.RIGHT
    LD    [HL], 167
    LD    BC, -64
    ADD   HL, BC
    LD    [HL], 166
    RET

.LEFT
    DEC   HL
    LD    [HL], 167
    LD    BC, -64
    ADD   HL, BC
    LD    [HL], 166
    RET

.UP
    LD    BC, -65
    ADD   HL, BC
    LD    [HL], 162
    INC   HL
    LD    [HL], 163
    LD    BC, 63
    ADD   HL, BC
    LD    [HL], 164
    INC   HL
    LD    [HL], 165
    RET

.DOWN
    LD    [HL], 169
    DEC   HL
    LD    [HL], 168
    RET


;=================================
;::PUT_EXIT_OPEN_IN_MAP
;================================
PUT_EXIT_OPEN_IN_MAP
    LD    A, [MWORK.ENTITY_EXIT_MAP_Y]
    LD    L, A
    LD    H, 0
    ADD   HL, HL ;*64
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    ADD   HL, HL
    LD    A, [MWORK.ENTITY_EXIT_MAP_X]
    LD    C, A
    LD    B, 0
    ADD   HL, BC
    LD    BC, MWORK.THE_MAP
    ADD   HL, BC
    LD    A, [MWORK.ENTITY_EXIT]
    CP    ENTITY.K_ENTITY_EXIT_UP
    JP    Z, .UP
    CP    ENTITY.K_ENTITY_EXIT_LEFT
    JP    Z, .LEFT
    CP    ENTITY.K_ENTITY_EXIT_DOWN
    JP    Z, .DOWN

;.RIGHT
    LD    [HL], 11
    DEC   HL
    LD    [HL], 0
    LD    BC, -64
    ADD   HL, BC
    LD    [HL], 0
    INC   HL
    LD    [HL], 11
    RET

.UP
    LD    [HL], 0
    DEC   HL
    LD    [HL], 0
    LD    BC, -64
    ADD   HL, BC
    LD    [HL], 7
    INC   HL
    LD    [HL], 7
    RET

.LEFT
    LD    [HL], 0
    DEC   HL
    LD    [HL], 19
    LD    BC, -64
    ADD   HL, BC
    LD    [HL], 19
    INC   HL
    LD    [HL], 0
    RET

.DOWN
    LD    [HL], 15
    DEC   HL
    LD    [HL], 15
    LD    BC, -64
    ADD   HL, BC
    LD    [HL], 0
    INC   HL
    LD    [HL], 0
    RET


;=========================================
;::LOAD_STRONG_ZOMBIES_TILE_SET
; IN->HL PATTERNS, DE, COLORS
;=========================================
LOAD_STRONG_ZOMBIES_TILE_SET
    PUSH    DE
    LD  DE, MWORK.TMP_UNZIP
    CALL    PLETTER.UNPACK

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CHRTBL+32*8
    LD  BC, 32*8*2
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CHRTBL+32*8*8+32*8
    LD  BC, 32*8*2
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CHRTBL+32*8*8*2+32*8
    LD  BC, 32*8*2
    CALL    LDIRVM

    POP HL
    LD  DE, MWORK.TMP_UNZIP
    CALL    PLETTER.UNPACK

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CLRTBL+32*8
    LD  BC, 32*8*2
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CLRTBL+32*8*8+32*8
    LD  BC, 32*8*2
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CLRTBL+32*8*8*2+32*8
    LD  BC, 32*8*2
    CALL    LDIRVM

    RET

;==========================================
;::INIT_ENTITY
;   IN->HL POINTER TO INITIALIZE DATA, A ENTITY TYPE
;==========================================
INIT_ENTITY
    PUSH    HL
    PUSH    AF
    CALL    ENTITY.GET_NEXT_EMPTY_INDESTRUCTIBLE
    PUSH    HL
    POP IX
    POP AF
    LD  [IX], A
    LD  [IX+ENTITY.K_OFFSET_IS_VISIBLE], 0
    LD  [IX+ENTITY.K_OFFSET_NOVISIBLE_COUNTER], 0
    POP DE
    LD  A, [DE]
    LD  [IX+ENTITY.K_OFFSET_MAP_X], A
    INC DE
    LD  A, [DE]
    LD  [IX+ENTITY.K_OFFSET_MAP_Y], A
    LD  [IX+ENTITY.K_OFFSET_STATE], 0
    CALL    ENTITY.CHECK_IF_VISIBLE

    RET

;=========================================
;::SHOW_LEVEL_ANIMATION
;=========================================
SHOW_LEVEL_ANIMATION
                        CALL    PLAYER_OFF
                        CALL    DISSCR
                        LD      HL, MDATA.TITLES_PATTERNS
                        LD      DE, MDATA.TITLES_COLORS
                        CALL    LOAD_TILE_SET_ONE_BANK

                        LD      BC, 32*24
                        LD      DE, MWORK.CAMERA_SCREEN
                        CALL    MSUPPORT.RESET_BIG_RAM

                        LD      B, 12
                        LD      DE, MWORK.CAMERA_SCREEN+32*8
                        LD      HL, MWORK.CAMERA_SCREEN+32*8+30

.LOOP                   PUSH    BC
                        PUSH    DE
                        PUSH    HL
                        CALL    RENDER_LEVEL_TEXT

                        POP     HL
                        PUSH    HL
                        CALL    RENDER_LEVEL_NUMBER

                        ; TO VRAM
                        HALT
                        LD      HL, MWORK.CAMERA_SCREEN
                        LD      DE, NAMTBL
                        LD      B, 48
                        CALL    MSUPPORT.UFLDIRVM

                        POP     HL
                        DEC     HL
                        POP     DE
                        INC     DE
                        POP     BC
                        DJNZ    .LOOP

                        CALL    ENASCR
                        CALL    MSUPPORT.INIT_SPRITES_SIZE
                        JP      .SHOWPRESSKEY

                        LD      A, 120; 0XEF
.WAITLOOP               HALT
                        DEC     A
                        CP      0
                        JP      NZ, .WAITLOOP
                        JP      .CONTINUE

.SHOWPRESSKEY           CALL    SHOW_PRESS_KEY
.CONTINUE               PUSH    AF
                        CALL    SET_LEVEL_SONG
                        LD      A, [MWORK.CURRENT_SONG]
                        CALL    CARGA_CANCION 
                        LD      DE, MWORK.CAMERA_SCREEN+32*12+10
                        LD      HL, PRESS_KEY_TILES_OFF
                        LD      BC, 13
                        LDIR
                        HALT
                        LD      HL, MWORK.CAMERA_SCREEN
                        LD      DE, NAMTBL
                        LD      B, 48
                        CALL    MSUPPORT.UFLDIRVM
                        POP     AF
                        CALL    MSUPPORT.WAIT_FEW_SECONDS
                        CALL    MSCREEN.CLEAR_SCREEN
                        RET

;==========================================
;::LOAD_TILE_SET_ONE_BANK
;   IN->HL PATTERNS, DE, COLORS
;==========================================
LOAD_TILE_SET_ONE_BANK
    PUSH    DE
    LD  DE, MWORK.TMP_UNZIP
    CALL    PLETTER.UNPACK

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CHRTBL
    LD  BC, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CHRTBL+32*8*8
    LD  BC, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CHRTBL+32*8*8*2
    LD  BC, 32*8*8
    CALL    LDIRVM

    POP HL
    LD  DE, MWORK.TMP_UNZIP
    CALL    PLETTER.UNPACK

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CLRTBL
    LD  BC, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CLRTBL+32*8*8
    LD  BC, 32*8*8
    CALL    LDIRVM

    LD  HL, MWORK.TMP_UNZIP
    LD  DE, CLRTBL+32*8*8*2
    LD  BC, 32*8*8
    CALL    LDIRVM

    RET

;=========================================
;::RENDER_LEVEL_TEXT
;   IN->DE SCREEN POSITION
;=========================================
RENDER_LEVEL_TEXT
    LD  HL, LEVEL_TEXT_TILES
    LD  BC, 8
    LDIR

    LD  BC, 32-8
    EX  DE, HL
    ADD HL, BC
    EX  DE, HL
    LD  BC, 8
    LDIR
    RET

LEVEL_TEXT_TILES
    DB 0, 31, 32, 33, 34, 35, 36, 37
    DB 0, 38, 39, 40, 41, 42, 43, 44


;=========================================
;::RENDER_LEVEL_NUMBER
;   IN->HL SCREEN POSITION, A NUMBER
;========================================
RENDER_LEVEL_NUMBER
                                INC     HL
                                LD      A, [MWORK.LEVEL]
                                INC     A
                                CP      10
                                JP      C, .ONEDIGIT
                                CP      20
                                JP      C, .TENS
                                CP      30
                                JP      C, .TWENTIES
                                CP      40
                                JP      C, .THIRTIES
                                CP      50
                                JP      C, .FOURTIES
                                CP      60
                                JP      C, .FIFTIES
;.SIXTIES
    LD  [HL], 13 ;1
    LD  BC, 32
    ADD HL, BC
    LD  [HL], 14 ;1
    LD  BC, -31
    ADD HL, BC
    SUB 60
    JP  .ONEDIGIT
.TENS
    LD  [HL], 3 ;1
    LD  BC, 32
    ADD HL, BC
    LD  [HL], 4 ;1
    LD  BC, -31
    ADD HL, BC
    SUB 10
    JP  .ONEDIGIT
.TWENTIES
    LD  [HL], 5 ;1
    LD  BC, 32
    ADD HL, BC
    LD  [HL], 6 ;1
    LD  BC, -31
    ADD HL, BC
    SUB 20
    JP  .ONEDIGIT
.THIRTIES
    LD  [HL], 7 ;1
    LD  BC, 32
    ADD HL, BC
    LD  [HL], 8 ;1
    LD  BC, -31
    ADD HL, BC
    SUB 30
    JP  .ONEDIGIT

.FOURTIES
    LD  [HL], 9 ;1
    LD  BC, 32
    ADD HL, BC
    LD  [HL], 10 ;1
    LD  BC, -31
    ADD HL, BC
    SUB 40
    JP  .ONEDIGIT

.FIFTIES
    LD  [HL], 11 ;1
    LD  BC, 32
    ADD HL, BC
    LD  [HL], 12 ;1
    LD  BC, -31
    ADD HL, BC
    SUB 50


.ONEDIGIT
    SLA A
    INC A
    LD  [HL], A
    INC HL
    LD  [HL], 0
    INC A
    LD  BC, 31
    ADD HL, BC
    LD [HL], A
    INC HL
    LD  [HL], 0
    RET

;=====================================
;::SHOW_PRESS_KEY
;=====================================
SHOW_PRESS_KEY
.PRESSKEYLOOP
    LD  DE, MWORK.CAMERA_SCREEN+32*12+10

    LD  A, [MWORK.LEVEL]
    CP  9
    JP  c, .CONTINUE
    INC DE

.CONTINUE
    LD  A, [MWORK.ANIMATION_TICK]
    INC A
    LD  [MWORK.ANIMATION_TICK], A
    AND 31
    CP  16
    JP  C, .PRESSKEYOFF

    LD  HL, PRESS_KEY_TILES_ON
    JP  .PRESSKEYRENDER
.PRESSKEYOFF
    LD  HL, PRESS_KEY_TILES_OFF
.PRESSKEYRENDER
    LD  BC, 12
    LDIR
    ; TO VRAM
    HALT
    LD  HL, MWORK.CAMERA_SCREEN
    LD  DE, NAMTBL
    LD  B, 48
    CALL    MSUPPORT.UFLDIRVM

    ;CHECK SPACE
    XOR     A
    CALL    GTTRIG
    CP  0
    JP  NZ, .RET
    LD    a, 1
    CALL  GTTRIG
    CP  0
    JP  Z, .PRESSKEYLOOP

.RET
    RET

;=====================================
;::SHOW_KEY_PRESSED
;=====================================
SHOW_KEY_PRESSED
    LD      B, 75
.PRESSKEYLOOP
    PUSH    BC
    LD  DE, MWORK.CAMERA_SCREEN+32*12+10
    LD  A, [MWORK.ANIMATION_TICK]
    INC A
    LD  [MWORK.ANIMATION_TICK], A
    AND 7
    CP  4
    JP  C, .PRESSKEYOFF

    LD  HL, PRESS_KEY_TILES_ON
    JP  .PRESSKEYRENDER
.PRESSKEYOFF
    LD  HL, PRESS_KEY_TILES_OFF
.PRESSKEYRENDER
    LD  BC, 12
    LDIR
    ; TO VRAM
    HALT
    LD  HL, MWORK.CAMERA_SCREEN
    LD  DE, NAMTBL
    LD  B, 48
    CALL    MSUPPORT.UFLDIRVM

    POP     BC
    DJNZ    .PRESSKEYLOOP

    RET


PRESS_KEY_TILES_ON
    DB  94, 95, 90, 96, 96, 0, 0, 96, 94, 99, 101, 90
PRESS_KEY_TILES_OFF
    DB   0,  0,  0,  0,  0, 0, 0, 0,  0,  0, 0, 0, 0


;=====================================
;::SHOW_PRESS_SPACE_TO_CONTINUE
;    OUT->Z NO CONTINUE
;=====================================
SHOW_PRESS_SPACE_TO_CONTINUE
                                CALL MSUPPORT.WAIT_SECONDS

                                LD      A, 31
                                LD      [MWORK.TMP_COUNTER], A
                                XOR     A
                                LD      [MWORK.TMP_COUNTER+1], A

.PRESSKEYLOOP                   LD      DE, MWORK.CAMERA_SCREEN+32*14+4
                                LD      A, [MWORK.ANIMATION_TICK]
                                INC     A
                                LD      [MWORK.ANIMATION_TICK], A
                                AND     31
                                CP      16
                                JP      C, .PRESSKEYOFF

                                XOR     A
                                LD      [MWORK.TMP_COUNTER+1], A
                                LD      HL, PRESS_SPACE_TILES_ON
                                JP      .PRESSKEYRENDER

.PRESSKEYOFF                    LD      A, [MWORK.TMP_COUNTER+1]
                                CP      1
                                JP      Z, .PRESSKEYOFFCONTINUE
                                LD      A, 1
                                LD      [MWORK.TMP_COUNTER+1], A
                                LD      A, [MWORK.TMP_COUNTER]
                                DEC     A
                                LD      [MWORK.TMP_COUNTER], A
                                LD      [MWORK.CAMERA_SCREEN+32*17+15], A
                                CP      20
                                RET     Z

.PRESSKEYOFFCONTINUE            LD      HL, PRESS_SPACE_TILES_OFF
.PRESSKEYRENDER                 LD      BC, 23
                                LDIR
                                HALT
                                LD      HL, MWORK.CAMERA_SCREEN
                                LD      DE, NAMTBL
                                LD      B, 48
                                CALL    MSUPPORT.UFLDIRVM
                                XOR     A
                                CALL    GTTRIG
                                CP      0
                                JP      NZ, .RET
                                LD      A, 1
                                CALL    GTTRIG
                                CP      0
                                JP      Z, .PRESSKEYLOOP
.RET
                                XOR     A
                                CP      1
                                RET

PRESS_SPACE_TILES_ON
    DB   0, 0, 0, 96, 94, 99, 101, 90, 0, 102, 93, 0, 101, 93, 92, 102, 103, 92, 97, 90
    ;DB  94, 95, 90, 96, 96, 0, 96, 94, 99, 101, 90, 0, 102, 93, 0, 101, 93, 92, 102, 103, 92, 97, 90
PRESS_SPACE_TILES_OFF
    DB   0,  0,  0,  0,  0, 0, 0, 0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


;========================================
;::SHOW_BONUS_ANIMATION
;========================================
SHOW_BONUS_ANIMATION
    CALL    PLAYER_OFF
    CALL    MSCREEN.CLEAR_SCREEN

    LD  HL, MDATA.TITLES_PATTERNS
    LD  DE, MDATA.TITLES_COLORS
    CALL    LOAD_TILE_SET_ONE_BANK

    CALL    MSCREEN.CLEAR_CAMERA

    LD  HL, BONUS_TILES
    LD  DE, MWORK.CAMERA_SCREEN+8*32+12
    LD  BC, 5
    LDIR

.LOOP
    LD    A, [MWORK.ANIMATION_TICK]
    INC   A
    LD    [MWORK.ANIMATION_TICK], A
    AND   7
    CP    7
    JR    NZ, .LOOPCONTINUE

    LD    HL, FX_TAKE 
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

.LOOPCONTINUE
    ;SUBSTRACTS COUNT DOWN
    CALL    ENTITY.DECREMENT_COUNT_DOWN
    PUSH    AF  ;SAVE Z

    ;ADD POINTS
    LD  A, 0X01
    LD  HL, MWORK.PLAYER_POINTS
    CALL    ENTITY.ADD_POINTS

    LD  HL, MWORK.CAMERA_SCREEN+8*32+19
    CALL    RENDER_BONUS_TIME

    LD  HL, MWORK.CAMERA_SCREEN+10*32+19
    CALL    RENDER_BONUS_POINTS

    HALT
    LD  HL, MWORK.CAMERA_SCREEN
    LD  DE, NAMTBL
    LD  B, 48
    CALL    MSUPPORT.UFLDIRVM

    ;CHECK IF COUNTDOWN = 0
    POP AF
    JP  NZ, .LOOP

    LD  B, 8*6
.LOOPWAIT
    HALT
    DJNZ .LOOPWAIT


    RET

BONUS_TILES
    DB 89, 93, 92, 97, 96


;=======================================
;::RENDER_BONUS_POINTS
;    IN-> HL SCREEN POSITION
;======================================
RENDER_BONUS_POINTS
    LD  A, [MWORK.PLAYER_POINTS]
    CALL    RENDER_BIG_NUMBER
    DEC HL
    DEC HL
    LD  A, [MWORK.PLAYER_POINTS+1]
    CALL    RENDER_BIG_NUMBER
    DEC HL
    DEC HL
    LD  A, [MWORK.PLAYER_POINTS+2]
    CALL    RENDER_BIG_NUMBER
    RET



;=======================================
;::RENDER_BONUS_TIME
;    IN-> HL SCREEN POSITION
;======================================
RENDER_BONUS_TIME
    LD  A, [MWORK.COUNT_DOWN]
    AND 0X0F
    ADD 21
    LD  [HL], A

    LD  A, [MWORK.COUNT_DOWN+1]
    LD  B, A
    SRL A
    SRL A
    SRL A
    SRL A
    ADD 21
    INC HL
    LD  [HL], A

    LD  A, [MWORK.COUNT_DOWN+1]
    AND 0X0F
    ADD 21
    INC HL
    LD  [HL], A

    RET


;===================================
;::RENDER_BIG_NUMBER
;   IN->HL SCREEN POSITION, A TWO DIGITS BCD
;===================================
RENDER_BIG_NUMBER
    PUSH    HL
    PUSH    AF
    AND 0X0F
    SLA A
    INC A
    LD  [HL], A
    LD  BC, 32
    ADD HL, BC
    INC A
    LD  [HL], A

    POP AF
    SRL A
    SRL A
    SRL A
    SRL A
    SLA A
    INC A
    INC A
    DEC HL
    LD  [HL], A
    LD  BC, -32
    ADD HL, BC
    DEC A
    LD  [HL], A
    POP HL
    RET

;==========================================
;::SHOW_HALF_QUEST
;==========================================
SHOW_HALF_QUEST
    CALL    DISSCR
    CALL    LOAD_HALF_QUEST
    LD      HL, MWORK.CAMERA_SCREEN
    LD      B, 2
.LOOP
    PUSH    BC
    LD      B, 0
    XOR     A
.LOOPBANK
    LD      [HL], A
    INC     HL
    INC     A
    DJNZ    .LOOPBANK
    POP     BC
    DJNZ    .LOOP

    HALT

    LD      HL, MWORK.CAMERA_SCREEN
    LD      DE, NAMTBL
    LD      B, 48
    CALL    MSUPPORT.UFLDIRVM
    CALL    ENASCR
    CALL    MSUPPORT.INIT_SPRITES_SIZE

    LD      HL, .TEXT0
    LD      DE, NAMTBL+32*8*2
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS

    LD      HL, .TEXT1
    LD      DE, NAMTBL+32*8*2+32*2
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS

    LD      HL, .TEXT2
    LD      DE, NAMTBL+32*8*2+32*4
    CALL    WRITE_TEXT

    LD      HL, .TEXT3
    LD      DE, NAMTBL+32*8*2+32*6
    CALL    WRITE_TEXT

    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS

    JP      INIT_LEVEL_CONTINUE


.TEXT0      DB  _SP, _A, _M, _Y, _AD, _SP, _T, _H, _E, _R, _E, _SP, _A, _R, _E, _SP, _M, _O, _R, _E, _SP, _S, _U, _R, _V, _I, _V, _O, _R, _S, _SP, _SP
.TEXT1      DB  _SP, _T, _H, _E, _Y, _SP, _A, _R, _E, _SP, _C, _A, _L, _L, _I, _N, _G, _SP, _B, _Y, _SP, _P, _H, _O, _N, _E, _SP, _SP, _SP, _SP, _SP, _SP   
.TEXT2      DB  _SP, _LI, _SP, _O, _K, _AD, _SP, _I, _SP, _H, _O, _P, _E, _SP, _T, _H, _E, _Y, _SP, _A, _R, _E, _SP, _N, _O, _T, _SP, _SP, _SP, _SP, _SP, _SP
.TEXT3      DB  _SP, _G, _R, _E, _E, _N, _SP, _N, _O, _R, _SP, _B, _L, _U, _E, _SP, _W, _H, _E, _N, _SP, _I, _SP, _A, _R, _R, _I, _V, _E, _AD, _SP, _SP    
.TEXT4      DB  _SP, _SP, _SP, _SP, _SP, _C, _O, _N, _T, _I, _N, _U, _E, _SP, _T, _H, _E, _SP, _G, _A, _M, _E, _SP, _W, _I, _T, _H, _SP, _SP, _SP, _SP, _SP    
.TEXT5      DB  _SP, _SP, _SP, _SP, _SP, _SP, _T, _H, _E, _SP, _P, _H, _Y, _S, _I, _C, _A, _L, _SP, _E, _D, _I, _T, _I, _O, _N, _SP, _SP, _SP, _SP, _SP, _SP


;==========================================
;::LOAD_HALF_QUEST
;==========================================
LOAD_HALF_QUEST
    CALL  MSCREEN.CLEAR_SCREEN 

    LD    HL, MDATAP0.HALF_QUEST_PATTERNS_0
    LD    DE, CHRTBL
    CALL  LOAD_BANK

    LD    HL, MDATAP0.HALF_QUEST_PATTERNS_1
    LD    DE, CHRTBL+32*8*8
    CALL  LOAD_BANK

    LD    BC, 32*8*8            ;RESET BUFFER OF BANK
    LD    DE, MWORK.TMP_UNZIP
    CALL  MSUPPORT.RESET_BIG_RAM

    CALL SETGAMEPAGE0
    LD    HL, MDATAP0.ALPHABET_PATTERNS
    LD    DE, MWORK.TMP_UNZIP + 224*8    ;LOAD ALPHABET IN LAST LINE OF BANK
    CALL  PLETTER.UNPACK
    CALL  RESTOREBIOS
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CHRTBL+32*8*8*2
    LD    BC, 32*8*8
    CALL  LDIRVM

    LD    HL, MDATAP0.HALF_QUEST_COLORS_0
    LD    DE, CLRTBL
    CALL  LOAD_BANK

    LD    HL, MDATAP0.HALF_QUEST_COLORS_1
    LD    DE, CLRTBL+32*8*8
    CALL  LOAD_BANK

    LD    BC, 32*8*8            ;RESET BUFFER OF BANK
    LD    DE, MWORK.TMP_UNZIP
    CALL  MSUPPORT.RESET_BIG_RAM

    CALL SETGAMEPAGE0
    LD    HL, MDATAP0.ALPHABET_COLORS
    LD    DE, MWORK.TMP_UNZIP + 224*8    ;LOAD ALPHABET IN LAST LINE OF BANK
    CALL  PLETTER.UNPACK
    CALL    RESTOREBIOS
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CLRTBL+32*8*8*2
    LD    BC, 32*8*8
    CALL  LDIRVM

    RET

;==========================================
;::LOAD_BANK
; IN-> HL ORIGIN, DE->SCREENDEST
;==========================================
LOAD_BANK
    PUSH  DE
    CALL SETGAMEPAGE0
    LD    DE, MWORK.TMP_UNZIP
    CALL  PLETTER.UNPACK
    CALL RESTOREBIOS
    LD    HL, MWORK.TMP_UNZIP
    POP   DE
    LD    BC, 32*8*8
    CALL  LDIRVM
    RET

;==========================================
;::SHOW_INTERMISSION
;==========================================
SHOW_INTERMISSION
    CALL    DISSCR
    CALL    LOAD_INTERMISSION
    CALL    MSCREEN.CLEAR_CAMERA
    LD      HL, MWORK.CAMERA_SCREEN
    LD      B, 3
.LOOP
    PUSH    BC
    LD      B, 0
    XOR     A
.LOOPBANK
    LD      [HL], A
    INC     HL
    INC     A
    DJNZ    .LOOPBANK
    POP     BC
    DJNZ    .LOOP

    HALT

    LD      HL, MWORK.CAMERA_SCREEN
    LD      DE, NAMTBL
    LD      B, 48
    CALL    MSUPPORT.UFLDIRVM
    CALL    ENASCR
    CALL    MSUPPORT.INIT_SPRITES_SIZE

    CALL    GET_RANDOM_INTERMISSION_TEXT
    LD      DE, NAMTBL+32*23
    CALL    WRITE_TEXT
    
        CALL        MSUPPORT.WAIT_SECONDS
        CALL        MSUPPORT.WAIT_SECONDS
 
        RET


;==========================================
;::LOAD_INTERMISSION
;==========================================
LOAD_INTERMISSION

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.INTERMISION_PATTERNS_0
    LD    DE, MWORK.TMP_UNZIP
    CALL  PLETTER.UNPACK
    CALL    RESTOREBIOS    
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CHRTBL
    LD    BC, 32*8*8
    CALL  LDIRVM

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.INTERMISION_PATTERNS_1
    LD    DE, MWORK.TMP_UNZIP
    CALL  PLETTER.UNPACK
    CALL    RESTOREBIOS    
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CHRTBL+32*8*8
    LD    BC, 32*8*8
    CALL  LDIRVM

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.INTERMISION_PATTERNS_2
    LD    DE, MWORK.TMP_UNZIP
    CALL  PLETTER.UNPACK
    CALL    RESTOREBIOS    
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CHRTBL+32*8*8*2
    LD    BC, 32*8*8
    CALL  LDIRVM

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.INTERMISION_COLORS_0
    LD    DE, MWORK.TMP_UNZIP
    CALL  PLETTER.UNPACK
    CALL    RESTOREBIOS    
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CLRTBL
    LD    BC, 32*8*8
    CALL  LDIRVM

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.INTERMISION_COLORS_1
    LD    DE, MWORK.TMP_UNZIP
    CALL  PLETTER.UNPACK
    CALL    RESTOREBIOS    
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CLRTBL+32*8*8
    LD    BC, 32*8*8
    CALL  LDIRVM

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.INTERMISION_COLORS_2
    LD    DE, MWORK.TMP_UNZIP
    CALL  PLETTER.UNPACK
    CALL    RESTOREBIOS    
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CLRTBL+32*8*8*2
    LD    BC, 32*8*8
    CALL  LDIRVM

    RET

;==========================================
;::WRITE_TEXT
;   IN->DE POSITION TO WRITE, HL TEXT
;==========================================
WRITE_TEXT
    LD    BC, 32
    CALL  LDIRVM

    RET 

;=======================================
;::GET_RANDOM_INTERMISSION_TEXT
; OUT->HL TEXT
;=======================================
GET_RANDOM_INTERMISSION_TEXT
    LD      A, [MWORK.ANIMATION_TICK]
    AND     7
    SLA     A
    LD      C, A
    LD      B, 0
    LD      HL, .INTERMISSIONTEXTS
    ADD     HL, BC
    LD      E, [HL]
    INC     HL
    LD      D, [HL]
    EX      DE, HL
    RET

.INTERMISSIONTEXTS
    DW      .TEXT0
    DW      .TEXT1
    DW      .TEXT2
    DW      .TEXT3
    DW      .TEXT4
    DW      .TEXT5
    DW      .TEXT2
    DW      .TEXT1

.TEXT0      DB _SP, _SP, _SP, _I, _AP, _M, _SP, _S, _O, _SP, _H, _O, _T, _SP, _B, _U, _T, _SP, _I, _AP, _M, _SP, _N, _O, _T, _SP, _F, _O, _O, _D, _AD, _SP
.TEXT1      DB _W, _H, _E, _R, _E, _SP, _A, _R, _E, _SP, _T, _H, _E, _SP, _P, _L, _A, _N, _T, _S, _SP, _T, _O, _SP, _H, _E, _L, _P, _SP, _M, _E, _QU
.TEXT2      DB _I, _SP, _T, _H, _I, _N, _K, _SP, _I, _SP, _W, _I, _L, _L, _SP, _B, _E, _C, _O, _M, _E, _SP, _V, _E, _G, _E, _T, _A, _R, _I, _A, _N    
.TEXT3      DB _SP, _P, _L, _E, _A, _S, _E, _SP, _T, _I, _M, _E, _SP, _O, _U, _T, _AD, _SP, _I, _SP, _N, _E, _E, _D, _SP, _A, _SP, _B, _E, _E, _R, _SP    
.TEXT4      DB _SP, _U, _P, _S, _AD, _SP, _Z, _O, _M, _B, _I, _E, _S, _SP, _A, _T, _E, _SP, _M, _Y, _SP, _N, _E, _I, _G, _H, _B, _O, _U, _R, _S, _SP    
.TEXT5      DB _SP, _SP, _SP, _SP, _SP, _SP, _SP, _SP, _SP, _SP, _I, _SP, _A, _M, _SP, _L, _E, _G, _E, _N, _D, _AD, _SP, _SP, _SP, _SP, _SP, _SP, _SP, _SP, _SP, _SP

;==========================================
;::SHOWENDING
;==========================================
SHOW_ENDING
    LD      A, [MWORK.NUM_OF_CONTINUES]
    CP      K_MAX_CONTINUES_FOR_GOOD_ENDING
    JP      C, SHOW_GOOD_ENDING
    JP      SHOW_BAD_ENDING

;==========================================
;::SHOW_GOOG_ENDING
;==========================================
SHOW_GOOD_ENDING
    CALL    DISSCR
    CALL    LOAD_GOOD_ENDING
    CALL    MSCREEN.CLEAR_SCREEN
    CALL    MSCREEN.CLEAR_CAMERA
    LD      HL, MWORK.CAMERA_SCREEN+32*8
    LD      B, 2
.LOOP
    PUSH    BC
    LD      B, 0
    XOR     A
.LOOPBANK
    LD      [HL], A
    INC     HL
    INC     A
    DJNZ    .LOOPBANK
    POP     BC
    DJNZ    .LOOP

    HALT

    LD      HL, MWORK.CAMERA_SCREEN
    LD      DE, NAMTBL
    LD      B, 48
    CALL    MSUPPORT.UFLDIRVM
    CALL    ENASCR
    CALL    MSUPPORT.INIT_SPRITES_SIZE

    LD    A, MPLAYER.K_KEY_DOWN
    LD    [MWORK.PLAYER_DIRECTION], A
    LD    A, 116
    LD    [MWORK.PLAYER_X], A
    LD    A, 112
    LD    [MWORK.PLAYER_Y], A
    CALL   MPLAYER.SET_PLAYER_FRAME
    HALT
    CALL  MSCREEN.RENDER_SPRITES

    LD      A, K_SONG_3
    CALL    CARGA_CANCION

    LD      HL, .TEXT0
    LD      DE, NAMTBL+32*1
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS


    LD      HL, .TEXT1
    LD      DE, NAMTBL+32*3
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    

    LD      HL, .TEXT2
    LD      DE, NAMTBL+32*5
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    

    LD      HL, .TEXT3
    LD      DE, NAMTBL+32*7
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS

    JP  SHOW_ENDING_STAFF


/*    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    PLAYER_OFF
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS

    JP      MAIN_INTRO
*/
.TEXT0      DB  _SP, _Y, _O, _U, _SP, _H, _A, _V, _E, _SP, _S, _A, _V, _E, _D, _SP, _M, _A, _N, _Y, _SP, _P, _E, _O, _P, _L, _E, _SP, _SP, _SP, _SP, _SP
.TEXT1      DB  _SP, _I, _N, _SP, _T, _I, _M, _E, _AD, _SP, _S, _O, _M, _E, _SP, _O, _F, _SP, _T, _H, _E, _M, _SP, _S, _C, _I, _E, _N, _T, _I, _S, _T    
.TEXT2      DB  _SP, _W, _H, _O, _SP, _H, _A, _V, _E, _SP, _B, _E, _E, _N, _SP, _A, _B, _L, _E, _SP, _T, _O, _SP, _C, _O, _N, _T, _A, _I, _N, _SP, _SP
.TEXT3      DB  _SP, _T, _H, _E, _SP, _E, _P, _I, _D, _E, _M, _I, _C, _SP, _LI, _W, _E, _L, _L, _SP, _D, _O, _N, _E, _SP, _A, _M, _Y, _AD, _SP, _SP, _SP

;==========================================
;::LOAD_GOOD_ENDING
;==========================================
LOAD_GOOD_ENDING
    CALL  MSCREEN.CLEAR_SCREEN
    
    LD    BC, 32*8*8            ;RESET BUFFER OF BANK0
    LD    DE, MWORK.TMP_UNZIP
    CALL  MSUPPORT.RESET_BIG_RAM

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.ALPHABET_PATTERNS
    LD    DE, MWORK.TMP_UNZIP + 224*8    ;LOAD ALPHABET IN LAST LINE OF BANK0
    CALL  PLETTER.UNPACK
    CALL RESTOREBIOS
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CHRTBL
    LD    BC, 32*8*8
    CALL  LDIRVM

    LD    HL, MDATAP0.COMMON_ENDING_PATTERNS_1
    LD    DE, CHRTBL+32*8*8
    CALL  LOAD_BANK

    LD    HL, MDATAP0.GOOD_ENDING_PATTERNS_2
    LD    DE, CHRTBL+32*8*8*2
    CALL  LOAD_BANK

    LD    BC, 32*8*8            ;RESET BUFFER OF BANK0
    LD    DE, MWORK.TMP_UNZIP
    CALL  MSUPPORT.RESET_BIG_RAM

    CALL    SETGAMEPAGE0
    LD    HL, MDATAP0.ALPHABET_COLORS
    LD    DE, MWORK.TMP_UNZIP + 224*8
    CALL  PLETTER.UNPACK
    CALL RESTOREBIOS

    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CLRTBL
    LD    BC, 32*8*8
    CALL  LDIRVM

    LD    HL, MDATAP0.COMMON_ENDING_COLORS_1
    LD    DE, CLRTBL+32*8*8
    CALL  LOAD_BANK

    LD    HL, MDATAP0.GOOD_ENDING_COLORS_2
    LD    DE, CLRTBL+32*8*8*2
    CALL  LOAD_BANK
    

    RET


;==========================================
;::SHOW_BAD_ENDING
;==========================================
SHOW_BAD_ENDING
    CALL    DISSCR
    CALL    LOAD_BAD_ENDING
    CALL    MSCREEN.CLEAR_SCREEN
    CALL    MSCREEN.CLEAR_CAMERA
    LD      HL, MWORK.CAMERA_SCREEN+32*8
    LD      B, 2
.LOOP
    PUSH    BC
    LD      B, 0
    XOR     A
.LOOPBANK
    LD      [HL], A
    INC     HL
    INC     A
    DJNZ    .LOOPBANK
    POP     BC
    DJNZ    .LOOP

    HALT

    LD      HL, MWORK.CAMERA_SCREEN
    LD      DE, NAMTBL
    LD      B, 48
    CALL    MSUPPORT.UFLDIRVM
    CALL    ENASCR
    CALL    MSUPPORT.INIT_SPRITES_SIZE

    LD    A, MPLAYER.K_KEY_DOWN
    LD    [MWORK.PLAYER_DIRECTION], A
    LD    A, 116
    LD    [MWORK.PLAYER_X], A
    LD    A, 112
    LD    [MWORK.PLAYER_Y], A
    CALL   MPLAYER.SET_PLAYER_FRAME
    HALT
    CALL  MSCREEN.RENDER_SPRITES

    LD      A, K_SONG_GAME_OVER
    CALL    CARGA_CANCION

    LD      HL, .TEXT0
    LD      DE, NAMTBL+32*1
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS

    LD      HL, .TEXT1
    LD      DE, NAMTBL+32*3
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS

    LD      HL, .TEXT2
    LD      DE, NAMTBL+32*5
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS

    LD      HL, .TEXT3
    LD      DE, NAMTBL+32*7
    CALL    WRITE_TEXT
    CALL    MSUPPORT.WAIT_SECONDS

    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    LD      A, K_SONG_3
    CALL    CARGA_CANCION

    CALL    MSUPPORT.WAIT_SECONDS
    CALL        SHOW_ENDING_STAFF
    /*
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    MSUPPORT.WAIT_SECONDS
    CALL    PLAYER_OFF

    JP      MAIN_INTRO
*/
.TEXT0      DB  _SP, _S, _O, _R, _R, _Y, _SP, _A, _M, _Y, _SP, _Y, _O, _U, _SP, _A, _R, _R, _I, _V, _E, _SP, _T, _O, _O, _SP, _L, _A, _T, _E, _SP, _SP
.TEXT1      DB  _SP, _Z, _O, _M, _B, _I, _E, _S, _SP, _W, _E, _N, _T, _SP, _T, _O, _SP, _R, _E, _S, _E, _A, _R, _C, _H, _SP, _SP, _SP, _SP, _SP, _SP, _SP
.TEXT2      DB  _SP, _F, _A, _C, _I, _L, _T, _Y, _SP, _A, _N, _D, _SP, _P, _O, _L, _L, _U, _T, _E, _D, _SP, _T, _H, _E, _SP, _R, _I, _V, _E, _R
.TEXT3      DB  _SP, _T, _H, _E, _SP, _E, _P, _I, _D, _E, _M, _I, _C, _SP, _W, _I, _L, _L, _SP, _S, _P, _R, _E, _A, _D, _AD, _SP, _SP, _SP, _SP, _SP


;==========================================
;::LOAD_BAD_ENDING
;==========================================
LOAD_BAD_ENDING
    CALL  MSCREEN.CLEAR_SCREEN
    
    LD    BC, 32*8*8            ;RESET BUFFER OF BANK0
    LD    DE, MWORK.TMP_UNZIP
    CALL  MSUPPORT.RESET_BIG_RAM

    CALL  SETGAMEPAGE0
    LD    HL, MDATAP0.ALPHABET_PATTERNS
    LD    DE, MWORK.TMP_UNZIP + 224*8    ;LOAD ALPHABET IN LAST LINE OF BANK0
    CALL  PLETTER.UNPACK
    CALL  RESTOREBIOS

    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CHRTBL
    LD    BC, 32*8*8
    CALL  LDIRVM

    LD    HL, MDATAP0.COMMON_ENDING_PATTERNS_1
    LD    DE, CHRTBL+32*8*8 
    CALL  LOAD_BANK
  
    LD    HL, MDATAP0.BAD_ENDING_PATTERNS_2
    LD    DE, CHRTBL+32*8*8*2
    CALL  LOAD_BANK

    LD    BC, 32*8*8            ;RESET BUFFER OF BANK0
    LD    DE, MWORK.TMP_UNZIP
    CALL  MSUPPORT.RESET_BIG_RAM

    CALL  SETGAMEPAGE0
    LD    HL, MDATAP0.ALPHABET_COLORS
    LD    DE, MWORK.TMP_UNZIP + 224*8
    CALL  PLETTER.UNPACK
    CALL  RESTOREBIOS
    LD    HL, MWORK.TMP_UNZIP
    LD    DE, CLRTBL
    LD    BC, 32*8*8
    CALL  LDIRVM

    LD    HL, MDATAP0.COMMON_ENDING_COLORS_1
    LD    DE, CLRTBL+32*8*8
    CALL  LOAD_BANK

    LD    HL, MDATAP0.BAD_ENDING_COLORS_2
    LD    DE, CLRTBL+32*8*8*2
    CALL  LOAD_BANK

    RET

;========================================
;::SHOW_ENDING_STAFF
;========================================
SHOW_ENDING_STAFF
                        CALL    DISSCR
                        CALL    MSCREEN.CLEAR_SCREEN   
                        CALL    LOAD_STAFF_TILES 
                        CALL    ENASCR

                        LD      HL, MWORK.TMP_UNZIP+32
                        LD      DE, .INDEX

.MAIN_LOOP              LD      B, 25
.LOOP                   HALT
                        DJNZ    .LOOP

                        LD      A, [DE]
                        INC     DE
                        PUSH    DE
                        CP      0
                        JP      Z, .WRITE_BLANK
                        CP      MWORK.K_EOF
                        JP      Z, .END

                        LD      DE, MWORK.CAMERA_SCREEN+23*32
                        LD      BC, 32
                        LDIR

.DO_SCROLL              CALL    DO_SCROLL
                        POP     DE
                        JP      .MAIN_LOOP

.END                    POP     DE
                        CALL    MSUPPORT.WAIT_SECONDS
                        CALL    MSUPPORT.WAIT_FEW_SECONDS
                        CALL    PLAYER_OFF
                        JP      MAIN_INTRO

.WRITE_BLANK            PUSH    HL
                        LD      HL, MWORK.TMP_UNZIP
                        LD      BC, 32
                        LD      DE, MWORK.CAMERA_SCREEN+23*32
                        LDIR
                        POP     HL
                        JP      .DO_SCROLL


.INDEX          DB  1, 0, 0, 0     ;STAFF
                DB  1, 0, 1, 0, 0, 0 ;ARDUDBOY
                DB  1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0 ;PIXEL ART
                DB  1, 0, 1, 0, 0, 0     ; MUSIC
                DB  1, 0, 1 ; PENTACOUR 
                DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                DB  0, 0, 0, MWORK.K_EOF


;========================================
;::LOAD_STAFF_TILES
;========================================
LOAD_STAFF_TILES
                        CALL    SETGAMEPAGE0
                        LD      HL, MDATAP0.STAFF_PATTERNS
                        LD      DE, MWORK.TMP_UNZIP
                        CALL    PLETTER.UNPACK
                        CALL    RESTOREBIOS    
                        LD      HL, MWORK.TMP_UNZIP
                        LD      DE, CHRTBL
                        LD      BC, 32*8*8
                        CALL    LDIRVM

                        LD      HL, MWORK.TMP_UNZIP
                        LD      DE, CHRTBL+32*8*8
                        LD      BC, 32*8*8
                        CALL    LDIRVM

                        LD      HL, MWORK.TMP_UNZIP
                        LD      DE, CHRTBL+32*8*8*2
                        LD      BC, 32*8*8
                        CALL    LDIRVM

                        CALL    SETGAMEPAGE0
                        LD      HL, MDATAP0.STAFF_COLORS
                        LD      DE, MWORK.TMP_UNZIP
                        CALL    PLETTER.UNPACK
                        CALL    RESTOREBIOS    
                        LD      HL, MWORK.TMP_UNZIP
                        LD      DE, CLRTBL
                        LD      BC, 32*8*8
                        CALL    LDIRVM

                        LD      HL, MWORK.TMP_UNZIP
                        LD      DE, CLRTBL+32*8*8
                        LD      BC, 32*8*8
                        CALL    LDIRVM

                        LD      HL, MWORK.TMP_UNZIP
                        LD      DE, CLRTBL+32*8*8*2
                        LD      BC, 32*8*8
                        CALL    LDIRVM
 
                        
                        
                        CALL    SETGAMEPAGE0
                        LD      HL, MDATAP0.STAFF_TILES
                        LD      DE, MWORK.TMP_UNZIP
                        CALL    PLETTER.UNPACK
                        CALL    RESTOREBIOS  
                        EI
                        RET






;========================================
;::DO_SCROLL
;========================================
DO_SCROLL
                        PUSH    HL
                        PUSH    DE
                        LD      HL, MWORK.CAMERA_SCREEN+32
                        LD      DE, MWORK.CAMERA_SCREEN
                        LD      BC, 23*32
                        LDIR

                        HALT
                        LD      HL, MWORK.CAMERA_SCREEN
                        LD      DE, NAMTBL
                        LD      B, 14;48
                        CALL    MSUPPORT.UFLDIRVM

                        POP     DE
                        POP     HL
                        RET

;=========================================
;::TRATE_PAUSE
;=========================================
TRATE_PAUSE
    CALL    PLAYER_OFF
    LD      B, 30

    LD    HL, FX_TAKE ;//TODO Mejorar
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

.WaitLoop
    HALT
    DJNZ    .WaitLoop
.CheckF1
    HALT
    LD      A, 6 ;F1
    CALL    SNSMAT
    AND     32
    CP      0
    JR      NZ, .CheckF1

    LD    HL, FX_TAKE ;//TODO Mejorar
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

    LD      B, 30
.WaitLoop2
    HALT
    DJNZ    .WaitLoop2


    LD      A, [MWORK.SURVIVORS_TO_SAVE]
    CP  0
    JP  Z, .RUN_MUSIC

    LD A, [MWORK.CURRENT_SONG]
    CALL    CARGA_CANCION
    RET
.RUN_MUSIC
       DI
    PUSH  IX
    LD    A, K_SONG_RUN
    CALL  CARGA_CANCION
    POP   IX
    EI
    RET

;========================================
;::SHOW_GAME_OVER
;========================================
SHOW_GAME_OVER  
                                CALL    PLAYER_OFF
                                CALL    MSCREEN.CLEAR_SCREEN
                                LD      HL, MDATA.TITLES_PATTERNS
                                LD      DE, MDATA.TITLES_COLORS
                                CALL    LOAD_TILE_SET_ONE_BANK
                                LD      A, K_SONG_GAME_OVER
                                CALL    CARGA_CANCION
                                LD      HL, MWORK.CAMERA_SCREEN+6*32+9
                                LD      A, 61
                                LD      B, 14

.LOOPUP                         LD      [HL], A
                                INC     HL
                                INC     A
                                DJNZ    .LOOPUP

                                LD      HL, MWORK.CAMERA_SCREEN+7*32+9
                                LD      A, 75
                                LD      B, 14

.LOOPDOWN                       LD      [HL], A
                                INC     HL
                                INC     A
                                DJNZ    .LOOPDOWN

                                LD      HL, MWORK.CAMERA_SCREEN+9*32+18
                                CALL    RENDER_BONUS_POINTS
                                HALT
                                LD      HL, MWORK.CAMERA_SCREEN
                                LD      DE, NAMTBL
                                LD      B, 48
                                CALL    MSUPPORT.UFLDIRVM
                                CALL    SHOW_PRESS_SPACE_TO_CONTINUE
                                JP      Z, MAIN_INTRO

                                LD      A, 1
                                LD      [MWORK.ALREADY_CONTINUE], A
                                LD      A, [MWORK.NUM_OF_CONTINUES]
                                INC     A
                                LD      [MWORK.NUM_OF_CONTINUES], A
                                CP      K_MAX_CONTINUES_FOR_GOOD_ENDING
                                JP      C, .CONTINUE
                                LD      A, K_MAX_CONTINUES_FOR_GOOD_ENDING
                                LD      [MWORK.NUM_OF_CONTINUES], A
.CONTINUE                       LD      A, MWORK.K_INITIAL_PLAYER_LIVES
                                LD      [MWORK.PLAYER_LIVES], A
                                JP      MAIN_INIT_LEVEL


_SP EQU 224
_A EQU 225
_B EQU 226
_C EQU 227
_D EQU 228
_E EQU 229
_F EQU 230
_G EQU 231
_H EQU 232
_I EQU 233
_J EQU 234
_K EQU 235
_L EQU 236
_M EQU 237
_N EQU 238
_O EQU 239
_P EQU 240
_Q EQU 241
_R EQU 242
_S EQU 243
_T EQU 244
_U EQU 245
_V EQU 246
_W EQU 247
_X EQU 248
_Y EQU 249
_Z EQU 250
_AD EQU 251
_QU EQU 252    
_LI EQU 253
_AP EQU 254    

 ENDMODULE
