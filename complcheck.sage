def complcheck(N,fac):
	i=0
	f=2
	while i<len(fac):
		if fac[i] not in list(primes(fac[i],fac[i]+1)):
			f=1
		while N%fac[i]==0:
			N=N/fac[i]
		i=i+1
	if N==1:
		return [f,fac]
	elif N in list(primes(N,N+1)):
		fac=factorcheck(fac,N)
		return [f,fac]
	else:
		fac=factorcheck(fac,N)
		return [1,fac]