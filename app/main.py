import utils
import read_csv
import charts


def run():
    # leo el archivo
    data = read_csv.read_csv('data.csv')

    continente = input('Que continente => ')

    dataFiltrada = list(filter(lambda p: p['Continent']==continente,data))
    # voy a obtener el % de población de cada pais
    pais, porcentaje = list(utils.world_percentages(dataFiltrada))
    #print(porcentajePoblacion)

    charts.genera_grafica_pastel(pais, porcentaje)
'''    
    # solicito el pais
    pais = input('Dame el pais -> ')

    # obtengo la poblacion del pais elegido
    result = utils.poblacion_por_pais(data,pais)

    # si el pais existe en el archivo lo grafico
    if len(result) > 0 :
        pais = result[0]
        
        # saco la informacion de ese pais sobre sus poblaciones a lo largo de los años
        labels, values = utils.get_population(pais)

        # grafico los datos
        charts.genera_grafica_barras(labels,values)
'''


if __name__ == '__main__':
    run()