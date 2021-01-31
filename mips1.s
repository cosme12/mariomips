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
BORRAR_JELPI: .byte 12,1,0,98,12,1,0,3,0,1,3,2,3,3,3,4,3,0,4,2,4,3,4,4,4,0,5,1,5,2,5,3,5,4,5,5,5,0,6,4,6,98,12,1,1,2,1,3,1,98,12,1,2,2,2,3,2,98,12,0,3,5,3,98,12,1,4,5,4,99



;Mapa

MAPA1:	.byte  1,2,0,0,0,0,0,0,0,1
FILA2:	.byte  1,0,0,0,0,0,0,0,0,1
FILA3:	.byte  0,0,0,1,0,0,0,0,0,0
FILA4:	.byte  1,0,0,0,0,0,0,0,0,1
FILA5:	.byte  1,0,0,0,0,0,0,0,0,1
FILA6:	.byte  1,0,0,0,0,0,0,0,0,1
FILA7:	.byte  1,0,0,0,0,0,0,0,0,1
FILA8:	.byte  0,0,0,0,0,0,0,0,0,1
FILA9:	.byte  0,0,1,0,0,0,0,0,0,1
FILA10:	.byte  2,2,2,2,2,2,2,2,2,2


PERS_X: .word 20									; coordenada X inicial del personaje
PERS_Y: .word 5										; coordenada Y inicial del personaje



.text
			lwu $s0, DATA($zero)					; $s0 = dirección de DATA
			lwu $s1, CONTROL($zero)					; $s1 = dirección de CONTROL


inicio: 	daddi $t0, $zero, 7						; $t0 = 7 -> función 7: limpiar pantalla gráfica
			sd $t0, 0($s1)							; CONTROL recibe 7 y limpia la pantalla gráfica

			jal DibujarMapa

													; control de personaje
			ld $s2, ARROW_IZQ($zero)  				; $s2 = tecla "<-" izquierda
			ld $s3, ARROW_DER($zero)  				; $s3 = tecla "->" derecha

			ld $v0, PERS_X($zero)					; se precarga con la pos X actual para el primer ciclo
			ld $a0, PERS_X($zero)					; se precarga con la pos X actual para el primer ciclo
			ld $v1, PERS_Y($zero)					; se precarga con la pos Y actual para el primer ciclo
			ld $a1, PERS_Y($zero)					; se precarga con la pos Y actual para el primer ciclo

													; REPETIR CICLO INFINITO
ciclo_principal: daddi $a2, $zero, 73				; offset de sprite borrar_pj
			daddi $a3, $zero, 72					; offset al nuevo color a usar
			jal DibujarPersonaje					; primero borra el personaje ya dibujado

			sd $v0, PERS_X($zero)					; actualiza pos X del pj
			sd $v1, PERS_Y($zero)					; actualiza pos Y del pj
			dadd $a0, $zero, $v0					; carga pos X del pj
			dadd $a1, $zero, $v1					; carga pos Y del pj
			
			daddi $a2, $zero, 1						; offset de pj
			daddi $a3, $zero, 0						; offset al nuevo color a usar
			jal DibujarPersonaje					; despues lo vuelve a redibujar
			
			jal MoverPersonaje						; verifica colisiones y mueve PJ
			j ciclo_principal

			halt




; Controla los input de teclado. Usa un delay.
; Asume:
;   - $a0 coordenada X del personaje
;	- $a1 coordenada Y del personaje
; Devuelve:
;   - $v0 coordenada X del personaje modificada
MoverPersonaje: daddi $t0, $zero, 9					; modo teclado
				daddi   $t1, $zero, 5000      		; $t1 = ciclos de espera
				daddi $t3, $zero, 5					; $t3 = tamanio de bloque mapa para colision
				daddi $t4, $zero, 0					;
				daddi $t5, $zero, 0					;	
				daddi $t6, $zero, 0					;
				daddi $t7, $zero, 9				; tamanio del mapa (10x10)
				daddi $t9, $zero, 0

				dadd $v0, $zero, $a0				; devuelve la posicion X del pj modificada
				
				sd $t0, 0($s1)						; CONTROL recibe 9 y espera teclado
				ld $t0, 0($s0)						; lee la tecla presionada guardada en DATA
				andi $t0, $t0, 255 					; mascara para quedarse con la tecla presionada
				j delayCycles

