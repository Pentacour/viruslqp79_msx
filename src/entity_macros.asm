;==================================
;::MDEC_CURRENT_NUMBER_OF_ZOMBIES
;==================================
 macro MDEC_CURRENT_NUMBER_OF_ZOMBIES
	LD    a, [MWORK.CURRENT_NUMBER_OF_ZOMBIES]
 	DEC   a
 	LD    [MWORK.CURRENT_NUMBER_OF_ZOMBIES], a
 endmacro

;==================================
;::MDEC_CURRENT_NUMBER_OF_SHOOTS
;==================================
  macro MDEC_CURRENT_NUMBER_OF_SHOOTS
	LD    a, [MWORK.CURRENT_NUMBER_OF_SHOOTS]
  	DEC   a
  	LD    [MWORK.CURRENT_NUMBER_OF_SHOOTS], a
  endmacro

;================================
;::MMOVE_ZOMBIE_UP
;================================
 macro MMOVE_ZOMBIE_UP
    LD    [ix+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_UP
    LD    a, [ix+K_OFFSET_Y]
    SUB   8
    LD    c, a
    LD    [ix+K_OFFSET_Y], c
    LD    b, [ix+K_OFFSET_X]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  MPLAYER.CAN_GO
    CALL  z, IS_FREE_OF_ZOMBIE

    JP    z, TRATE_ZOMBIE_RENDER
 endmacro

;==================================
;::MMOVE_ZOMBIE_LEFT
;==================================
 macro MMOVE_ZOMBIE_LEFT
    LD    [ix+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_LEFT
    LD    a, [ix+K_OFFSET_X]
    SUB   8
    LD    [ix+K_OFFSET_X], a
    LD    b, a
    LD    c, [ix+K_OFFSET_Y]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  MPLAYER.CAN_GO
    CALL  z, IS_FREE_OF_ZOMBIE
    JP    z, TRATE_ZOMBIE_RENDER
 endmacro

;====================================
;::MMOVE_ZOMBIE_RIGHT
;====================================
 macro MMOVE_ZOMBIE_RIGHT
    LD    [ix+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_RIGHT
    LD    a, [ix+K_OFFSET_X]
    ADD   8
    LD    b, a
    LD    [ix+K_OFFSET_X], b
    LD    c, [ix+K_OFFSET_Y]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  MPLAYER.CAN_GO
    CALL  z, IS_FREE_OF_ZOMBIE
    JP    z, TRATE_ZOMBIE_RENDER
 endmacro

;=======================================
;::MMOVE_ZOMBIE_DOWN
;=======================================
 macro MMOVE_ZOMBIE_DOWN
    LD    [ix+K_OFFSET_ZOMBIE_DIR], K_ZOMBIE_DOWN
    LD    a, [ix+K_OFFSET_Y]
    ADD   8
    LD    [ix+K_OFFSET_Y], a
    LD    c, a
    LD    b, [ix+K_OFFSET_X]
    LD    [MWORK.PARAM_CAN_GO_Y], bc
    CALL  MPLAYER.CAN_GO
    CALL  z, IS_FREE_OF_ZOMBIE
    JP    z, TRATE_ZOMBIE_RENDER
 endmacro
