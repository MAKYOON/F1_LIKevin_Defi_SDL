# F1_LIKevin_Defi_SDL

Le programme propose un menu simple : 

Le 1 donne la différence entre SDL et SDL2
Le 2 affiche le dessin réalisé avec SDL
Le 3 affiche un bitmap grâce à SDL
Le 4 affiche le mini-jeu avec un hélicoptère qui suit le curseur de la souris, où on peut tirer des missiles à l'aide d'ESPACE sur Godzilla
Le 5 permet de quitter le programme

Le plus difficile résidait dans la découverte d'SDL et principalement les rectangles qui permettent la plus grosse partie du projet 
(le mini-jeu en soi).
 Une fois les bases assimilées on peut rajouter des éléments assez simplement. La gestion d'évènement n'est pas très compliquée.
(N'oublions pas également ces histoires de Directories qui fâchent un peu)

Un problème que j'ai eu : j'aurai souhaité que quand on touche Godzilla, il disparaisse de l'écran et ré-apparaisse quelques secondes après.
Je n'ai pas trouvé comment faire, car détruire et recréer la texture ne marcherait pas car il faut clear le render à un moment donné mais
cela effaçerait tout le reste.. c

