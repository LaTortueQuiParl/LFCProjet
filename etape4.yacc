%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void yyerror(char* s);
    int yylex();
    char chaine[1024] = "";
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
    fichier : element
            | element fichier
    element : TXT
            {
                printf("\033[33;1m elementTXT: yylval.text = %s\033[31;0m\n", yylval.text);
                strcat(chaine, yylval.text);
                printf("\033[34;1mchaine =%s\n\033[31;0m", chaine);
            }
            | LIGVID
            {
                //printf("\033[33;1m elementLIGVID: yylval.text = %s\t\$1=%s\033[31;0m\n", yylval.text, $1);
                //strcat(chaine, $1);
            }
            | titre
            | liste
            | texte_formatte;
    titre : BALTIT TXT FINTIT
            {
                printf("\033[33;1m titre: $2 = %s\033[31;0m\n", $2);
                //strcat(chaine, $2);
            }
    liste : DEBLIST liste_textes suite_liste
            {
                //printf("\033[33;1m liste: yylval.text = %s\033[31;0m\n", yylval.text);
                //strcat(chaine, $1);
            }
    suite_liste : ITEMLIST liste_textes suite_liste
            {
                //printf("\033[33;1m suite_listeITEM: $1 = %s\033[31;0m\n", $1);
                //strcat(chaine, $1);
            }
                | FINLIST
            {
                //printf("\033[33;1m suite_listeFINLIST: yylval.text = %s\033[31;0m\n", yylval.text);
                //strcat(chaine, yylval.text);
            }
    texte_formatte : italique
                   | gras
                   | grasitalique
    liste_textes : TXT
                    {
                        printf("\033[33;1m liste_textes: yylval.text = %s\033[31;0m\n", yylval.text);
                        //strcat(chaine, $1);
                    }
                 | texte_formatte
                 | TXT liste_textes
                    {
                        printf("\033[33;1m liste_textesList: $1 = %s\033[31;0m\n", $1);
                        //strcat(chaine, $1);
                    }
                 | texte_formatte liste_textes
    italique : ETOILE TXT ETOILE
            {
                printf("\033[33;1m italique: $2 = %s\033[31;0m\n", $2);
                //strcat(chaine, $2);
            }
    gras : ETOILE ETOILE TXT ETOILE ETOILE
            {
                printf("\033[33;1m gras: $3 = %s\033[31;0m\n", $3);
                //strcat(chaine, $3);
            }
    grasitalique : ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE
            {
                printf("\033[33;1m grasitalique: $4 = %s\033[31;0m\n", $4);
                //strcat(chaine, $4);
                printf("chaine=%s", chaine);
            }
%%

int main(){
    yyparse();
    printf("\033[32;1mchaine = %s\033[31;0m\n", chaine);
    return 0;
}  

int yylex(YYSTYPE *, void *);

void yyerror(char* s){
    printf("\033[32;1mchaine = %s\033[31;0m\n", chaine);
    if (strcmp(s, "synthax error"))
        printf("\n\033[31;1merreur synthaxique\033[0m\n", s);
}