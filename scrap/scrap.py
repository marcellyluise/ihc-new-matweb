# import libraries
from urllib.request import urlopen
from bs4 import BeautifulSoup
from selenium import webdriver
import codecs
import random
import jsonCreate as jc
import convertValues as cv

browser = webdriver.PhantomJS()
campiJSON = []
cursoJSON = []
curriculoJSON = []
departJSON = []
materiaJSON = []
depCOD = 1000

def getSoup(urlExt):
    url = 'https://matriculaweb.unb.br/graduacao/' + urlExt
    print(url)
    basePage = urlopen(url)
    return BeautifulSoup(basePage, 'html.parser')

def scrapOferta(page):
    ofertaJSON = []
    campusCode = 1
    ofertaUrl = page.find('a', attrs={'class': 'btn bg-blue waves-effect'})
    ofertaUrl = ofertaUrl.get('href')[11:]
    url = 'https://matriculaweb.unb.br/graduacao/' + ofertaUrl
    browser.get(url)
    page = BeautifulSoup(browser.page_source, "html.parser")
    divs = page.find_all('div', attrs = {'class': ['table-responsive', 'panel panel-primary']})
    if divs:
        divs.pop(0)
        divs.pop()
        for div in divs:
            if div.get('class')[0] == 'panel':
                campusCode = cv.campusToInt(div.find('h4').text)
            elif div.get('class')[0] == 'table-responsive':
                body = div.find('tbody')
                subTabelas = body.find('tr')
                tabelas = subTabelas.find_all('td', recursive=False)
                dias = tabelas[3].find_all('td')
                i = 0
                diasJSON = []
                while i < len(dias):
                    diaSemana = dias[i].text
                    i+=1
                    horaIni = dias[i].text
                    i+=1
                    horaFim = dias[i].text
                    i+=3
                    diasJSON.append(jc.createDataJSON(diaSemana, horaIni, horaFim))


                turma = tabelas[0].find('td', attrs={'class': 'turma'}).text
                vagas = int(tabelas[1].find('span').text)
                turno = tabelas[2].find('td', attrs={'colspan': '2'}).text
                vagasOcup = random.randint(1,vagas+1)
                vagasRest = vagas - vagasOcup

                profs = []
                for prof in tabelas[4].find_all('td'):
                    profs.append(prof.text)

                ofertaJSON.append(jc.createOfertaJSON(turma, vagas, cv.turnoToInt(turno), vagasOcup, vagasRest, profs, diasJSON, campusCode))
        return ofertaJSON
    else :
        return []

def scrapFluxo(page):
    periodoJSON = []
    tables = page.find_all('table', attrs={'id': 'datatable'})
    for table in tables:
        head = table.find('thead')
        headRows = head.find_all('th')
        codPeriodo = int(headRows[1].text)
        credPeriodo = int(headRows[3].text)
        bodyRows = table.find_all('tr')
        bodyRows.pop(0)
        bodyRows.pop(0)
        materias = []
        for row in bodyRows:
            field = row.find_all('td')
            materias.append(int(field[3].text))
        periodoJSON.append(jc.createPeriodoJSON(codPeriodo, credPeriodo, materias))
    return periodoJSON

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
        campiJSON.append(jc.createCampusJSON(idCampus, campiNomes[idCampus-1], cursosCampus))
        idCampus+=1

def scrapMateriaInfo(materia, campusId):
    global depCOD
    table = materia.find('table', attrs={'id': 'datatable'})
    if table:
        depNome = ""
        depSigla = ""
        text = table.find_all('p')
        rows = table.find_all('tr')
        aux = rows[0].find('a')
        if aux:
            depNome = aux.text
            depSigla = aux.get('small').text.split()
        else:
            depSigla = rows[0].td.text.split()[0]
            depNome = rows[0].td.text[len(depSigla)+1:]

        dep = filter(lambda dep: dep['sigla'] == depSigla, departJSON)
        dep = list(dep)
        depCode = 0
        if (len(dep) == 0):
            departJSON.append(jc.createDepartJSON(depCOD, depNome, depSigla, 1))
            depCode = depCOD
            depCOD += 1
        else:
            depCode = dep[0]
            depCode = depCode['id']
        nivel = cv.nivelToInt(rows[3].td.text)
        vigencia = rows[4].td.text
        preReqs = cv.regexPreReq(rows[5].td)
        ementa = ""
        biblio = ""
        programa = ""

        for i in range(6, len(rows)):
            if rows[i].th.text == "Ementa":
                ementa = cv.htmlTextToString(text[i-6])
            elif rows[i].th.text == "Bibliografia":
                biblio = cv.htmlTextToString(text[i-6])
            elif rows[i].th.text == "Programa":
                programa = cv.htmlTextToString(text[i-6])

        return depCode, nivel, vigencia, preReqs, ementa, biblio, programa
    else:
        return []


