# Mapa simple

2,0,0,0,0,0,0,0,0,2,  
2,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,X,0,0,0,2,
1,1,1,1,1,1,1,1,1,1



# Mapa multiple, maximo 6 columnas, profundidad infinta?

2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,  
2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,	
2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,
2,0,0,0,0,X,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,2,
1,1,1,1,1,1,1,1,1,1,	1,1,1,1,1,1,1,1,1,1,	1,1,1,1,1,1,1,1,1,1,	1,1,1,1,1,1,1,1,1,1,	1,1,1,1,1,1,1,1,1,1,	1,1,1,1,1,1,1,1,1,1	


0 = fondo violeta (BACKGROUND)
1 = piso
2 = bloque
x = personaje #no se debe excribir en la matriz, solo para ej de abajo

Dibujar toda la matriz/mapa. 5 para adelante, atras arriba, abajo.  ?????????????
Todos los bloques tienen un tamaño de 5x5 = 25 bytes
|---> x
|
|y


# Sprites / Objetos del mapa

El sprite de 5x5 se escribe completamente en una linea. El primer byte es el color, los siguientes las coordenadas
(0,0),(0,1)... y se finaliza con 99.
Para sprites con multiples colores, agregar 98 seguido del codigo del color. Ej: 12,0,0,0,1,98,24,0,2,99
Para finalizar, todos los sprites tienen que tener 60 elementos (es decir 59 ","). Si el sprite usa menos, completar
con 99s.
BACKGROUND: .byte 12,0,0,1,0,2,0,3,0,4,0,0,1,1,1,2,1,3,1,4,1,0,2,1,2,2,2,3,2,4,2,0,3,1,3,2,3,3,3,4,3,0,4,1,4,2,4,3,4,4,4,99


# Colision

Los ejes coordenados del PJ se comportan asi:

^ y
|
|
|---> x

Obtener la pos del personaje (x,y). DIV ambos por 5
Ej: x=26, y=45  =>  x=5, y=8

Para avanzar a la derecha ver en la matriz que hay, si está ocupado, no puede avanzar.
Si esta libre x += 3 (velocidad de movimiento)


# Mirar a la izquierda

Para girar, hay que dibujar al revez. El x se tiene que desplazar al otro extremo del personaje.
Mirar izquierda => x += 5
Mirar derecha => x -= 5


# Colores (13)

NEGRO:			.byte 0, 0, 0, 0			; color 0
BLANCO:			.byte 255, 241, 232, 0		; color 4
AZUL_OSCURO:	.byte 29, 43, 83, 0			; color 8
LILA:			.byte 130, 118, 156, 0		; color 12
VIOLETA:		.byte 126, 37, 83, 0		; color 16
FUCCIA:			.byte 255, 0, 77, 0			; color 20
ROSA:			.byte 255, 119, 168, 0		; color 24
CREMITA:		.byte 255, 204, 170, 0		; color 28
VERDE_CLARO:	.byte 0, 228, 54, 0			; color 32
VERDE_OSCURO:	.byte 0, 135, 81, 0			; color 36
MARRON:			.byte 171, 82, 54, 0		; color 40
AMARILLO:		.byte 255, 236, 39, 0		; color 44
ROJO:			.byte 255, 0, 82, 0			; color 48







