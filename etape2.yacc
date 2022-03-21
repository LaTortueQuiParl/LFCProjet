%{
    #include <stdio.h>
    #include <stdlib.h>

    void yyerror(char* s);
%}

//Emplacement Tokens (%token)
%token fichier
%token element
%token titre
%token liste
%token suite_liste
%token texte_formatte
%token liste_textes

%start P

//Règles
%%

    P: 
%%

int main(){

    return 0;
}