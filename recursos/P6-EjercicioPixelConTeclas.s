.data

CONTROL: .word32 0x10000


BckGrndColor:  .byte 255,255,255,0

Color:  .byte 255,255,0,0
PalColors:  .word32   0x2b39c0, 0x3c4ce7, 0xb6599b , 0xc91cab ,0xb98029 ,  0xdb9834,   0x9cbc1a  ,  0x60ae27, 0x3498db , 0x0fc4f1 ,  0x129cf3 
Coords: .byte  1,40, 8,40, 15,40, 23,40, 31,40, 1,30, 8,30, 15,30, 23,30, 31,30
NUM0: .byte 0,1,1,1,1,0,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,1,1,1,1,0,0, 0 
NUM1: .byte 0,0,1,1,0,0,0, 0,1,1,1,0,0,0, 1,1,1,1,0,0,0, 0,0,1,1,0,0,0, 0,0,1,1,0,0,0, 0,0,1,1,0,0,0, 0,0,1,1,0,0,0, 0,0,1,1,0,0,0, 1,1,1,1,1,1,0, 0
NUM2: .byte 0,1,1,1,1,0,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,0,0,0,1,1,0, 0,0,0,1,1,0,0, 0,0,1,1,0,0,0, 0,1,1,0,0,0,0, 1,1,0,0,0,0,0, 1,1,1,1,1,1,0, 0
NUM3: .byte 0,1,1,1,1,0,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,0,0,0,1,1,0, 0,0,1,1,1,0,0, 0,0,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,1,1,1,1,0,0, 0
NUM4: .byte 0,0,0,1,1,0,0, 0,0,1,1,1,0,0, 0,0,1,1,1,0,0, 0,1,1,1,1,0,0, 0,1,1,1,1,0,0, 1,1,0,1,1,0,0, 1,1,1,1,1,1,0, 0,0,0,1,1,0,0, 0,0,0,1,1,0,0, 0 
NUM5: .byte 0,1,1,1,1,1,0, 0,1,1,0,0,0,0, 1,1,0,0,0,0,0, 1,1,1,1,1,0,0, 1,1,0,0,1,1,0, 0,0,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,1,1,1,1,0,0, 0 
NUM6: .byte 0,1,1,1,1,0,0, 1,1,0,0,1,1,0, 1,1,0,0,0,0,0, 1,1,1,1,1,0,0, 1,1,1,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,1,1,1,1,0,0, 0 
NUM7: .byte 1,1,1,1,1,1,0, 0,0,0,0,1,1,0, 0,0,0,1,1,0,0, 0,0,0,1,1,0,0, 0,0,1,1,0,0,0, 0,0,1,1,0,0,0, 0,0,1,1,0,0,0, 0,1,1,0,0,0,0, 0,1,1,0,0,0,0, 0   
NUM8: .byte 0,1,1,1,1,0,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,1,1,1,1,0,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 0,1,1,1,1,0,0, 0
NUM9: .byte 0,1,1,1,1,0,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,0,1,1,0, 1,1,0,1,1,1,0, 0,1,1,1,1,1,0, 0,0,0,0,1,1,0, 1,1,0,0,1,1,0, 0,1,1,1,1,0,0, 0

ESPACIO: .byte 32
BLOQUE: .byte 1,1,1,1,1,1,1, 1,1,1,1,1,1,1, 1,1,1,1,1,1,1, 1,1,1,1,1,1,1, 1,1,1,1,1,1,1, 1,1,1,1,1,1,1, 1,1,1,1,1,1,1, 1,1,1,1,1,1,1, 1,1,1,1,1,1,1


.code
        daddi $sp, $0, 0x400
        lwu $s0, CONTROL($zero)
        jal InitGraphics
        daddi   $s1, $0, 10     ; cantidad caracteres a imprimir
        daddi   $s3, $0, 0      ; desplazamiento para colores
        daddi   $s4, $0, NUM0   ; puntero a inicio de tabla de caracteres a imprimir
    
Loop:   lbu     $a0, Coords($0)    ; recupera coordenada x
        daddi   $s2, $s2, 1
        lbu     $a1, Coords($0)    ; recupera coordenada y
        daddi   $s2, $s2, 1
        lwu     $a2, PalColors($s3) ; recupera color de tabla
        dadd    $a3, $0, $s4        ; puntero a caracter a imprimir
        jal     PutGlyph
        daddi   $s4,$s4, 64         ; proximo caracter a imprimir
        daddi   $s1, $s1, -1        ; descuenta caracteres faltantes para imprimir
        daddi   $s3, $s3, 4         ; desplazamiento para colores
        daddi   $a0, $0, 10000      ; espera una cantidad  ciclos
        JAL     DelayCycles
        JAL     KeyPressed
        lbu     $t0, ESPACIO($0)    ; ' ' espacio
        bne     $v0,$t0, Seguir     ; no es espacio, continuar
