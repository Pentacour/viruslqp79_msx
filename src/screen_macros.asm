;============================================
;::MRENDER_SCOREBOARD
;============================================
 macro MRENDER_SCOREBOARD
    LD    de, MWORK.CAMERA_SCREEN
    CALL  RENDER_LIVES
    CALL        TRATE_HI_SCORE

    LD    de, MWORK.CAMERA_SCREEN+24 
    LD      HL, MWORK.PLAYER_POINTS
    CALL  RENDER_POINTS
    LD    de, MWORK.CAMERA_SCREEN+15 ;19
    LD      HL, MWORK.HI_SCORE
    CALL    RENDER_POINTS 
    
                DEC     DE
                LD      A, 218
                LD      [DE], A

                DEC     DE ;SC
                LD      A, 215
                LD      [DE], A
                DEC     DE
                LD      A, 214
                LD      [DE], A


    LD    de, MWORK.CAMERA_SCREEN+32
    CALL  RENDER_BULLETS
    LD    de, MWORK.CAMERA_SCREEN+29
    CALL  RENDER_SURVIVORS
 endmacro


