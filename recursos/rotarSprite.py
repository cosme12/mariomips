# Rota el sprite en 180 grados
# Volver a agregar el primer color y eliminar los corchetes


# Coordenadas del personaje sin el primer color 
a=[1,0,98,16,1,0,3,0,1,3,2,3,3,3,4,3,0,4,2,4,3,4,4,4,0,5,1,5,2,5,3,5,4,5,5,5,0,6,4,6,98,48,1,1,2,1,3,1,98,20,1,2,2,2,3,2,98,24,0,3,5,3,98,8,1,4,5,4,99]

# Dimensiones del sprite del personaje a rotar 180 grados
alto = 6
ancho = 5 

for i in range(len(a)):
    if a[i] <=7:
        if i%2==0:
            a[i]=5-a[i]
        else:
            a[i]=6-a[i]

print(a)