def scrapMateria(materias, campusId):
    table = materias.find_all('table', attrs={'id': 'datatable'})
    i = 1
    obgTable = True
    materiasObg = []
    materiasOpt = []
    while i != len(table):
        if i == len(table)-1:
            obgTable = False

        for rows in table[i].find_all('tr'):
            row = rows.find_all('td')
            if len(row) > 0:
                id = int(row[0].text)
                if obgTable == True:
                    materiasObg.append(id)
                else:
                    materiasOpt.append(id)

                if not any(d['id'] == id for d in materiaJSON):
                    nome = row[1].text
                    creds = row[2].text.split()
                    credTeor = int(creds[0])
                    credPratic = int(creds[1])
                    credExt= int(creds[2])
                    credEstudos = int(creds[3])
                    url = row[1].find('a')
                    url = url.get('href')[11:]
                    materiaInfo = getSoup(url)
                    matInfo = scrapMateriaInfo(materiaInfo, campusId)
                    oferta  = scrapOferta(materiaInfo)
                    if len(matInfo) > 0:
                        materiaJSON.append(jc.createMateriaJSON(id, nome, credTeor, credPratic, credExt, credEstudos, matInfo, oferta))
                        materiaJSON.sort(key=lambda k: k['id'])

        i += 1
    return materiasObg, materiasOpt


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
            departJSON.append(jc.createDepartJSON(cod, nome, sigla, idCampus))
        idCampus+=1


# Retira as informacoes de curriculos
def scrapCurriculo(curso, campusId):
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

        curiculoUrl = curso.find_all('a', attrs={'class':'btn bg-blue waves-effect btn-sm m-l-10'})
        fluxoUrl = curso.find_all('a', attrs={'class':'btn bg-blue waves-effect btn-sm'})

        # Para cada curriculo vai percorrer a tabela
        for table in curso.find_all('table', attrs={'id': 'datatable'}):
            # Esvazia as informacoes de curriculos anteriores
            curriculoInfo = []
            # Percorre a tabela pegando as informacoes
            for row in table.find_all('tr'):
                curriculoInfo.append(row.td.text)


            curiculoPage = getSoup(curiculoUrl[index].get('href')[2:])
            moreInfo = scrapCInfo(curiculoPage)
            matObg, matOpt = scrapMateria(curiculoPage, campusId)

            fluxoPage = getSoup(fluxoUrl[index].get('href')[2:])
            periodos = scrapFluxo(fluxoPage)

            #Adiciona o curriculo na lista de curriculos
            curriculoJSON.append(jc.createCurriculoJSON(curriculosID[index], curriculoInfo, moreInfo, cursoId, periodos, matObg, matOpt))
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
            modalidade = cv.modalidadeToInt(rows[0].text)
            cursoId = int(rows[1].text)
            turno = cv.turnoToInt(rows[3].text)
            nome = rows[2].find('a')
            # Pega o link da pagina do curso
            cursoHref = nome.get('href')
            curso = getSoup(cursoHref)
            curriculosID = scrapCurriculo(curso, idCampus)
            if len(curriculosID) > 0:
                cursoJSON.append(jc.createCursoJSON(idCampus, modalidade, turno, cursoId, nome.text, curriculosID))
                cursosCampus.append(cursoId)
    return cursosCampus

if __name__== "__main__":
    mainPage = getSoup('')
    campi = mainPage.find_all('ul', attrs={'class': 'ml-menu'})
    scrapDepart(campi[1])
    scrapCampus(campi[0])

    departsJSON = jc.createEntitiesJSON('departamentos', departJSON)
    jc.createJsonFile("departs", departsJSON)

    curriculosJSON = jc.createEntitiesJSON('curriculos', curriculoJSON)
    jc.createJsonFile("curriculos", curriculosJSON)

    campiJSON = jc.createEntitiesJSON('campi', campiJSON)
    jc.createJsonFile("campi", campiJSON)

    cursosJSON = jc.createEntitiesJSON('cursos', cursoJSON)
    jc.createJsonFile("cursos", cursosJSON)

    materiasJSON = jc.createEntitiesJSON('materias', materiaJSON)
    jc.createJsonFile("materias", materiasJSON)
