def grauToInt(grau):
    if grau == "Bacharel":
        return 0
    elif grau == "Licenciado":
        return 1

def campusToInt(campus):
    if campus == "Campus Darcy Ribeiro":
        return 1
    elif campus == "Campus Planaltina":
        return 2
    elif campus == "Campus Gama":
        return 4
    else:
        return 3

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
    else:
        return 2

def nivelToInt(nivel):
    if nivel == "Graduação":
        return 0
    elif nivel == "Mestrado":
        return 1
    else:
        return 2

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

def htmlTextToString(text):
    ts = text.find_all(text=True)
    toStr = '\n'.join(ts)
    return(toStr)
