
; Tabla de instrumentos
TABLA_PAUTAS: DW PAUTA_0,PAUTA_1,PAUTA_2,PAUTA_3,PAUTA_4,PAUTA_5,PAUTA_6,PAUTA_7,PAUTA_8,PAUTA_9,PAUTA_10,PAUTA_11,PAUTA_12,PAUTA_13

; Tabla de efectos
TABLA_SONIDOS: DW SONIDO0,SONIDO1,SONIDO2,SONIDO3,SONIDO4

;Pautas (instrumentos)
;Instrumento 'Bajo'
PAUTA_0:	DB	0,0,5,0,10,0,10,0,10,0,9,-13,9,1,8,-2,8,0,8,0,8,0,4,0,0,0,129
;Instrumento 'triririn'
PAUTA_1:	DB	8,0,74,0,11,0,43,0,10,0,72,0,8,0,40,0,8,0,132
;Instrumento 'chip1'
PAUTA_2:	DB	4,0,71,0,8,0,40,0,8,0,70,0,5,0,37,0,5,0,69,0,132
;Instrumento 'ondapitch'
PAUTA_3:	DB	8,0,10,0,11,0,12,0,11,0,11,0,10,0,8,1,8,0,8,0,8,1,8,0,8,0,8,-1,8,0,8,0,8,-1,8,0,8,0,140
;Instrumento 'plain'
PAUTA_4:	DB	8,0,8,0,129
;Instrumento 'Chip2'
PAUTA_5:	DB	5,0,70,0,6,0,37,0,4,0,3,0,129
;Instrumento 'Onda3'
PAUTA_6:	DB	43,0,12,0,12,0,12,0,12,0,11,0,11,0,11,0,11,0,10,0,10,0,10,0,10,0,11,0,11,0,11,0,11,0,136
;Instrumento 'Steel vol1'
PAUTA_7:	DB	78,0,44,0,10,0,8,0,7,0,129
;Instrumento 'Steel vol2'
PAUTA_8:	DB	75,0,41,0,8,0,7,0,6,0,129
;Instrumento 'bassdown'
PAUTA_9:	DB	10,0,6,0,9,0,8,3,7,0,130
;Instrumento 'hellhigh'
PAUTA_10:	DB	8,0,24,1,24,-6,22,6,7,0,132
;Instrumento 'reverse'
PAUTA_11:	DB	1,0,1,0,2,0,2,0,3,0,3,0,4,0,4,0,5,0,5,0,6,0,6,0,7,0,7,0,8,0,8,0,129
;Instrumento 'bell'
PAUTA_12:	DB	11,0,11,0,10,0,8,0,5,0,3,0,1,0,1,0,0,0,129
;Instrumento 'bassup'
PAUTA_13:	DB	10,0,6,0,9,0,8,-3,7,0,130

;Efectos
;Efecto 'bass drum'
SONIDO0:	DB	209,63,0,209,78,0,69,109,0,255
;Efecto 'drum'
SONIDO1:	DB	69,47,0,232,44,5,0,57,2,255
;Efecto 'hithat'
SONIDO2:	DB	0,14,1,0,10,1,255
;Efecto 'bass drum vol 2'
SONIDO3:	DB	186,58,0,0,102,0,162,131,0,255
;Efecto 'noise'
SONIDO4:	DB	0,11,9,0,10,12,0,12,21,0,11,25,0,8,11,255

;Frecuencias para las notas
DATOS_NOTAS: DW 0,0
DW 1711,1614,1524,1438,1358,1281,1210,1142,1078,1017
DW 960,906,855,807,762,719,679,641,605,571
DW 539,509,480,453,428,404,381,360,339,320
DW 302,285,269,254,240,227,214,202,190,180
DW 170,160,151,143,135,127,120,113,107,101
DW 95,90,85,80,76,71,67,64,60,57
