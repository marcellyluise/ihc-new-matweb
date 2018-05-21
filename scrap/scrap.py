# import libraries
from urllib.request import urlopen
import json
import codecs
from bs4 import BeautifulSoup


campiJSON = []
cursoJSON = []
curriculoJSON = []
departJSON = []

def regexPreReq(field):
    finalReqs = []
    reqs = []
    for req in field.find_all('strong'):
        t = req.text.strip()
        if t:
            if t == "OU":
                finalReqs.append(reqs)
                reqs = []
            elif t == "E":
                continue
            else:
                lnumber = int(t)
                reqs.append(lnumber)
    finalReqs.append(reqs)
    return finalReqs

def nivelToInt(nivel):
    if nivel == "Graduação":
        return 0
    elif nivel == "Mestrado":
        return 1
    else:
        return 2

def scrapCampus(campi):
    campiUrls = []
    campiNomes = []
    idCampus=1

    for campus in campi.find_all('a'):
        campiNomes.append(campus.text)
        campusUrl = campus.get('href')[11:]
        campiUrls.append(campusUrl)
    for campusUrl in campiUrls:
        cursos = getSoup(campusUrl)
        cursosCampus = scrapCursos(cursos, idCampus)
        campiJSON.append(createCampusJSON(idCampus, campiNomes[idCampus-1], cursosCampus))
        idCampus+=1

def scrapMateriaInfo(materia):
    table = materia.find('table', attrs={'id': 'datatable'})
    matInfo = []

    rows = table.find_all('tr')
    depName = rows[0].td.text.split()[0]
    cod = rows[1].td.text
    nome = rows[2].td.text
    nivel = nivelToInt(rows[3].td.text)
    vigencia = rows[4].td.text
    preReqs = regexPreReq(rows[5].td)

    # for rows in table.find_all('tr'):
    #     matInfo.append(rows.td.text)
    # print(matInfo[0].split()[0])
    # print(matInfo[1])
    # print(matInfo[2])
    # print(matInfo[3])
    # print(matInfo[4])
    #
    # print(matInfo[5])
    # preReq = [int(s) for s in matInfo[5].split() if s.isdigit()]
    # print(preReq)
    #
    #
    # print(matInfo[6])
    # print(matInfo[7])
    # print(matInfo[8])
    # print(matInfo[9])

def scrapMateria(materias):
    table = materias.find_all('table', attrs={'id': 'datatable'})
    i = 1
    while i != len(table):
        for rows in table[i].find_all('tr'):
            row = rows.find_all('td')
            if len(row) > 0:
                id = int(row[0].text)
                nome = row[1].text
                creds = row[2].text.split()
                credTeor = int(creds[0])
                credPratic = int(creds[1])
                credExt= int(creds[2])
                credEstudos = int(creds[3])
                url = row[1].find('a')
                url = url.get('href')[11:]
                materiaInfo = getSoup(url)
                matInfo = scrapMateriaInfo(materiaInfo)
                # url = url.get('href')
                # print(url)
        i += 1


def scrapCInfo(materias):
    table = materias.find('table', attrs={'id': 'datatable'})
    rows = table.find_all('tr')
    r6 = rows[6].find_all('td')
    r7 = rows[7].find_all('td')
    minCredPer = int(r6[0].text[7:])
    maxCredPer = int(r6[1].text[7:])
    minLimPermSem = int(r7[0].text[7:])
    maxLimPermSem = int(r7[1].text[7:])
    return minCredPer, maxCredPer, minLimPermSem, maxLimPermSem

def scrapDepart(campi):
    depsUrls = []
    for campus in campi.find_all('a'):
        depUrl = campus.get('href')[11:]
        depsUrls.append(depUrl)

    idCampus=1
    for url in depsUrls:
        deps = getSoup(url)
        table = deps.find('table', attrs={'id': 'datatable'})
        body = table.find('tbody')
        for rows in body.find_all('tr'):
            rows = rows.find_all('td')
            cod = int(rows[0].text)
            sigla = rows[1].text
            nome = rows[2].text
            departJSON.append(createDepartJSON(cod, nome, sigla, idCampus))
        idCampus+=1


