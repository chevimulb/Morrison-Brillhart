def factorcheck(factors,p):
	if p not in factors:
		count=0
		nom=p
		while count<len(factors) and factors[count]<(p/2)+1:
			while nom%factors[count]==0:
				nom=nom/factors[count]
			count=count+1
		if nom!=1:
			factors.append(nom)
			factors.sort()
		count=len(factors)-1
		while count>0:
			co=0
			while co<count:
				if factors[count]%factors[co]==0:
					del(factors[count])
					co=count
				co=co+1
			count=count-1
	return factors