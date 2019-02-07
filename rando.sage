import random
def rando(digits):
	out=2
	while out not in list(primes(out,out+1)):
		i=1
		t=10
		li=[1,3,7,9]
		out=li[random.randint(1,8)%4]
		while i<digits-1:
			out=out+t*random.randint(0,9)
			t=t*10
			i=i+1
		return out+t*random.randint(1,9)
