/*==============================================================================
Projet Compilateur lex/yacc fait par :
Yann MOURELON
Daniel PINSON

participation étape 5 :
Ilyas TAHIR
==============================================================================*/


%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    char tableau[1024];
    char etat[100][4][100];
    int pos[100][3];
    int indiceLigne = 0;
    int indiceParagraphe = 0;

    void yyerror(char* s);
    int yylex();

    //Modification du tableau synthaxique
    void miseEnForme(char newMiseEnForme[100]);

    void affichInformations();
    int calcElements();

    //Generation de l'HTML
    void creationHTML();
    void transformationHTML();

    //ecriture HTML
    void ecriture(FILE* fichier, int debutPhrase, int finPhrase);
    void ecritureNormal(FILE* fichier, int i, int debutPhrase, int finPhrase);
    void ecritureTitre(FILE* fichier, int i, int debutPhrase, int finPhrase);
    void ecritureListe(FILE* fichier, int i, int debutPhrase, int finPhrase);
    void ecritureGras(FILE* fichier, int debutPhrase, int finPhrase);
    void ecritureItalique(FILE* fichier, int debutPhrase, int finPhrase);
    void ecritureGrasItalique(FILE* fichier, int debutPhrase, int finPhrase);
%}

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

    italique : ETOILE TXT ETOILE
    {
        miseEnForme("italique");
    }
    gras : ETOILE ETOILE TXT ETOILE ETOILE
    {
        miseEnForme("gras");
    }
    grasitalique : ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE
    {
        miseEnForme("gras+italique");
    }
%%

int main(){

    yyparse();

    affichInformations();

    creationHTML();
    transformationHTML();

    return 0;
}  

void miseEnForme(char newMiseEnForme[100]){
    //on modifie la valeur de mise en forme
        strcpy(etat[indiceLigne-1][1], newMiseEnForme);//[indiceLigne -1] car on incrémente indiceLigne (dans le lex) avant d'envoyer les infos au yacc
}

int yylex(YYSTYPE *, void *);

void yyerror(char* s){

    if (strcmp(s, "synthax error")){
        printf("\033[31;1m");
        printf("\nerreur synthaxique\n");
        printf("\033[31;0m");
    }
}

void creationHTML(){

    if(remove("Result.html") == 0){
        printf("Le fichier Result.html à été supprimé avec succès.\n");
    }
    else{
        printf("Impossible de supprimer le fichier Result.html\n");
    }
    
    FILE* fichier = NULL;

    fichier = fopen("Result.html", "w");

    if(fichier != NULL){

        //entête fichier html
        fputs("<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n\t<title>Document</title>\n</head>\n<body>\n", fichier);

        fclose(fichier);
    }
}

void affichInformations(){

    int taillePosEtat = calcElements();


    //Affichage du tableau de symboles
    printf("talbeau de symbole = \n");
    for(int i=0; i<taillePosEtat; i++){
        printf("%-8d|%-8d|%-8s|%-15s|%-15s|%-2s|%-2d|\n", pos[i][0], pos[i][1], etat[i][0], etat[i][1], etat[i][2], etat[i][3], pos[i][2]);
    }
    printf("\n");
    
    /*Calcul nombre element dans tableau*/
    int tailletableau = 0;
    while(tableau[tailletableau] != '\0'){

        tailletableau++;
    }

    //Affichage du contenu textuel du fichier source
    printf("tableau = %s\n", tableau);
}

int calcElements(){
    //Calcul de la taille du tableau pos
    int taillePosEtat = 0;
    while(pos[taillePosEtat][1] != 0){
        
        taillePosEtat++;
    }
    return taillePosEtat;
}

void transformationHTML(){

    FILE* fichier = NULL;

    fichier = fopen("Result.html", "r+");

    int taillePosEtat = calcElements();

    if(fichier != NULL){

        fseek(fichier, 0, SEEK_END);

        for(int i=0; i<taillePosEtat; i++){

            int debutPhrase = pos[i][0];
            int finPhrase = pos[i][0]+pos[i][1];

            //strcmp c'est d'la merde, ça renvois 0 si c ok
            //on verifie si on est dans l'etat Normal
            if(!strcmp(etat[i][0], "Normal")){
                ecritureNormal(fichier, i, debutPhrase, finPhrase);

            //on verifie si on est dans l'état Titre
            }else if(!strcmp(etat[i][0], "Titre")){
                ecritureTitre(fichier, i, debutPhrase, finPhrase);

            //On vérifie si on est dans l'état Item
            }else if(!strcmp(etat[i][0], "Item")){
                ecritureListe(fichier, i, debutPhrase, finPhrase);
            }
        }

        fputs("</body>\n</html>", fichier);
        fclose(fichier);
    }

}