# Retira as informacoes de curriculos
def scrapCurriculo(curso):
    # Inicializa a lista de id vazias
    curriculosID = []
    index = 0
    # Na pagina tenta pegar o id que corresponde ao id do curso
    cursoId = curso.find('div', attrs={'class': 'header'})
    # Se ele existir ...
    if(cursoId.small):
        # Retira texto excessivo e transforma em inteiro
        cursoId = int(cursoId.small.text[6:])
        # Procura os curriculos do curso
        for header in curso.find_all('h4'):
            # Armazena o id dos curriculos
            curriculosID.append(int(header.small.text))

        for fluxoUrl in curso.find_all('a', attrs={'class':'btn bg-blue waves-effect btn-sm'}):
            print(fluxoUrl.get('href'))

        # Para cada curriculo vai percorrer a tabela
        for table in curso.find_all('table', attrs={'id': 'datatable'}):
            # Esvazia as informacoes de curriculos anteriores
            curriculoInfo = []
            # Percorre a tabela pegando as informacoes
            for row in table.find_all('tr'):
                curriculoInfo.append(row.td.text)

            curiculoUrl = curso.find_all('a', attrs={'class':'btn bg-blue waves-effect btn-sm m-l-10'})
            newUrl = curiculoUrl[index].get('href')[2:]
            curiculoPage = getSoup(newUrl)
            moreInfo = scrapCInfo(curiculoPage)
            scrapMateria(curiculoPage)

            #Adiciona o curriculo na lista de curriculos
            curriculoJSON.append(createCurriculoJSON(curriculosID[index], curriculoInfo, moreInfo, cursoId))
            index += 1
        # Retorna o id do curso e dos respectivos curriculos
        return curriculosID
    else:
        # Caso o curso nao tenha nenhum curriculo
        return []

# Retira as informacoes dos cursos
def scrapCursos(cursos, idCampus):
    cursosCampus = []
    # Separa os urls por campus
    print("==========================")
    # Pega o html da tabela de cursos do campus
    table = cursos.find('table', attrs={'id': 'datatable'})
    # Em cada linha
    for rows in table.find_all('tr'):
        rows = rows.find_all('td')
        if len(rows) > 0:
            modalidade = modalidadeToInt(rows[0].text)
            cursoId = int(rows[1].text)
            turno = turnoToInt(rows[3].text)
            nome = rows[2].find('a')
            # Pega o link da pagina do curso
            cursoHref = nome.get('href')
            curso = getSoup(cursoHref)
            curriculosID = scrapCurriculo(curso)
            if len(curriculosID) > 0:
                cursoJSON.append(createCursoJSON(nome.text, modalidade, turno, cursoId, idCampus, curriculosID))
                cursosCampus.append(cursoId)
    return cursosCampus

def grauToInt(grau):
    if grau == "Bacharel":
        return 0
    elif grau == "Licenciatura":
        return 1

def modalidadeToInt(grau):
    if grau == "Presencial":
        return 0
    elif grau == "Distância":
        return 1

def turnoToInt(grau):
    if grau == "Diurno":
        return 0
    elif grau == "Noturno":
        return 1


def createEntitiesJSON(name, dict):
    jsonEnt = {name: dict}
    return json.dumps(jsonEnt, sort_keys=True, indent=4, separators=(',', ': '), ensure_ascii=False)

def createCurriculoJSON(id, infos, moreInfo, curso):
    return {'id': id, 'grau':grauToInt(infos[0]), 'permMin': infos[1], 'permMax': infos[2], 'qtdCredForm': infos[3], 'qtdMinCredOptConc': infos[4], 'qtdMinCredOptConex': infos[5], 'qtdMaxMdlLivre': infos[6], 'qtdMinHorasComp': infos[7], 'qtdMaxHorasIntComp': infos[8], 'qtdMinHorasExt': infos[9], 'qtdMaxIntHorasExt': infos[10], 'minCredPer': moreInfo[0], 'maxCredPer': moreInfo[1], 'minLimPermSem': moreInfo[2], 'maxLimPermSem': moreInfo[3]}

def createDepartJSON(id, name, sigla, idCampus):
    return {'id': id, 'name': name, 'campus': idCampus, 'sigla': sigla}

def createCursoJSON(id, m, t, name, idCampus, curriculos):
    return {'id': id, 'name': name, 'campus': idCampus, 'curriculos': curriculos, 'modalidade': m, 'turno': t}

def createCampusJSON(id, name, cursos):
    return {'id': id, 'name': name, 'cursos': cursos}

def getSoup(urlExt):
    url = 'https://matriculaweb.unb.br/graduacao/' + urlExt
    print(url)
    basePage = urlopen(url)
    return BeautifulSoup(basePage, 'html.parser')



mainPage = getSoup('')
campi = mainPage.find_all('ul', attrs={'class': 'ml-menu'})
scrapDepart(campi[1])
scrapCampus(campi[0])

print(type(departJSON))
# departsJSON = createEntitiesJSON('departamentos', departJSON)
# print(departsJSON)
# curriculosJSON = createEntitiesJSON('curriculos', curriculoJSON)
# print(curriculosJSON)
# campiJSON = createEntitiesJSON('campi', campiJSON)
# print(campiJSON)
# cursosJSON = createEntitiesJSON('cursos', cursoJSON)
# print(cursosJSON)
