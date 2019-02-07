def legendre(a,p):
	l=a^((p-1)/2)
	l=l%p
	if l==p-1:
		l=l-p
	return l
	