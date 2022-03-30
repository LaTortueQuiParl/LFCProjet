%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    char tableau[1024];

    void yyerror(char* s);
    int yylex();
%}

%union {
    char text[128];
}

//Emplacement Tokens (%token)
%token <text> TXT
%token <text> BALTIT
%token <text> FINTIT
%token <text> LIGVID
%token <text> DEBLIST
%token <text> ITEMLIST
%token <text> FINLIST
%token <text> ETOILE

%start fichier

%type <text> element
%type <text> titre
%type <text> liste
%type <text> suite_liste
%type <text> texte_formatte
%type <text> liste_textes
%type <text> gras
%type <text> grasitalique
%type <text> italique

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

    //printf("tableau = %s\n", tableau);
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