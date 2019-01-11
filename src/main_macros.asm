;==============================================================
;::MIncAnimationTick
;=============================================================
 macro MINC_ANIMATION_TICK
    LD    a, [MWORK.ANIMATION_TICK]
    INC   a
    LD    [MWORK.ANIMATION_TICK], a
    LD    a, [MWORK.ZOMBIES_ANIMATION_TICK]
    INC   a
    LD    [MWORK.ZOMBIES_ANIMATION_TICK], a
    CP    MWORK.K_ZOMBIES_SPEED
    JP    nz, .IncContinue
    XOR   a
    LD    [MWORK.ZOMBIES_ANIMATION_TICK], a
.IncContinue
 endmacro

;==============================================================
;::MF1_PAUSE
;=============================================================
 macro MF1PAUSE
    LD    a, 6 ;F1
    CALL  SNSMAT
    AND   32
    CP    0
    JP    nz, .EndMF1Pause
    CALL  MGAME.TRATE_PAUSE
.EndMF1Pause
 endmacro

;=====================================================
;::MRESET_SPRITES
;=====================================================
 macro MRESET_SPRITES
    LD    a, 209
    LD    [MWORK.SPRITES_TABLE_0], a
    LD    [MWORK.SPRITES_TABLE_1], a
    LD    [MWORK.SPRITES_TABLE_2], a
    LD    [MWORK.SPRITES_TABLE_3], a
    LD    [MWORK.SPRITES_TABLE_4], a
    LD    [MWORK.SPRITES_TABLE_5], a
    LD    [MWORK.SPRITES_TABLE_6], a
    LD    [MWORK.SPRITES_TABLE_7], a
    LD    [MWORK.SPRITES_TABLE_8], a
    LD    [MWORK.SPRITES_TABLE_9], a
    LD    [MWORK.SPRITES_TABLE_10], a
    LD    [MWORK.SPRITES_TABLE_11], a
    LD    hl, ENTITY.SPRITES_TABLE_SEQUENCES
    LD    [MWORK.CURRENT_SPRITES_TABLE], hl
    LD    [MWORK.CURRENT_SPRITES_TABLE_POSITION], hl
 endmacro
 
 ;===================================================
 ;::RESET_SPRITES
 ;===================================================
RESET_SPRITES
    LD    a, 209
    LD    [MWORK.SPRITES_TABLE_0], a
    LD    [MWORK.SPRITES_TABLE_1], a
    LD    [MWORK.SPRITES_TABLE_2], a
    LD    [MWORK.SPRITES_TABLE_3], a
    LD    [MWORK.SPRITES_TABLE_4], a
    LD    [MWORK.SPRITES_TABLE_5], a
    LD    [MWORK.SPRITES_TABLE_6], a
    LD    [MWORK.SPRITES_TABLE_7], a
    LD    [MWORK.SPRITES_TABLE_8], a
    LD    [MWORK.SPRITES_TABLE_9], a
    LD    [MWORK.SPRITES_TABLE_10], a
    LD    [MWORK.SPRITES_TABLE_11], a
    LD    hl, ENTITY.SPRITES_TABLE_SEQUENCES
    LD    [MWORK.CURRENT_SPRITES_TABLE], hl
    LD    [MWORK.CURRENT_SPRITES_TABLE_POSITION], hl
    RET