teclContinuarCiclo: beq $t0, $s2, colisionIzq	    ; verifica tecla <- presionada
				beq $t0, $s3, colisionDer			; verifica tecla -> preisonada
				j finMoverPersonaje

moverDerecha: 	daddi $v0, $v0, 3					; velocidad de movimiento del pj
				sd $t6, PERS_X($zero)
				j finMoverPersonaje

moverIzquierda: daddi $v0, $v0, -3					; velocidad de movimiento del pj
				sd $t6, PERS_X($zero)
				j finMoverPersonaje

delayCycles:  	daddi $t1, $t1, -1					; queda repitiendo ciclos, evita flickering
              	bnez  $t1, delayCycles
              	j teclContinuarCiclo

colisionIzq:	daddi $a0, $a0, -3					; simula movimiento a la izquierda
				ddiv $t4, $a0, $t3					; divide posX/5 para ver en MAPA
				ddiv $t5, $a1, $t3					; divide posY/5 para ver en MAPA
				daddi $k0, $t4, 0
				daddi $a0, $a0, 3					; le vuelve a sumar 3 para dejarlo original
				dsub $t5, $t7, $t5 					; 9 - $t5 para corregir el eje Y (que va al revez del mapa)
				daddi $k1, $t5, 0
				daddi $t7, $zero, 16
				dmul $t5, $t5, $t7					; multiplica y*16 para avanzar en filas
				dadd $t4, $t4, $t5					; se lo suma a x y obtiene el offset al bloque en el mapa
				lbu $sp, MAPA1($t4)
				lbu $t4, MAPA1($t4)					; carga que hay en el mapa
				daddi $t5, $zero, 0					; 0 = bloque libre 
				beq $t4, $t5, moverIzquierda	 	; 
				j finMoverPersonaje					;

colisionDer:	daddi $a0, $a0, 8					; simula movimiento a la derecha 3+5(del offset del dibujo)
				ddiv $t4, $a0, $t3					; divide posX/5 para ver en MAPA
				ddiv $t5, $a1, $t3					; divide posY/5 para ver en MAPA
				daddi $k0, $t4, 0
				daddi $a0, $a0, -8					; le vuelve a restar 8 para dejarlo original
				dsub $t5, $t7, $t5 					; 9 - $t5 para corregir el eje Y (que va al revez del mapa)
				daddi $k1, $t5, 0
				daddi $t7, $zero, 16
				dmul $t5, $t5, $t7					; multiplica y*16 para avanzar en filas
				dadd $t4, $t4, $t5					; se lo suma a x y obtiene el offset al bloque en el mapa
				lbu $sp, MAPA1($t4)
				lbu $t4, MAPA1($t4)					; carga que hay en el mapa
				daddi $t5, $zero, 0					; 0 = bloque libre 
				beq $t4, $t5, moverDerecha 		 	; 
				j finMoverPersonaje					;

finMoverPersonaje: jr $ra




; Dibuja toda la matriz del mapa
; Asume:
;   - 
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

finDibujar:		jr $ra
				



; Dibuja el personaje
; Asume:
;   - $a0 coordenada X del personaje
;	- $a1 coordenada Y del personaje
;   - $a2 offset al sprite del personaje (se usa para poder dibujar/borrar)
;   - $a3 offset al nuevo color a usar
DibujarPersonaje: daddi $t6, $zero, 0				; 
				dadd $t7, $zero, $a2				; offset de pixeles del objeto a dibujar
				dadd $t8, $zero, $a3				; offset al nuevo color a usar
				daddi $t9, $zero, 99				; condicion de corte del sprite


dibujarPixel:	lbu $t6, JELPI($t7)					; carga la posX del sprite a dibujar
				beq $t6, $t9, finPersonaje			; $t6 == 99 => termino de dibujar al personaje
				daddi $t9, $zero, 98				; 
				beq $t6, $t9, cambiarColorPersonaje	; $t6 == 98 => cambiar de color
				daddi $t9, $zero, 99				;
				dadd $t6, $t6, $a0   				; ajusta posicion X del sprite
				sb $t6, 5($s0)						; DATA+5 recibe el valor de coordenada X
				daddi $t7, $t7, 1					; incrementa offset de pixeles del objeto a dibujar

				lbu $t6, JELPI($t7)					; carga la posY del sprite a dibujar
				dadd $t6, $t6, $a1   				; ajusta posicion Y del sprite
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