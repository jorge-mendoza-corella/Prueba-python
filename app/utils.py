def poblacion_por_pais(data,pais):
    result = list(filter(lambda item: item['Country'] == pais, data))
    return result


def get_population(pais):
    poblacion = {
        '2022' : int(pais['2022 Population']),
        '2020' : int(pais['2020 Population']),
        '2015' : int(pais['2015 Population']),
        '2010' : int(pais['2010 Population']),
        '2000' : int(pais['2000 Population']),
        '1990' : int(pais['1990 Population']),
        '1980' : int(pais['1980 Population']),
        '1970' : int(pais['1970 Population'])
    }

    print((poblacion))
    labels = poblacion.keys()
    values = poblacion.values()
    return labels, values


def world_percentages(data): 
    pais = list(map(lambda pais: pais['Country'], data))
    porcentajes = list(map(lambda porcentaje: porcentaje['World Population Percentage'], data))
    #datos = zip (pais,porcentajes)
    return pais, porcentajes
