%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void yyerror(char* s);
    int yylex();
    char chaine[1024];
%}

%union {
    char text[1024];
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

    element : TXT { strcpy(chaine, $1);}
            | LIGVID ;
            | titre ;
            | liste ;
            | texte_formatte;

    titre : BALTIT TXT FINTIT { strcpy(chaine, $2);}

    liste : DEBLIST liste_textes suite_liste ;

    suite_liste : ITEMLIST liste_textes suite_liste ;
                | FINLIST ;

    texte_formatte : italique ;
                   | gras ;
                   | grasitalique ;

    liste_textes : TXT { strcpy(chaine, $1);}
                 | texte_formatte ;
                 | TXT liste_textes { strcpy(chaine, $1);}
                 | texte_formatte liste_textes ;

    italique : ETOILE TXT ETOILE { strcpy(chaine, $2);}
    gras : ETOILE ETOILE TXT ETOILE ETOILE { strcpy(chaine, $3);}
    grasitalique : ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE { strcpy(chaine, $4);}
%%

int main(){

    yyparse();
    printf("\033[32;1mCH : %s\033[31;0m\n", chaine);

    printf("\n");
    yywrap();

    return 0;
}  

int yylex(YYSTYPE *, void *);

void yyerror(char* s){
    //printf("\033[32;1mchaine = %s\033[31;0m\n", chaine);
    if (strcmp(s, "synthax error"))
        printf("\n\033[31;1merreur synthaxique\033[0m\n", s);
}