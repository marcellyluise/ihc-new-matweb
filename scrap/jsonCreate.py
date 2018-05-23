import convertValues as cv
import json



def createOfertaJSON(turma, vagas, turno, vagasOcup, vagasRest, profs, dias, campus):
    return {'turma': turma, 'vagas': vagas, 'turno': turno, 'vagasOcup': vagasOcup,
            'vagasRest': vagasRest, 'profs': profs, 'dias': dias,
            'campus': campus}

def createDataJSON(dia, hIni, hFim):
    return {'dia': dia, 'hInicio': hIni, 'hFim': hFim}

def createPeriodoJSON(id, cred, mats):
    return {'id': id, 'creditos': cred, 'materias': mats}

def createMateriaJSON(id, nome, credTeor, credPratic, credExt, credEstudos, matInfo, oferta):
    return {'id': id, 'nome': nome, 'credTeor': credTeor, 'credPratic': credPratic,
            'credExt': credExt, 'credEstudos': credEstudos, 'dep': matInfo[0],
            'nivel': matInfo[1], 'vigencia': matInfo[2], 'preReqs': matInfo[3],
            'ementa': matInfo[4], 'biblio': matInfo[5], 'programa': matInfo[5],
            'oferta': oferta}

def createEntitiesJSON(name, dict):
    jsonEnt = {name: dict}
    return json.dumps(jsonEnt, sort_keys=True, indent=4, separators=(',', ': '), ensure_ascii=False)

def createCurriculoJSON(id, infos, moreInfo, curso, periodos, materiasObg, materiasOpt):
    return {'id': id, 'grau': cv.grauToInt(infos[0]), 'permMin': infos[1], 'permMax': infos[2], 'qtdCredForm': infos[3], 'qtdMinCredOptConc': infos[4], 'qtdMinCredOptConex': infos[5], 'qtdMaxMdlLivre': infos[6], 'qtdMinHorasComp': infos[7], 'qtdMaxHorasIntComp': infos[8], 'qtdMinHorasExt': infos[9], 'qtdMaxIntHorasExt': infos[10], 'minCredPer': moreInfo[0], 'maxCredPer': moreInfo[1], 'minLimPermSem': moreInfo[2], 'maxLimPermSem': moreInfo[3], 'periodos': periodos, 'cursoId': curso, 'materiasOpt': materiasOpt,'materiasObg': materiasObg}

def createDepartJSON(id, name, sigla, idCampus):
    return {'id': id, 'name': name, 'campus': idCampus, 'sigla': sigla}

def createCursoJSON(id, m, t, name, idCampus, curriculos):
    return {'id': id, 'name': name, 'campus': idCampus, 'curriculos': curriculos, 'modalidade': m, 'turno': t}

def createCampusJSON(id, name, cursos):
    return {'id': id, 'name': name, 'cursos': cursos}

def createJsonFile(nome, info):
    file = open("output/{}.json".format(nome), "w")
    file.write(info)
    file.close()
