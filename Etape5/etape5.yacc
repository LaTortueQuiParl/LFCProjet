%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    char tableau[1024];
    char etat[14][100];
    int pos[14][2];
    void yyerror(char* s);
    int yylex();
%}

%union {
    char text[128];
}

//Emplacement Tokens (%token)
%token TXT
%token BALTIT
%token FINTIT
%token LIGVID
%token DEBLIST
%token ITEMLIST
%token FINLIST
%token ETOILE

%start fichier

%type element
%type titre
%type liste
%type suite_liste
%type texte_formatte
%type liste_textes
%type gras
%type grasitalique
%type italique

//Règles
%%
    fichier : element ;
            | element fichier ;

    element : TXT ;
            | LIGVID ;
            | titre ;
            | liste ;
            | texte_formatte ;

    titre : BALTIT TXT FINTIT ;

    liste : DEBLIST liste_textes suite_liste ;

    suite_liste : ITEMLIST liste_textes suite_liste ;
                | FINLIST ;

    texte_formatte : italique ;
                   | gras ;
                   | grasitalique ;

    liste_textes : TXT ;
                 | texte_formatte ;
                 | TXT liste_textes ;
                 | texte_formatte liste_textes ;

    italique : ETOILE TXT ETOILE ;
    gras : ETOILE ETOILE TXT ETOILE ETOILE ;
    grasitalique : ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE ;
%%

int main(){

    yyparse();

    printf("talbeau de symbole = \n");    
    for(int i=0; i<14; i++){
        printf("%-8d|%-8d|%-8s|\n", pos[i][0], pos[i][1], etat[i]);
    }

    printf("tableau = %s\n", tableau);

    return 0;
}  

int yylex(YYSTYPE *, void *);

void yyerror(char* s){
    if (strcmp(s, "synthax error")){
        printf("\033[31;1m");
        printf("\nerreur synthaxique\n", s);
        printf("\033[31;0m");
    }
}