void ecritureNormal(FILE* fichier, int i, int debutPhrase, int finPhrase){
    
    //On vérifie si on sort d'une liste ou non
    if(!strcmp(etat[i][2], "FinListe")){

        fputs("</li>\n", fichier);
        fputs("\t</ul>\n", fichier);
    }
    
    //On vérifie dans quel paragraphe on se situe
    if(i != 0){
        if(strcmp(etat[i-1][0], "Normal")){
            fputs("\t<p>", fichier);
        }else{
            if(pos[i-1][2] != pos[i][2]){
                fputs("\t<p>", fichier);
            }
        }
    }else{
        fputs("\t<p>", fichier);
    }

    //On vérifie le type d'écriture
    if(!strcmp(etat[i][1], "italique")){
        ecritureItalique(fichier, debutPhrase, finPhrase);
    }else if(!strcmp(etat[i][1], "gras")){
        ecritureGras(fichier, debutPhrase, finPhrase);
    }else if(!strcmp(etat[i][1], "gras+italique")){
        ecritureGrasItalique(fichier, debutPhrase, finPhrase);
    }else{
        ecriture(fichier, debutPhrase, finPhrase);
    }

    //On ferme le paraghaphe si on change de paragraphe derriere
    if(pos[i+1][2] != pos[i][2] || strcmp(etat[i+1][0], etat[i][0])){
        fputs("</p>\n", fichier);
    }
}

void ecritureTitre(FILE* fichier, int i, int debutPhrase, int finPhrase){
    if(!strcmp(etat[i][2], "FinListe")){

        fputs("</li>\n", fichier);
        fputs("\t</ul>\n", fichier);
    }

    fprintf(fichier, "\t<h%s>", etat[i][3]);

    ecriture(fichier, debutPhrase, finPhrase);

    fprintf(fichier, "</h%s>\n", etat[i][3]);
}

void ecritureListe(FILE* fichier, int i, int debutPhrase, int finPhrase){
    if(!strcmp(etat[i][2], "DebutListe")){
        if(i != 0){
            if(!strcmp(etat[i-1][0], "Item")){
                fputs("</li>\n\t</ul>\n", fichier);
            }
                        
        }
        fputs("\t<ul>\n", fichier);
        fputs("\t\t<li>", fichier);
    }

    if(!strcmp(etat[i][2], "ChangementItem")){
        fputs("\t\t<li>", fichier);
    }

    if(!strcmp(etat[i][1], "italique")){
        ecritureItalique(fichier, debutPhrase, finPhrase);
    }else if(!strcmp(etat[i][1], "gras")){
        ecritureGras(fichier, debutPhrase, finPhrase);
    }else if(!strcmp(etat[i][1], "gras+italique")){
        ecritureGrasItalique(fichier, debutPhrase, finPhrase);
    }else{
        ecriture(fichier, debutPhrase, finPhrase);
    }
                
    if(!strcmp(etat[i+1][2], "ChangementItem")){
        fputs("</li>\n", fichier);
    }

    if(!strcmp(etat[i][2], "FinListe")){

        fputs("</li>\n", fichier);
        fputs("\t</ul>\n", fichier);
    }
}

void ecritureGras(FILE* fichier, int debutPhrase, int finPhrase){
    fputs("<b>", fichier);
    ecriture(fichier, debutPhrase, finPhrase);
    fputs("</b>", fichier);
}

void ecritureItalique(FILE* fichier, int debutPhrase, int finPhrase){
    fputs("<i>", fichier);
    ecriture(fichier, debutPhrase, finPhrase);
    fputs("</i>", fichier);
}

void ecritureGrasItalique(FILE* fichier, int debutPhrase, int finPhrase){
    fputs("<b><i>", fichier);
    ecriture(fichier, debutPhrase, finPhrase);
    fputs("</b></i>", fichier);
}

void ecriture(FILE* fichier, int debutPhrase, int finPhrase){

    for(int j=debutPhrase; j<finPhrase; j++){

        //Si on rencontre un '\*', on ignore le '\'
        if(tableau[j] == '\\' && tableau[j+1] == '*'){
            j++;
        }
        
        fputc(tableau[j], fichier);
    }
}