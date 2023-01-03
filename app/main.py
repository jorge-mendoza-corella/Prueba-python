import utils
import read_csv
import charts


def run():
    # leo el archivo
    data = read_csv.read_csv('./app/data.csv')
    
    # solicito el pais
    pais = input('Dame el pais -> ')

    # obtengo la poblacion del pais elegido
    result = utils.poblacion_por_pais(data,pais)

    # si el pais existe en el archivo lo grafico
    if len(result) > 0 :
        pais = result[0]
        
        # saco la informacion de ese pais sobre sus poblaciones a lo largo de los años
        labels, values = utils.get_population(pais)

        # grafico los datosCol
        charts.genera_grafica_barras(labels,values)


if __name__ == '__main__':
    run()