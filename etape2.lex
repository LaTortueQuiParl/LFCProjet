%{
    #include <stdio.h> 
%}
RETOURLIGNE (\n)|(\r\n)
ETOILE \*
LIGNEVIDE {RETOURLIGNE}((\ )*{RETOURLIGNE})+
TITRE ^\ {0,3}#{1,6}\ +
UNDERSCORE _
TEXTE [^\ \t#_\*][^#_\*]*
%%
{TEXTE} {
    printf("Morceau de texte\r\n");
    //printf("%s\r\n", yytext);
}
{ETOILE} {
    printf("Etoile\r\n");
}
{UNDERSCORE} {
    printf("Underscore\r\n");
}
{RETOURLIGNE} {
    printf("Retour à la ligne simple\r\n");
}
{LIGNEVIDE} {
    printf("Ligne vide\r\n");
}
{TITRE} {
    printf("Balise de début de titre\r\n");
}
^{ETOILE}\ + {
    printf("Point de liste\r\n");
}
# {
    printf("Caractère non autorisé\r\n");
}
. ;
%%