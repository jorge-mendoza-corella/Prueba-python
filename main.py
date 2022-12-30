import matplotlib.pyplot as plt

def genera_grafica_barras(labels,):
    labels = ['a','b','c']
    values = [100,250,420]

    fig,ax = plt.subplots()
    ax.bar(labels,values)
    plt.show()

if __name__ == '__main__':
    genera_grafica_barras