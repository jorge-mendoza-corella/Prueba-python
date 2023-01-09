import  csv

def read_csv(path):
    with open(path, 'r') as csvfile:
        reader = csv.reader(csvfile,delimiter=',')
        header = next(reader)
        data = []
        for row in reader:
            iterable = zip(header,row)
            country = {key:value for key, value in iterable}
            data.append(country)
        return data

if __name__ == '__main__':
    data = read_csv('data.csv')
    #tamano = lambda lista:len(lista)
    #print(tamano(data))