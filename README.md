# Gameplay MarioMips

La idea basica del juego es resolver el laberinto para recolectar el cristal y asi avanzar a los siguientes
nivel. Para esto, debido a que el sistema no es lo suficientemente fluido como para simular el salto del pj,
se "invierte la gravedad" y el pj camina por el techo.


## Teclas

"a" mover a la izquierda
"d" mover a la derecha
"barra espaciadora" invertir gravedad



## Editor de mapa

Para mapas multiples agregarlos uno debajo del otro. Por alguna extraña razon hay un bug que los mapas siguientes
requieren repetir dos veces la primera fila para que se los dibuje de forma completa.

La matriz representa el nivel actual del juego. Cada numero es un obstaculo. Cada uno de estos niveles tiene
un tamaño de 10x10. Donde cada bloque es de 5x5 pixeles. Lo que da un total de 50x50 que es el tamaño de la pantalla.

El sistema permite poder editar los mapas sin que sea necesario programar.


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


0 = fondo violeta (BACKGROUND)
1 = piso
2 = bloque
3 = siguiente nivel
x = personaje #no se debe excribir en la matriz, solo para ej de abajo

Dibujar toda la matriz/mapa. Todos los sprites/bloques tienen un tamaño de 5x5 = 25 bytes
|---> x
|
|y



## Sprites / Objetos del mapa

El sprite de 5x5 se escribe completamente en una linea. El primer byte es el color, los siguientes las coordenadas
(0,0),(0,1)... y se finaliza con 99.
Para sprites con multiples colores, agregar 98 seguido del codigo del color. Ej: 12,0,0,0,1,98,24,0,2,99
Para finalizar, todos los sprites tienen que tener 60 elementos (es decir 59 ","). Si el sprite usa menos, 
completar con 99s. Ej:

BACKGROUND: .byte 12,0,0,1,0,2,0,3,0,4,0,0,1,1,1,2,1,3,1,4,1,0,2,1,2,2,2,3,2,4,2,0,3,1,3,2,3,3,3,4,3,0,4,1,4,2,4,3,4,4,4,99



## Personaje y Colision

Los ejes coordenados del PJ se comportan asi:

^ y
|
|
|---> x

Obtener la pos del personaje (x,y). DIV ambos por 5
Ej: x=26, y=45  =>  x=5, y=8

Para avanzar a la derecha ver en la matriz que hay, si está ocupado, no puede avanzar.
Si esta libre x += 3 (velocidad de movimiento)

La logica es igual para cuando el pj cae o sube.



## Sistema grafico

Como redibujar el mapa consume entre 2 y 3 segundos, no es posible limpiar y redibujar la pantalla por cada ciclo.
Para eso, al iniciar el nivel se dibuja el mapa una unica vez. Luego, solo el personaje es redibujado cada ciclo
lo que permite obtener un mejor rendimiento.
Debido a lo anterior y a que el sprite del personaje es mayor a 5x5 (tamaño de los bloques del mapa), existen
varios bugs visuales en los que parece que el personaje recorta parte del mapa. La colision no se ve afectada.



## Colores (13)

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



## Notas finales

Catedra:  Arquitectura de Computadoras 2020
Profesor: Cesar Estrebou
Alumno:   Diego Lanciotti
