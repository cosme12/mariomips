.data

CONTROL: .word32 0x10000
DATA: .word32 0x10008


COLORES: .word32 0x000000, 0xe8f1ff, 0x532b1d, 0x82769c , 0x7e2553, 0x4d00ff ,0xa877ff , 0xaaccff, 0x36e400, 0x518700, 0x3652ab, 0x27ecff, 0xff0052


ARROW_DER: .byte 0x64
ARROW_IZQ: .byte 0x61
ARROW_ARR: .byte 32
ARROW_ABJ: .byte 32


BACKGROUND: .byte 12,0,0,1,0,2,0,3,0,4,0,0,1,1,1,2,1,3,1,4,1,0,2,1,2,2,2,3,2,4,2,0,3,1,3,2,3,3,3,4,3,0,4,1,4,2,4,3,4,4,4,99,99,99,99,99,99,99,99,99
BLOQUE: .byte 16,0,0,0,1,0,2,0,3,98,8,1,0,2,0,3,0,98,24,4,0,1,1,2,1,3,1,1,2,2,2,3,2,1,3,2,3,3,3,0,4,98,28,1,4,2,4,3,4,4,1,4,2,4,3,98,4,4,4,99
SUELO1: .byte 40,0,0,1,0,3,0,4,0,0,1,1,1,2,1,3,1,4,1,98,16,2,0,0,2,1,2,2,2,3,2,4,2,98,36,0,3,1,3,2,3,3,3,4,3,1,4,2,4,3,4,4,4,98,32,0,4,99,99,99

JELPI: .byte 28,1,0,3,0,1,3,2,3,3,3,4,3,0,4,2,4,3,4,4,4,0,5,1,5,2,5,3,5,4,5,5,5,0,6,4,6,98,48,1,1,2,1,3,1,98,20,1,2,2,2,3,2,98,24,0,3,5,3,98,8,1,4,5,4,99

;Mapa

MAPA1:	.byte  1,0,0,0,0,0,0,0,0,1
FILA1:	.byte  1,0,0,0,0,0,0,0,0,1
FILA3:	.byte  0,0,0,1,0,0,0,0,0,0
FILA4:	.byte  1,0,0,0,0,0,0,0,0,1
FILA5:	.byte  1,0,0,0,0,0,0,0,0,1
FILA6:	.byte  1,0,0,0,0,0,0,0,0,1
FILA7:	.byte  1,0,0,0,0,0,0,0,0,1
FILA8:	.byte  0,0,0,0,0,0,0,0,0,1
FILA9:	.byte  0,0,0,0,0,0,0,0,0,1
FILA10:	.byte  2,2,2,2,2,2,2,2,2,2




.text
			lwu $s0, DATA($zero)					; $s0 = dirección de DATA
			lwu $s1, CONTROL($zero)					; $s1 = dirección de CONTROL


inicio: 	daddi $t0, $zero, 7						; $t0 = 7 -> función 7: limpiar pantalla gráfica
			sd $t0, 0($s1)							; CONTROL recibe 7 y limpia la pantalla gráfica

			jal DibujarMapa

													; control de personaje
			ld $s2, ARROW_IZQ($zero)  				; $s2 = tecla "<-" izquierda
			ld $s3, ARROW_DER($zero)  				; $s3 = tecla "->" derecha
			jal DibujarPersonaje

			halt





; Dibuja toda la matriz del mapa
; Asume:
;   - $A0 cantidad de ciclos de espera
DibujarMapa:	daddi $t0, $zero, 0					; contador de sprites dibujados
				daddi $t1, $zero, 160				; maxima cant de elementos en la matriz -> 10+6 por fila de matriz
				daddi $t2, $zero, 0					; posicion X del elemento en la matriz
				daddi $t3, $zero, 45				; posicion Y del elemento en la matriz
				daddi $t4, $zero, 50				; tamanio de la fila
				daddi $t5, $zero, 0					; 
				daddi $t6, $zero, 0					; 
				daddi $t7, $zero, 1					; offset de pixeles del objeto a dibujar
				daddi $t8, $zero, 0					; posicion del nuevo color a usar
				daddi $t9, $zero, 99				; condicion de corte del sprite


dibujar:		beq $t0, $t1, finDibujar 			; si se dibujo toda la matriz, finalizar subrutina
				lbu $t5, MAPA1($t0)					; $t5: dato de la matriz
				daddi $t6, $zero, 0					; condicion de sprite a dibujar 0 == BACKGROUND
				daddi $t7, $zero, 1					; offset de pixeles del objeto a dibujar
				beq $t5, $t6, dibujarBackgr			; $t5 == 0 => dibujar background
				daddi $t6, $zero, 1					; condicion de sprite a dibujar 1 == BLOQUE
				daddi $t7, $zero, 65				; offset al siguiente sprite en la lista
				daddi $t8, $zero, 64    			; offset al nuevo color a usar
				beq $t5, $t6, dibujarBackgr			; $t5 == 1 => dibujar BLOQUE
				daddi $t6, $zero, 2					; condicion de sprite a dibujar 2 == SUELO1
				daddi $t7, $zero, 129				; offset al siguiente sprite en la lista
				daddi $t8, $zero, 128  				; offset al nuevo color a usar
				beq $t5, $t6, dibujarBackgr			; $t5 == 2 => dibujar SUELO1
				j finElemento

