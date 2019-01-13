

FX_PLAYER_SHOOT        equ SONIDO5
;No destaca
FX_ZOMBIE_BYE          equ SONIDO6
FX_ZOMBIE_EXPLODE      equ SONIDO8
FX_TAKE                equ SONIDO7
FX_PLAYER_BIG_SHOOT    equ SONIDO10

INIT_MUSIC
    DI
    CALL    PLAYER_OFF

    LD      HL, MWORK.BUFF_CANAL_A
    LD      [CANAL_A],HL        
    LD      HL, MWORK.BUFF_CANAL_B
    LD      [CANAL_B],HL
    LD      HL,MWORK.BUFF_CANAL_C
    LD      [CANAL_C],HL
    LD      HL,MWORK.BUFF_CANAL_P
    LD      [CANAL_P],HL

    XOR     A    
    LD      [INTERR],A

    CALL    INICIO
    LD      HL,INICIO
    LD      [HOOK+1],HL
    LD      A,$C3
    LD      [HOOK],A
    EI
    RET

K_SONG_1                        EQU 0
K_SONG_2                        equ 1
K_SONG_3                        equ 2
K_SONG_RUN                      equ 3
K_SONG_GAME_OVER                equ 4
K_SONG_INTRO                    EQU 5


TABLA_SONG
    DW SONG_1_LEVEL
    DW MDATA.SONG_2_LEVEL
    DW MDATA.SONG_3_LEVEL
    DW SONG_RUN
    DW MDATA.SONG_GAME_OVER
    DW MDATA.SONG_INTRO
SONG_1_LEVEL
 incbin "rescue1N1v2.mus"      
 ;incbin "game_overN1.mus"
 

;SONG_2_LEVEL
 ;incbin  "level1_rescue.mus"

SONG_RUN
 incbin  "virus_huida.mus"
 ;include "virus_LEVEL1_fx.mus.asm"


 include "sonidosfxN1.mus.asm"
 ;incbin  "level1_getout.mus"
 ;include "level1_getout.mus.asm"

 include "WYZPROPLAY47cMSX.ASM"

