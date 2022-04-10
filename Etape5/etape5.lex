%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"

    extern int pos[100][2];
    extern char tableau[1024];
    extern char etat[100][3][100];
    extern int indiceLigne;

    int positionDebutMot = 0;
    char etatActuel[20] = "Normal";

    
    void organisationItem(char newOrgaItem[100], int ligne);
%}

%start TITRE
%start ITEM

%%

(" "|\t)+ ;
<ITEM>(\n|\r\n) ;
<INITIAL>(\n|\r\n) ;

<INITIAL>^"*"" "+ {

    printf("Début de liste\n");

    //Changement d'état : ITEM
    BEGIN ITEM;
    strcpy(etatActuel, "Item");
    organisationItem("DebutListe", indiceLigne);

    return DEBLIST;
}
<ITEM>^"*"" "+ {

    printf("Item de liste\n");
    strcpy(etatActuel, "Item");
    organisationItem("ChangementItem", indiceLigne);

    return ITEMLIST;
}
<ITEM>(\n|\r\n)(" "*(\n|\r\n))+ {

    printf("Fin de liste\n");
    
    organisationItem("FinListe", indiceLigne-1);

    //Changement d'état : INITIAL
    BEGIN INITIAL;
    strcpy(etatActuel, "Normal");

    return FINLIST;
}

<INITIAL>^" "{0,3}"#"{1,6}" "+ {

    printf("Balise de titre\n");

    //Changement d'état : TITRE
    BEGIN TITRE;
    strcpy(etatActuel, "Titre");

    return BALTIT;
}
<TITRE>(\n|\r\n)(" "*(\n|\r\n))* {

    printf("Fin de Titre\n");

    //Changement d'état : INITIAL
    BEGIN INITIAL;
    strcpy(etatActuel, "Normal");

    return FINTIT;
}

"*"" "?	{

    printf("Etoile\n");

    return ETOILE;
}


([^#"_""*"(\r\n)\n]|(\\\*))+ {

    //affichage du moceau de texte
    printf("Morceau de texte : %s\n", yytext);

    //ajout du morceau de texte dans le tableau contenant tout le texte
    strncat(tableau, yytext, yyleng);

    //mise à jour du tableau des symboles
    pos[indiceLigne][0] = positionDebutMot;
    positionDebutMot += yyleng;
    pos[indiceLigne][1] = yyleng;
    strcpy(etat[indiceLigne][0], etatActuel);
    indiceLigne++;
    strcpy(etat[indiceLigne][0], etat[indiceLigne-1][0]);

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

void organisationItem(char newOrgaItem[100], int ligne){
    //on modifie la valeur de l'organisation des items dans une liste
        strcpy(etat[ligne][2], newOrgaItem);//[indiceLigne -1] car on incrémente indiceLigne (dans le lex) avant d'envoyer les infos au yacc
}