cambiarColor:	daddi $t7, $t7, 1
				dadd $t8, $zero, $t7				; $t8 guarda offset al nuevo color
				daddi $t7, $t7, 1
				j dibujarBackgr

dibujarBackgr:	lbu $t6, BACKGROUND($t7)			; carga la posX del sprite a dibujar
				beq $t6, $t9, finElemento			; $t6 == 99 => pasar al siguiente sprite
				daddi $t9, $zero, 98				; 
				beq $t6, $t9, cambiarColor			; $t6 == 98 => cambiar de color
				daddi $t9, $zero, 99				;
				dadd $t6, $t6, $t2   				; ajusta posicion X del sprite
				sb $t6, 5($s0)						; DATA+5 recibe el valor de coordenada X
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

				lbu $t6, BACKGROUND($t7)			; carga la posY del sprite a dibujar
				dadd $t6, $t6, $t3   				; ajusta posicion Y del sprite
				sb $t6, 4($s0)						; DATA+4 recibe el valor de coordenada Y
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

													; pintar y mostrar
				lbu $t6, BACKGROUND($t8)  			; $t6 = offset, respecto a NEGRO, del color a pintar
				lwu $t6, COLORES($t6)				; $t6 = color a pintar en hexa
				sw $t6, 0($s0)						; DATA recibe el valor del color a pintar
				daddi $t6, $zero, 5					; $t0 = 5 -> función 5: salida gráfica
				sd $t6, 0($s1)						; CONTROL recibe 5 y produce el dibujo del punto
				
				j dibujarBackgr						; dibujar siguiente pixel


finElemento:	daddi $t0, $t0, 1					; pasa al siguiente elemento de la matriz
				daddi $t2, $t2, 5					; cambia la coordenada X
				daddi $t8, $zero, 0					; reinicia el offset del color
				beq	$t2, $t4, sigFila				; x == 50 => j sigFila
				j dibujar

sigFila:		daddi $t2, $zero, 0					; pasa a la sig fila. Pone X en 0
				daddi $t3, $t3, -5					; disminuye Y
				daddi $t0, $t0, 6
				j dibujar

finDibujar:	jr $ra
				



; Dibuja el personaje
; Asume:
;   - 
DibujarPersonaje: daddi $t2, $zero, 20				; posicion X del elemento en la matriz
				daddi $t3, $zero, 5					; posicion Y del elemento en la matriz
				daddi $t6, $zero, 0					; 
				daddi $t7, $zero, 1					; offset de pixeles del objeto a dibujar
				daddi $t8, $zero, 0					; posicion del nuevo color a usar
				daddi $t9, $zero, 99				; condicion de corte del sprite


dibujarPixel:	lbu $t6, JELPI($t7)					; carga la posX del sprite a dibujar
				beq $t6, $t9, finPersonaje			; $t6 == 99 => termino de dibujar al personaje
				daddi $t9, $zero, 98				; 
				beq $t6, $t9, cambiarColorPersonaje	; $t6 == 98 => cambiar de color
				daddi $t9, $zero, 99				;
				dadd $t6, $t6, $t2   				; ajusta posicion X del sprite
				sb $t6, 5($s0)						; DATA+5 recibe el valor de coordenada X
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

				lbu $t6, JELPI($t7)					; carga la posY del sprite a dibujar
				dadd $t6, $t6, $t3   				; ajusta posicion Y del sprite
				sb $t6, 4($s0)						; DATA+4 recibe el valor de coordenada Y
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

													; pintar y mostrar
				lbu $t6, JELPI($t8)  				; $t6 = offset, respecto a NEGRO, del color a pintar
				lwu $t6, COLORES($t6)				; $t6 = color a pintar en hexa
				sw $t6, 0($s0)						; DATA recibe el valor del color a pintar
				daddi $t6, $zero, 5					; $t0 = 5 -> función 5: salida gráfica
				sd $t6, 0($s1)						; CONTROL recibe 5 y produce el dibujo del punto
				
				j dibujarPixel						; dibujar siguiente pixel

cambiarColorPersonaje:	daddi $t7, $t7, 1
				dadd $t8, $zero, $t7				; $t8 guarda offset al nuevo color
				daddi $t7, $t7, 1
				j dibujarPixel

finPersonaje:   jr $ra