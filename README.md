# Abstract Syntactic Tree - AST

## Scop

Primind un string ca input ce reprezinta o expresie in **forma prefixata**,
algoritmul implementat in fisierul **ast.asm** creeaza un arbore sintactic
abstract. De exemplu, expresia *4 / 64 - 2 * (3 + 1)* formeaza urmatorul
arbore:

![exemplu](https://ocw.cs.pub.ro/courses/_media/iocla/teme/ast.png?cache=)


## Modalitatea de rulare



## Detalii despre implementarea celor doua functii:

### iocla_atoi

Primeste un string ca parametru si il transforma intr-un numar - aceeasi
functionalitate ca functia clasica **atoi**.

Pornesc cu eax = 0.
	
Verific primul caracter din string-ul dat ca parametru, daca este '-',
caz in care incep parcurgerea acestuia de la al doilea caracter; daca nu,
parcurg de la inceput

Iau pe rand fiecare caracter, il convertesc la cifra corespunzatoare
(scad '0'), inmultesc eax cu 10 si adun cifra.

La final verific din nou daca primul caracter este '-', caz in care
neg eax-ul.


### create_tree
	
Folosesc functia *create_node*, care primeste ca parametru un string
si intoarce un nod ce are ca informatie string-ul respectiv. Am folosit o
structura de 12 bytes, care contine 3 pointeri: primul la informatia din nod
(char*), al doilea la fiul stang si al treilea la fiul drept.

Pentru a aloca memorie pentru un nod folosesc functia *calloc*, caci
aceasta imi va pune 0-uri in zona de memorie alocata, adica va considera ca
fii sunt ambii NULL.

Aloc memorie si pentru informatia din nod, folosind *strdup* aplicat
pe string-ul dat ca parametru.


#### Logica functiei
	
	create_tree(input)
		if input == \0
			stop
		c = string-ul pana la primul spatiu
		node = create_node(c)
		input += lungimea lui c + 1 (sar peste c si peste spatiu)
		if c == operator
			node.left = create_tree(input)
			node.right = create_tree(input)
		return node
		
#### Implementare in assembly
	
Compar primul caracter din string cu '\0', iar daca este adevarat,
opresc programul. Mai departe compar cu ' ', iar daca este ' ', sar peste el

Apelez strtok pe acest string, pentru a obtine string-ul pana la ' ',
dar inainte de asta, duplic string-ul, intrucat *strtok* distruge parametrul.

Creez un nou nod ce are ca informatie acest substring obtinut, pe care
il salvez pe stiva

Calculez lungimea substring-ului, pentru a sari din string-ul initial
la urmatoarea bucata din el, de dupa substring (adaug lungimea la string) si
obtin noul parametru pe care il voi da functiei *create_tree*.

Verific daca acel subtring este operator, caz in care apelez recursiv
*create_tree* pe noul string. Apoi scot de pe stiva nodul salvat, din apelul
trecut si ii pun fiul stang, ca fiind nodul care rezulta din apelul curent.

Procedez la fel si pentru fiul drept. Parametrul l-am salvat intr-o
variabila globala, caci aveam nevoie sa ramana inputul modificat, la fiecare
apel. (sa nu se intoarca din recursivitate la un string vechi si sa intre in
bucla)

In final, functia returneaza nodul creat, adica radacina subarborelui
curent. Practic in urma tuturor apelurilor se obtine exact radacina impreuna
cu legaturile catre celelalte noduri


