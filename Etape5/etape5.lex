%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"

    int pos[14][2];
    extern char tableau[1024];
    char etat[14][100];
    
    int indiceLigne = 0;
    int positionDebutMot = 0;
    char etatActuel[20] = "Normal";

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
    strcpy(etatActuel, "Item");
    return DEBLIST;
}
<ITEM>^"*"" "+ {
    printf("Item de liste\n");
    strcpy(etatActuel, "Item");
    return ITEMLIST;
}
<ITEM>(\n|\r\n)(" "*(\n|\r\n))+ {
    printf("Fin de liste\n");
    BEGIN INITIAL;
    strcpy(etatActuel, "Normal");
    return FINLIST;
}

<INITIAL>^" "{0,3}"#"{1,6}" "+ {
    printf("Balise de titre\n");
    BEGIN TITRE;
    strcpy(etatActuel, "Titre");
    return BALTIT;
}
<TITRE>(\n|\r\n)(" "*(\n|\r\n))* {
    printf("Fin de Titre\n");
    BEGIN INITIAL;
    strcpy(etatActuel, "Normal");
    return FINTIT;
}

"*"" "?	{
    printf("Etoile\n");
    return ETOILE;
}


([^#"_""*"\n]|(\\\*))+ {
    printf("Morceau de texte : %s\n", yytext);
    strncat(tableau, yytext, yyleng);
    pos[indiceLigne][0] = positionDebutMot;
    positionDebutMot += yyleng;
    pos[indiceLigne][1] = yyleng;
    strcpy(etat[indiceLigne], etatActuel);
    indiceLigne++;
    strcpy(etat[indiceLigne], etat[indiceLigne-1]);
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
yywrap(){
    printf("\n");    
    for(int i=0; i<14; i++){
        printf("%-8d|%-8d|%-8s|\n", pos[i][0], pos[i][1], etat[i]);
    }
    
    return (1);
}