print("hola")

print(__name__)

var1 = input("dame este dato ")

#es para pedir datos
print(f"Este es el valor {var1}")
var1 = bool(var1)
print(type(var1))

if type(var1) == str:
    print("es un string")
elif type(var1) == int:
    print("es un numero")
else:
     print("es otra cosa")