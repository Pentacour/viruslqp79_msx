
;===============================================================
;::MCHECK_M
;==============================================================
 macro MCHECK_M
    LD    a, 4 ;M
    CALL  SNSMAT
    AND   4
    CP    0
    JP    z, .TRATE
    LD    A, 3
    CALL    GTTRIG
    CP      0
    JP      z, .EndMCheckM

.TRATE
    LD    a, [MWORK.PLAYER_BULLETS]
    CP    K_FIREBALL_COST
    JP    c, .EndMCheckM
    SUB   K_FIREBALL_COST
    LD    [MWORK.PLAYER_BULLETS], a

    LD    HL, FX_PLAYER_BIG_SHOOT 
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

    CALL  ADD_NEW_NORMAL_PLAYER_SHOOT
    LD    bc, -5
    ADD   hl, bc
    LD    [hl], ENTITY.K_ENTITY_PLAYER_SHOOT_FIREBALL
.EndMCheckM
 endmacro


;===================================
;::MCHECK_SHOOT
;===================================
 macro MCHECK_SHOOT
    XOR   a
    CALL  GTTRIG
    CP    0
    JP    nz, .SButtonPressed
    LD    a, 1
    CALL  GTTRIG
    CP    0
    JP    nz, .SButtonPressed
    XOR   a
    LD   [MWORK.PLAYER_SPACE_KEY_PRESSED], a
    JP   .EndMCheckShoot

.SButtonPressed
    LD    a, [MWORK.PLAYER_SPACE_KEY_PRESSED]
    CP    1
    JP    z, .EndMCheckShoot
    LD    a, [MWORK.PLAYER_SHOOT_COST]
    LD    b, a
    LD    a, [MWORK.PLAYER_BULLETS]
    CP    b
    JP    c, .PostBulletsCheck
    SUB   b
    LD    [MWORK.PLAYER_BULLETS], a

.PostBulletsCheck
    LD   a, 1
    LD   [MWORK.PLAYER_SPACE_KEY_PRESSED], a
    LD   a, K_SHOOT_WAIT
    LD   [MWORK.PLAYER_SHOOT_WAIT], a
    LD   a, [MWORK.PLAYER_SHOOT_TYPE]
    CP   ENTITY.K_NORMAL_SHOOT
    JP   z, .ShootNormal
    CP   ENTITY.K_DOUBLE_SHOOT
    JP   z, .ShootDouble

    LD  a, 10
    CALL INICIA_SONIDO

    CALL ADD_NEW_PLAYER_TRIPLE_SHOOT
    RET
.ShootNormal
    LD    HL, FX_PLAYER_SHOOT 
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

    CALL ADD_NEW_NORMAL_PLAYER_SHOOT
    RET
.ShootDouble
    LD    HL, FX_PLAYER_SHOOT
    LD    [PUNTERO_SONIDO], HL
    LD    HL,INTERR       
    SET   2,[HL] 

    CALL ADD_NEW_PLAYER_DOUBLE_SHOOT
    RET
.EndMCheckShoot
 endmacro

;====================================
;::MCHECK_IF_VISIBLE
;====================================
 macro MCHECK_IF_VISIBLE
    LD    a, [MWORK.CAMERA_TILE_X_LEFT]
    LD    b, [ix+ENTITY.K_OFFSET_MAP_X]
    CP    b
    JP    nc, .NextEntity
    LD    a, [MWORK.CAMERA_TILE_X_RIGHT]
    CP    b
    JP    c, .NextEntity
    LD    a, [MWORK.CAMERA_TILE_Y_TOP]
    LD    b, [ix+ENTITY.K_OFFSET_MAP_Y]
    CP    b
    JP    nc, .NextEntity
    LD    a, [MWORK.CAMERA_TILE_Y_DOWN]
    CP    b
    JP    c, .NextEntity
 endmacro
