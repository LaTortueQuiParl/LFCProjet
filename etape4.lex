%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
%}

%start TITRE
%start ITEM

%%
(" "|\t)+ ;
<ITEM>(\n|\r\n) ;
<INITIAL>(\n|\r\n) ;

<INITIAL>^"*"" "+ {
    printf("Début de liste\n");
    BEGIN ITEM;
    return DEBLIST;
}
<ITEM>^"*"" "+ {
    printf("Item de liste\n");
    return ITEMLIST;
}
<ITEM>(\n|\r\n)(" "*(\n|\r\n))+ {
    printf("Fin de liste\n");
    BEGIN INITIAL;
    return FINLIST;
}

<INITIAL>^" "{0,3}"#"{1,6}" "+ {
    printf("Balise de titre\n");
    BEGIN TITRE;
    return BALTIT;
}
<TITRE>(\n|\r\n)(" "*(\n|\r\n))* {
    printf("Fin de Titre\n");
    BEGIN INITIAL;
    return FINTIT;
}

"*"	{
    printf("Etoile\n");
    return ETOILE;
}

[^#*_\n]+ {
    printf("Morceau de texte : %s\n", yytext);
    strcpy(yylval.text, yytext);
    return TXT;
}

(\n|\r\n)(" "*(\n|\r\n))+ {
    printf("Ligne vide\n");
    return LIGVID;
}

. {
    printf("Erreur lexicale : Caractère %s non autorisé\n", yytext);
}
%%