Espera: JAL     KeyPressed          ; loop de espera hasta nueva tecla espacio
        lbu     $t0, ESPACIO($0)    ; ' ' espacio        
        bne     $t0,$v0, Espera     ; espera a que presione pausa       
Seguir: bnez    $s1, Loop
        daddi   $s1, $0, 10         ; cantidad caracteres a imprimir
        daddi   $s3, $0, 0      ; desplazamiento para colores
        daddi   $s4, $0, NUM0       ; puntero a inicio de tabla de caracteres a imprimir
        j       Loop
        halt
    
; Inicializa el modo grafico y borra la pantalla
; Asume:
;   - $s0 direccion de control
InitGraphics:   daddi	$t1, $0, 7
                sd		$t1, 0($s0)
                jr		$ra



; Verifica si hay un caracter para leer
; Asume:
;   - $S0 direccion de control
;   - $V0 retorna 0 sino hay caracter presionado y sino retorna el código ASCII del mismo
KeyPressed:     daddi $t9, $0, 10        ; codigo de funcion para leer caracter
                sd    $t9, 0($s0)        ; control = 10
                lbu   $v0, 8($s0)
                jr    $ra

; Dibuja un pixel en la posicion (X,Y) del color indicado
; Asume:
;   - $A0 cantidad de ciclos de espera
DelayCycles:  daddi $a0, $a0, -1
              bnez  $a0, DelayCycles
              jr $ra


; Dibuja un pixel en la posicion (X,Y) del color indicado
; Asume:
;   - $S0 direccion de control
;   - $A0 coordenada x
;   - $A1 coordenada y
;   - $A2 color RGBX
PutPixel:       sb    $a0, 13($s0)      ; 13= 8+5 posicion 5 de data (X)
                sb    $a1, 12($s0)      ; 12= 8+4 posicion 4 de data (Y)
                sw    $a2, 8($s0)       ; 8 =  posicion inicial de data (Color)
                daddi $t9, $0, 5        ; codigo de funcion para dibujar pixel
                sd    $t9, 0($s0)       ; control = 5
                jr    $ra
    
; Dibuja un caracter en la posicion (X,Y) del color indicado
; Asume:
;   - $S0 direccion de control
;   - $A0 coordenada x
;   - $A1 coordenada y
;   - $A2 color RGBX
;   - $A3 direccion del caracter a imprimir
PutGlyph:       daddi $sp, $sp, -8  
                sd    $ra, 0($sp)
                ; ajuste para que la coordenada x,y quede en la posicion inferior-izquierda del caracter
                daddi $a1, $a1, 8           ; incrementa y en 9 para ir bajando al pintar el dibujo
                daddi $t8, $0, 63           ; tamaño del caracter a imprimir 7*9=63
                dadd  $t0, $0, $a0          ; salva en registros temporales x, y y color
                dadd  $t1, $0, $a1
                dadd  $t2, $0, $a2
                daddi $t7, $a0, 7           ; posicion en la que se termina el ancho de una fila (7 pixeles a partir de X)
PutGlyphLoop:   ld    $a2, BckGrndColor($0) ; Variable global con color de fondo (sino hay que pintar) 
                lbu   $t3, 0($a3)          ; recupera bit a pintar
                beq   $t3,$0, PutGlyphPaint ; pixel es 0? => se pinta con color de fondo
                dadd  $a2, $0, $t2          ; pixel es 1 => hay que pintar de color
PutGlyphPaint:  jal PutPixel                ; pinta (X,Y) =($a0,$a1) con color $a2
                daddi $t8, $t8,-1            ; descuenta pixel a pintar
                beq   $t8, $0, PutGlyphEnd
                daddi $a3, $a3, 1            ; apunta a proximo pixel a pintar
                daddi $a0, $a0, 1            ; proximo pixel en la fila para pintar
                bne   $a0, $t7, PutGlyphLoop ; NO pinto ult pixel de fila? => continuar
                dadd  $a0, $0, $t0           ; pinto ult pixel de fila, reinicia
                daddi $a1, $a1, -1           ; decrementa en uno la fila (coordenada Y)
                j PutGlyphLoop
PutGlyphEnd:    ld    $ra, 0($sp)       
                daddi $sp, $sp, 8
                jr    $ra
    
    
    