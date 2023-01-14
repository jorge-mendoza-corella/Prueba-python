import matplotlib.pyplot as plt

 
def genera_grafica_barras(labels,values):
    fig,ax = plt.subplots()
    ax.bar(labels,values)
    plt.show()

def genera_grafica_pastel(labels,values):
    fig, ax = plt.subplots()
    ax.pie(values, labels=labels)
    plt.show()