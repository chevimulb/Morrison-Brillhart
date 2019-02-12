def factorbase(N,k,n):
	#Ermittelt die ersten n Primzahlen mit Legendresymbol!=1, und gegebenfalls Faktoren von N
	p=primes_first_n(3*n)
	factors=[]
	m=1
	i=1
	base=[2]
	if N%2==0:
		factors.append(2)
	while m<n:
		if i+1>len(p):
			p=primes_first_n(2*len(p))
		if legendre(k*N,p[i])!=-1:
			if legendre(N,p[i])==0:
				factors.append(p[i])
			base.append(p[i])
			m=m+1
		i=i+1
	R=[factors,base]
	return R