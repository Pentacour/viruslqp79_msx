
		.filename "virus_songs"
		.page	1
		.size	32			;ROM de 32KB
		.ROM
		.BIOS


; VARIABLES DEL SISTEMA

CLIKSW		EQU	$F3DB

;CONTROL DE LAS INTERRUPCIONES

;HOOK		EQU	$FD9A



; AJUSTES INICIALES

SPOINT:		.search				;ROM de 32KB




;AJUSTES
		DI
		CALL PLAYER_OFF

; MUSICA DATOS INICIALES

LD	HL,BUFFER_CANAL_A	;RESERVAR MEMORIA PARA BUFFER DE SONIDO!!!!!
		LD	[CANAL_A],HL		;RECOMENDABLE $10 O MAS BYTES POR CANAL.

		LD	HL,BUFFER_CANAL_B
		LD	[CANAL_B],HL

		LD	HL,BUFFER_CANAL_C
		LD	[CANAL_C],HL

		LD	HL,BUFFER_CANAL_P
		LD	[CANAL_P],HL

		
		
	
				
		LD	A,0			;REPRODUCIR LA CANCION N� 0
		CALL	CARGA_CANCION





;INICIA INTERRUPCIONES

		LD	HL,INICIO
		LD	[HOOK+1],HL
		LD	A,$C3
		LD	[HOOK],A
		EI
		LD	A,$0E
		LD	[PSG_REG+13],A


		LD A,0
		LD [SONG_IDX], A ; song index is 0
		
		
		;LD HL, SONIDO0
		;LD [PUNTERO_SONIDO],HL
		;LD      HL,INTERR       ;CARGA CANCION
		;SET     2,[HL] 
		
LOOP:	

CHECK_KEY:		
		XOR   a
		CALL  GTSTCK
		CP    0
		JP    z, LOOP
		

		;1->UP
		;2->UP_RIGHT
		;3->RIGHT
		;4->DOWN_RIGHT
		;5->DOWN

		CP    1 ;UP
		JP    z, PLAY_SOUND_0	
		CP    3 ;RIGHT
		JP    z, PLAY_SOUND_1
		CP    5 ;DOWN
		JP    z, PLAY_SONG_0
		CP    7 ;LEFT: PLAY NEW SONG
		JP    z, PLAY_SONG_1

		JP	LOOP
	
PLAY_SOUND_0:	
		LD    HL, SONIDO0            ;DIRECCION DEL EFECTO QUE TIENE QUE SONAR
		JP    CONTINUE_SOUND

PLAY_SOUND_1:	
		LD    HL, SONIDO1            ;DIRECCION DEL EFECTO QUE TIENE QUE SONAR
		JP    CONTINUE_SOUND

CONTINUE_SOUND:		
		LD    [PUNTERO_SONIDO],HL
		LD    HL,INTERR       ;ACTIVA EFECTO
		SET   2,[HL] 
		JP DELAY_KEY

PLAY_SONG_0:	
		LD	A,0			;REPRODUCIR LA CANCION N� 0
		JP CONTINUE_SONG

PLAY_SONG_1:	;PLAY NEW SONG
		LD	A,1			;REPRODUCIR LA CANCION N� 0
		JP CONTINUE_SONG
		
CONTINUE_SONG:		
		CALL	CARGA_CANCION

		DELAY_KEY:
		LD	BC,$2FFF
		CALL DELAY
		JP    LOOP

; SUBRUTINA
DELAY:
		NOP
        DEC BC
        LD A,B
        OR C
        RET Z
		JP DELAY
		
;archivo de instrumentos


.INCLUDE	"virusGAME_sinO7.MUS.asm"


SONG_0:		.INCBIN	"virusGAME_sinO7.MUS" ;
SONG_1:		.INCBIN	"level1_getout.MUS" ;


TABLA_SONG:	DW	SONG_0, SONG_1

;c�digo del player

.INCLUDE	"WYZProplay47cMSX_JVWYZ.asm"

TAM_CANAL	EQU $40
BUFFER_CANAL_A EQU	INTERR+$100
BUFFER_CANAL_B EQU	BUFFER_CANAL_A+TAM_CANAL
BUFFER_CANAL_C EQU	BUFFER_CANAL_B+TAM_CANAL
BUFFER_CANAL_P EQU	BUFFER_CANAL_C+TAM_CANAL

SONG_IDX EQU BUFFER_CANAL_C+TAM_CANAL+1	
MAX_SONG EQU 3
SOUND_IDX EQU SONG_IDX+2	
MAX_SOUND EQU 5