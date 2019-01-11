                MODULE          MSUPPORT


;======================================
;::ResetBigRAM
;  IN->bc size, de destination
;======================================
RESET_BIG_RAM
                XOR             A
                LD              [DE], A
                INC             DE
                DEC             BC
                LD              A, B
                OR              C
                CP              0
                JP              NZ, RESET_BIG_RAM
                RET

;=====================================
;::FILL_CAMERA_INCREMENTAL
;=====================================
FILL_CAMERA_INCREMENTAL
                LD              HL, MWORK.CAMERA_SCREEN
                LD              B, 3
.LOOP
                PUSH            BC
                LD              B, 0
                XOR             A

.LOOP_BANK
                LD              [HL], A
                INC             HL
                INC             A
                DJNZ            .LOOP_BANK
                POP             BC
                DJNZ            .LOOP

                LD              HL, MWORK.CAMERA_SCREEN
                LD              DE, NAMTBL
                LD              B, 48
                CALL            MSUPPORT.UFLDIRVM

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


;============================
;SETVRAMADD:    ; --- RUTINA QUE PREPARA UNA DIRECCION EN VRAM PARA ESCRIBIR ---
; --- ENTRADA: de -> direccion de VRAM donde escribir        ---
; --- SALIDA: c -> puerto #0 de escritura del VDP            ---
;============================
SETVRAMADD
    SET   6,d                             ; Activamos el sexto bit del byte alto (normalmente escritura)
    LD    a, [7] ;[VDPDATAWRITE]          ; a = puerto #0 de escritura del VDP
    LD    c,a                             ; c = puerto #0 de escritura del VDP
    INC   c                               ; c = puerto #1 de escritura del VDP
    OUT   [c],e                           ; Escribimos en el VDP el byte bajo de la direccion de destino
    NOP                                   ; Pausa...
    NOP                                   ; Pausa...
    OUT   [c],d                           ; Escribimos en el VDP el byte alto de la direccion de destino
    DEC   c                               ; c = puerto #0 de escritura del VDP
    RET                                   ; Volvemos



;======================================
;UFLDIRVM:       ; --- Volcado de RAM a VRAM version ultra. Usar en el vblank  ---
; --- Entrada: HL = origen en RAM                             ---
; ---          DE = destino en VRAM                           ---
; ---          B = (N. de bloques de 16bytes * 17) MOD 256    ---
;=======================================*/
UFLDIRVM
    CALL  SETVRAMADD                      ; Llamamos a SETVRAMADD
.Loop
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (1)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (2)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (3)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (4)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (5)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (6)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (7)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (8)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (9)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (10)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (11)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (12)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (13)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (14)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (15)
    NOP
    NOP
    OUTI                                    ; out c,[hl] ; inc hl ; dec b (16)
    NOP
    NOP
    DJNZ  .Loop                           ; Cerramos el bucle
    RET                                     ; Volvemos

;============================================
;::INIT_SPRITES_SIZE
;============================================
INIT_SPRITES_SIZE
                LD              A, [RG0SAV+1]                   ; SPRITES 16x16
                OR              00000010B
                LD              B,1
                OUT             [099H],A 
                LD              A,B
                OR              10000000B
                OUT             [099H],A
                RET

;==================================
;::WAIT_FEW_SECONDS
;==================================
WAIT_FEW_SECONDS
    LD    b, 80
.Loop
    HALT
    DJNZ  .Loop
    RET    

;==================================
;::WAIT_SECONDS
;==================================
WAIT_SECONDS
    LD    b, 100
.Loop
    HALT
    DJNZ  .Loop
    RET    


;===================
;YX_TO_OFFSET
;IN->bc=[YX]  b=X c=Y
;OUT->de Offset
;====================
YX_TO_OFFSET
    ld  d, b
    ld  e, c    ;Guardo bc

    srl c   ;Div8
    srl c
    srl c
    ld  l, c
    ld  h, 0
    ADD hl,hl   ;Mul32
    ADD hl,hl
    ADD hl,hl
    ADD hl,hl
    ADD hl,hl

    ld  b, d    ;Recupero bc
    ld  c, e

    srl b   ;Div8
    srl b
    srl b
    ld  c, b
    ld  b, 0
    add hl, bc

    ex  de, hl

    ret


                ENDMODULE