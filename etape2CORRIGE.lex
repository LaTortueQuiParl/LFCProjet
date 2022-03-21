%{
    #include <stdio.h>

    int finTitre = 0;
%}

%start TITRE
%start ITEM

%%
(" "|\t)+	;
^"*"" "+	{printf("Point de liste\n"); BEGIN ITEM;}
^" "{0,3}"#"{1,6}" "+	{printf("Balise de début de titre\n"); BEGIN TITRE;finTitre++;}
[^#*_\n]+	{printf("Morceau de texte\n");}
(\n|\r\n)(" "*(\n|\r\n))+	{printf("Ligne vide\n");BEGIN INITIAL;}
(\n|\r\n)	{
    if(finTitre>0){
        BEGIN INITIAL;
        finTitre = 0;
        printf("Fin de Titre\n");
    }
}
"*"	{printf("Etoile\n");}
.	{printf("Caractère non autorisé\n");}
%%