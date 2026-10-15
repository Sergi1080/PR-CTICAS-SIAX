// Agent me in project family.jcm  --  familia6

/*
   Todos los miembros de la familia usan este mismo codigo.
   Creencias iniciales (desde family.jcm): solo los hechos es_padre_de/2 y
   es_madre_de/2 en los que aparece el propio agente.
   La identidad yo(Me) NO se da como creencia inicial: se obtiene del
   nombre del agente con .my_name(Me).
*/

/* Reglas genericas de parentesco */

/* Relaciones de hermanos
Nota: Segun el diccionario consideramos hermanos aquellos que comparten un padre o una madre.
*/

//Primero suponemos que comparten solo padre y no son la misma persona
es_hermano_de(X,Y) :-
	es_padre_de(Z,X)
	& es_padre_de(Z,Y)
	& es_madre_de(W,X)
	& not es_madre_de(W,Y)
	& not X=Y.

//Segundo suponemos que comparten solo madre y no son la misma persona
es_hermano_de(X,Y) :-
	es_madre_de(Z,X)
	& es_madre_de(Z,Y)
	& es_padre_de(W,X)
	& not es_padre_de(W,Y)
	& not X=Y.

//Tercero suponemos que comparten padre y madre y no son la misma persona

es_hermano_de(X,Y) :- 
	es_padre_de(Z,X)
	& es_padre_de(Z,Y)
	& es_madre_de(W,X)
	& es_madre_de(W,Y)
	& not X=Y.

/*
NOTA: Fijaros que el hecho de que tengan padre o madre distinta incluye 
las situaciones de padres divorciados o de horfandad 

Relaciones de parentesco 
Modificamos las anteriores para diferenciar explicitamente entre antepasados 
y descendientes. 
Comparar las soluciones con la version anterior.
*/

// Primero reglas para "X es_antepasado_de Y"
es_antepasado_de(X,Y) :- 
	es_antepasadoDirecto_de(X,Y).

es_antepasado_de(X,Y) :- 
	es_antepasadoIndirecto_de(X,Y).

es_antepasadoDirecto_de(X,Y) :- 
	es_padre_de(X,Y).

es_antepasadoDirecto_de(X,Y) :- 
	es_madre_de(X,Y).

es_antepasadoDirecto_de(X,Y) :- 
	es_padre_de(X,Z)
	& es_antepasadoDirecto_de(Z,Y).
	
es_antepasadoDirecto_de(X,Y) :- 
	es_madre_de(X,Z)
	& es_antepasadoDirecto_de(Z,Y).

es_antepasadoIndirecto_de(X,Y) :- 
	es_hermano_de(X,Z)
	& es_antepasadoDirecto_de(Z,Y).
	
// Luego reglas para "X es_descendiente_de Y"
es_descendiente_de(X,Y) :- 
	es_padre_de(Y,X).

es_descendiente_de(X,Y) :- 
	es_madre_de(Y,X).

es_descendiente_de(X,Y) :- 
	es_padre_de(Y,Z)
	& es_descendiente_de(X,Z).

es_descendiente_de(X,Y) :- 
	es_madre_de(Y,Z)
	& es_descendiente_de(X,Z).

// Creamos reglas para primos lejanos

es_primoLejano_de(X,Y) :-
	es_antepasadoIndirecto_de(Z,Y)
	& es_descendiente_de(X,Z).
	
// Por ultimo las reglas para "X es_pariente_de Y"
es_pariente_de(X,Y) :-
	es_hermano_de(X,Y)
	& not X=Y.

es_pariente_de(X,Y) :-
	es_antepasado_de(X,Y)
	& not X=Y.

es_pariente_de(X,Y) :-
	es_descendiente_de(X,Y)
	& not X=Y.

es_pariente_de(X,Y) :-
	es_primoLejano_de(X,Y).


/* Initial goals */

!start.

/* Plans */

// 1. Saber quien soy, 2. contar a todos lo que se de mi,
// 3. esperar a recibir lo que saben los demas, 4. buscar a mi familia.
+!start : .my_name(Me)
	<-	+yo(Me);
		!compartir;
		.wait(2000);
		!buscarFamilia;
		.broadcast(tell, hi("Hola")).

// Solo se comparten los hechos propios (source(self)), no los recibidos.
+!compartir
	<-	for ( es_padre_de(X,Y)[source(self)] ) {
			.broadcast(tell, es_padre_de(X,Y))
		};
		for ( es_madre_de(X,Y)[source(self)] ) {
			.broadcast(tell, es_madre_de(X,Y))
		}.

+!buscarFamilia : yo(Me)
	<-	.setof(P, es_padre_de(P,Me), Padre);
		.setof(M, es_madre_de(M,Me), Madre);
		.setof(H, (es_padre_de(Me,H) | es_madre_de(Me,H)), Hijos);
		.setof(H, es_hermano_de(H,Me), Hermanos);
		.setof(P, es_pariente_de(P,Me), Parientes);
		.println("Soy ", Me, " | padre: ", Padre, " | madre: ", Madre,
		         " | hijos: ", Hijos, " | hermanos: ", Hermanos);
		.println("Mis parientes son: ", Parientes).

/* Events */

+hi(_)[source(S)] : yo(Me) & S \== Me & es_pariente_de(S,Me)
	<-	.println("Mi pariente ", S, " me saluda.").

+hi(_)[source(S)] : yo(Me) & S \== Me
	<-	.println(S, " me saluda, pero no es de mi familia.").
