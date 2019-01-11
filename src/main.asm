                OUTPUT          lqp79.rom
                DEFPAGE         0, $0000, $4000         ; PAGE WITH DATA    
                DEFPAGE         1, $4000, $8000          ; PAGE WITH LOGIC
        ;        DEFPAGE         2, $8000, $4000          ; PAGE WITH LOGIC

                MAP             $C000                   ; RAM

                PAGE            0
                CODE            @ $0000
                DW              $0000                   

                INCLUDE         "data_p0.asm"   

                PAGE            1
                CODE            @ $4000
                DB              $41, $42                ; ROM
                DW              INIT                    ; START ADDRESS
                DW              0, 0, 0, 0, 0, 0

                INCLUDE         "main_macros.asm"
                INCLUDE         "bios.asm"
                INCLUDE         "setpages.asm"
                INCLUDE         "game.asm"
                INCLUDE         "screen.asm"
                INCLUDE         "support.asm"
                INCLUDE         "unpack.asm"

ACTIVE_BIOS     CALL            RESTOREBIOS
                EI
                RET 

QUIT_BIOS       DI
                CALL            SETGAMEPAGE0
                RET

INIT            DI
                IM              1
                LD              SP, [HIMEM]        
                CALL            SETPAGES48K
                CALL            RESTOREBIOS

                LD              A, 2                    ; SCREEN 2
                CALL            CHGMOD
                XOR             A                       ; CLICK SOUND OFF
                LD              [CLIKSW], A     
                LD              A, 0                    ; BORDER COLOR
                LD              [BDRCLR], A
                CALL            INIGRP

                LD              A, 0
                LD              [MWORK.HI_SCORE], A
                LD              A, 0x10
                LD              [MWORK.HI_SCORE+1], A
                XOR             A
                LD              [MWORK.HI_SCORE+2], A

                CALL            INIT_MUSIC
MAIN_INTRO      JP              MGAME.SHOW_INTRO
MAIN_SEL_GAME   JP              MGAME.SHOW_SELECT_GAME
MAIN_INIT_GAME  JP              MGAME.INIT_GAME
MAIN_INIT_LEVEL JP              MGAME.INIT_LEVEL
MAIN_INIT_LEVEL_CONTINUE

GAME_LOOP
                XOR             A
                LD              [MWORK.CAMERA_CHANGED], A

                MF1PAUSE
                MINC_ANIMATION_TICK

                CALL            MPLAYER.MOVE_PLAYER
                CALL            MSCREEN.UPDATE_CAMERA
                CALL            ENTITY.TRATE_ENTITIES
                CALL            MPLAYER.SET_PLAYER_FRAME
                CALL            MPLAYER.CHARGE_BULLETS
                CALL            MSCREEN.RENDER

                MRESET_SPRITES

                JP              GAME_LOOP

                INCLUDE         "music.asm"
                INCLUDE         "player.asm"
                INCLUDE         "entity.asm"

                INCLUDE         "data.asm"

                INCLUDE         "work.asm"                

