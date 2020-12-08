.data

CONTROL: .word32 0x10000
DATA: .word32 0x10008


COLORES: .word32 0x000000, 0xe8f1ff, 0x532b1d, 0x82769c , 0x4d00ff ,0xa877ff , 0xaaccff, 0x36e400, 0x518700, 0x3652ab, 0x27ecff


ARROW_DER: .byte 0x64
ARROW_IZQ: .byte 0x61
ARROW_ARR: .byte 32
ARROW_ABJ: .byte 32


BACKGROUND: .byte 12,0,1,1,1,2,1,3,1,4,1,5,2,1,2,2,2,3,2,4,2,5,3,1,3,2,3,3,3,4,3,5,4,1,4,2,4,3,4,4,4,5,5,1,5,2,5,3,5,4,5,5,99


;Mapa

MAPA1:	.byte  2,0,0,0,0,0,0,0,0,2
FILA2:	.byte  2,0,0,0,0,0,0,0,0,2
FILA3:	.byte  2,0,0,0,0,0,0,0,0,2
FILA4:	.byte  2,0,0,0,0,0,0,0,0,2
FILA5:	.byte  2,0,0,0,0,0,0,0,0,2
FILA6:	.byte  2,0,0,0,0,0,0,0,0,2
FILA7:	.byte  2,0,0,0,0,0,0,0,0,2
FILA8:	.byte  2,0,0,0,0,0,0,0,0,2
FILA9:	.byte  2,0,0,0,0,0,0,0,0,2
FILA10:	.byte  1,1,1,1,1,1,1,1,1,1




.text
			lwu $s0, DATA($zero)					; $s0 = dirección de DATA
			lwu $s1, CONTROL($zero)					; $s1 = dirección de CONTROL


inicio: 	daddi $t0, $zero, 7						; $t0 = 7 -> función 7: limpiar pantalla gráfica
			sd $t0, 0($s1)							; CONTROL recibe 7 y limpia la pantalla gráfica

			jal DibujarMapa
			halt





; Dibuja toda la matriz del mapa
; Asume:
;   - $A0 cantidad de ciclos de espera
DibujarMapa:	daddi $t0, $zero, 0					; contador de sprites dibujados
				daddi $t1, $zero, 100				; maxima cant de elementos en la matriz
				daddi $t2, $zero, 0					; posicion X del elemento en la matriz
				daddi $t3, $zero, 45				; posicion Y del elemento en la matriz
				daddi $t4, $zero, 50				; tamanio de la fila
				daddi $t5, $zero, 0					; 
				daddi $t6, $zero, 0					; 
				daddi $t7, $zero, 1					; offset de pixeles del objeto a dibujar
				daddi $t8, $zero, 0					; 
				daddi $t9, $zero, 99				; condicion de corte del sprite


dibujar:		beq $t0, $t1, finDibujar 			; si se dibujo toda la matriz, finalizar subrutina
				lbu $t5, MAPA1($t0)					; $s1: dato de la matriz
				daddi $t7, $zero, 1					; offset de pixeles del objeto a dibujar
				daddi $t6, $zero, 2					; condicion de sprite a dibujar 2 == BACKGROUND
				beq $t5, $t6, dibujarBackgr			; $t5 == 2 => dibujar background

dibujarBackgr:	lbu $t6, BACKGROUND($t7)			; carga la posX del sprite a dibujar
				beq $t6, $t9, finElemento			; $t6 == 9 => pasar al siguiente sprite
				dadd $t6, $t6, $t2   				; ajusta posicion X del sprite
				sb $t6, 5($s0)						; DATA+5 recibe el valor de coordenada X
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

				lbu $t6, BACKGROUND($t7)			; carga la posY del sprite a dibujar
				dadd $t6, $t6, $t3   				; ajusta posicion Y del sprite
				sb $t6, 4($s0)						; DATA+4 recibe el valor de coordenada Y
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

													; pintar y mostrar
				lbu $t6, BACKGROUND($zero)  		; $t6 = offset, respecto a NEGRO, del color a pintar
				lwu $t6, COLORES($t6)				; $t6 = color a pintar
				sw $t6, 0($s0)						; DATA recibe el valor del color a pintar
				daddi $t6, $zero, 5					; $t0 = 5 -> función 5: salida gráfica
				sd $t6, 0($s1)						; CONTROL recibe 5 y produce el dibujo del punto
				
				j dibujarBackgr

finElemento:	daddi $t0, $t0, 1					; pasa al siguiente elemento de la matriz
				daddi $t1, $t1, 5					; cambia la coordenada X
				beq	$t1, $t4, sigFila				; x == 50 => j sigFila
				j dibujar

sigFila:		daddi $t1, $t1, 0					; pasa a la sig fila. Pone X en 0
				daddi $t2, $t2, -5					; disminuye Y
				j dibujar

finDibujar:	jr $ra
				

