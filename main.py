import matplotlib.pyplot as plt

def genera_grafica_barras(labels,values):
    fig,ax = plt.subplots()
    ax.bar(labels,values)
    plt.show()

if __name__ == '__main__':
    labels = ['a','b','c']
    values = [100,250,420]
    genera_grafica_barras(labels,values)