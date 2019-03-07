program defi;
{$UNITPATH /SDL2}

uses SDL2,SDL2_Image,SDL2_ttf,crt,sysutils;

const FPS = 50;

var
  fenetre: PSDL_Window;
  render: PSDL_Renderer;

  font : PTTF_Font;
  sdlColor1, sdlColor2 : PSDL_Color;

  score_surface,rider_surface : PSDL_Surface;
  helicopter,missile,godzilla,score_texture, rider_texture,hey_texture: PSDL_Texture;

  rect_helico,position_helico : TSDL_Rect;
  rect_missile, position_missile : TSDL_Rect;
  rect_godzilla,position_godzilla : TSDL_Rect;
  position_score : TSDL_Rect;
  rect_rider,position_rider: TSDL_Rect;
  rect_hey,position_hey : TSDL_Rect;

  i,j,score, choix: integer;

  fin,touche,finprog : boolean;

  evenement: PSDL_Event;

  timerFPS : longint;

  affichage_score : ansistring;

  itos : string;


Procedure initialisation_helico;
//BUT : initialisation des systèmes, images et variables
//ENTREE : tout ce qui est nécessaire à l'initialisation
//SORTIE : rien
BEGIN
  randomize;
  new (evenement); // allocation de la mémoire pour les évènements
  fin := false; //initialisation du booleen qui gère la boucle while à "faux"
  touche:= false; //gère l'appui sur la touche 'ESPACE'
  //initialisation du sous-systeme video
  SDL_Init(SDL_INIT_VIDEO);
  //initialisation du ttf
  TTF_Init();
  //création de la fenetre
  SDL_CreateWindowAndRenderer(1000, 500, SDL_WINDOW_SHOWN, @fenetre, @render);

  // qualite de l'image
  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, '2');

  new(sdlColor1);
  sdlColor1^.r := 255; sdlColor1^.g := 255; sdlColor1^.b := 255; sdlColor1^.a:= 0;
    new(sdlColor2);
  sdlColor2^.r := 0; sdlColor2^.g := 0; sdlColor2^.b := 0; sdlColor2^.a := 0;

  font := TTF_OpenFont('assets\arial.ttf', 50); //création de la police qui va être utilisée
  TTF_SetFontStyle(font,TTF_STYLE_BOLD); //mise en gras du texte


  // chargement de l'image
  helicopter := IMG_LoadTexture( render, 'assets\helicopter.png' );
  missile := IMG_LoadTexture( render, 'assets\missile.png' );
  godzilla := IMG_LoadTexture( render, 'assets\godzilla.png' );

  //rectangle de copie de l'hélicoptère
  position_helico.x := 500; // x et y définissent sa position
  position_helico.y := 200;
  position_helico.w := 128; // w et h les dimensions du rectangles (adaptées à l'image de l'hélicoptère)
  position_helico.h := 55;

  position_score.w := 100;  //taille du rectangle de score
  position_score.h := 50;

// rectangle qui définit ce qui va être copié de l'image
  rect_missile.w := 379;
  rect_missile.h := 133;

  position_missile.w := 50; //ces coordonnées resizent l'image (de 379x133 à 50x50)
  position_missile.h := 50;

 // ici on définit ce qui va être copié de l'image
  rect_godzilla.w := 150;
  rect_godzilla.h := 200;

  position_godzilla.x := random(900); // la on resize et on définit sa position aléatoire
  position_godzilla.y := random(400);
  position_godzilla.w := 100;
  position_godzilla.h := 100;
END;

Procedure event;
//BUT : gérer les évènements (souris, clavier)
//ENTREE : souris ou clavier
//SORTIE : rien
BEGIN
    //on détecte et renvoie la gestion d'évènements
  while SDL_PollEvent(evenement) = 1 do
    begin
      case evenement^.type_ of
        SDL_MOUSEMOTION: begin
                              position_helico.x := evenement^.motion.x ; //on place l'hélico à la position x et y de la souris
                              position_helico.y := evenement^.motion.y ;
                         end;
        SDL_KEYDOWN : begin
                          if (evenement^.key.keysym.sym=SDLK_SPACE) then // ici si la touche espace est appuyée, on créer le missile
                           begin
                                position_missile.x := position_helico.x - 50;
                                position_missile.y := position_helico.y + 50;
                                touche := true;
                           end;
                      end;
        end;
      if (evenement^.key.keysym.sym=SDLK_ESCAPE) then //permet de quitter le programme
        fin:= true;
    END;
END;

Procedure tir;
//BUT : tirer un missile
//ENTREE : la variable touche en true
//SORTIE : rien
BEGIN
        if (touche=true) then //touche devient true quand on appuie sur espace
      begin
          for j:= 1 to 50 do //mouvement du missile
          begin
           position_missile.x := position_missile.x - 1;
            if ((position_missile.x = position_godzilla.x) and ((position_missile.y >= position_godzilla.y) and (position_missile.y <= position_godzilla.y+100))) then //détection de la collision avec godzilla
            begin
                score := score + 100;
                position_godzilla.x := random(900); // la on resize et on définit sa position aléatoire
                position_godzilla.y := random(400);
            end;
           SDL_RenderCopy(render, missile, @rect_missile, @position_missile);
          end;
      end;
END;
Procedure destroy;
//BUT : tout détruire et clear la mémoire
//ENTREE : des fonctions
//SORTIE : rien
BEGIN
  // on détruit tout
  dispose(evenement);
  SDL_DestroyTexture( score_texture );
  SDL_DestroyTexture(godzilla);
  SDL_DestroyTexture(missile);
  SDL_DestroyTexture(helicopter);
  SDL_FreeSurface( score_surface);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow (fenetre);
  //on quitte SDL
  SDL_Quit;
END;


procedure jeu;
//BUT : afficher le mini jeu
//ENTREE : toutes les fonctions nécessaires au bon déroulement
//SORTIE : rien
BEGIN
  initialisation_helico();
  score := 0;
  i := 0;
  SDL_ShowCursor(SDL_DISABLE); //on désactive le pointeur de souris (visuellement moche)
//boucle principale de jeu
while (fin <> true) do
begin
    timerFPS:= SDL_GetTicks(); //on récupère le temps depuis le début du programme
    event(); //on gère les évènements
	  rect_helico.x := i*128; //permet de parcourir les différentes phases de l'hélicoptère
	  rect_helico.y := 0;
	  rect_helico.w := 128;
	  rect_helico.h := 55;
    i:=i+1;
    IF i>4 THEN i:=0;
    itos := inttostr(score); //passage de score en string
    affichage_score:= ('SCORE :' + itos); //texte qui affiche le score
    score_surface := TTF_RenderText_Shaded(font,PChar(affichage_score),sdlColor1^,sdlColor2^); //création de la surface avec le texte, sa couleur et sa police
    score_texture := SDL_CreateTextureFromSurface( render, score_surface ); //passage de la surface à la texture
    timerFPS:=SDL_GetTicks() - timerFPS; // linges 170-172 : permettent de limiter le nombre d'images par secondes, définie par la constante FPS
    if(timerFPS<1000 DIV FPS) then
       SDL_Delay((1000 DIV FPS) - timerFPS);
    SDL_RenderCopy(render, score_texture, NIL, @position_score ); //on copie le score dans le render
    SDL_RenderCopy(render, helicopter, @rect_helico, @position_helico); //on copie l'hélicoptère dans le render
    SDL_RenderCopy(render, godzilla, @rect_godzilla, @position_godzilla); //on copie le monstre dans le render
    tir(); //on gère le tir
    SDL_RenderPresent(render); // et on affiche le tout
    SDL_RenderClear(render); //permet d'effacer l'image précédente à chaque fois
END;
destroy();
END;

procedure bitmap;
//BUT : afficher le bitmap
//ENTREE : le bitmap
//SORTIE : rien
begin
  SDL_Init(SDL_INIT_VIDEO);
  SDL_CreateWindowAndRenderer(1000, 500, SDL_WINDOW_SHOWN, @fenetre, @render);
  rider_surface := SDL_LoadBMP('assets\rider.bmp'); 
  rider_texture := SDL_CreateTextureFromSurface(render, rider_surface);
  hey_texture := IMG_LoadTexture(render,'assets\hey.png');

  rect_rider.w := 123;
  rect_rider.h := 87;

  rect_hey.w := 244;
  rect_hey.h := 151;

  position_rider.x := 350;
  position_rider.y := 100;
  position_rider.w := 300;
  position_rider.h := 300;

  position_hey.x := 475;
  position_hey.y := 20;
  position_hey.w := 100;
  position_hey.h := 100;

  SDL_RenderCopy(render, rider_texture, @rect_rider, @position_rider);
  SDL_RenderCopy(render, hey_texture, @rect_hey, @position_hey);
  SDL_RenderPresent(render);
  SDL_Delay(5000);

  SDL_DestroyTexture(rider_texture);
  SDL_DestroyTexture(hey_texture);
  SDL_FreeSurface(rider_surface);
  SDL_DestroyRenderer(render);
  SDL_DestroyWindow (fenetre);
  SDL_Quit;
end;

procedure dessin;
//BUT : dessiner
//ENTREE : des rectangles et des lignes
//SORTIE : rien
var x1,y1,x2,y2 : integer;
begin
  SDL_Init(SDL_INIT_VIDEO);
  SDL_CreateWindowAndRenderer(1000, 500, SDL_WINDOW_SHOWN, @fenetre, @render);
  SDL_RenderClear(render);

  SDL_SetRenderDrawColor(render, 250, 255, 0, SDL_ALPHA_OPAQUE);
//on "colorie" les triangle
  x1 := 357; y1 := 190; y2 := 400; 
  for x2:=200 to 500 do
  begin
  SDL_RenderDrawLine(render, x1, y1, x2, y2 );
  end;

  x1 := 500; y1 := 0; y2 := 190;
  for x2:=357 to 643 do
  begin
  SDL_RenderDrawLine(render, x1, y1, x2, y2 );
  end;

  x1 := 643; y1 := 190; y2 := 400;
  for x2:=500 to 800 do
  begin
  SDL_RenderDrawLine(render, x1, y1, x2, y2 );
  end;

  SDL_RenderPresent(render);
  SDL_Delay(5000);

  SDL_DestroyRenderer(render);
  SDL_DestroyWindow (fenetre);
  SDL_Quit;
end;
//programme principal
BEGIN
clrscr;
finprog := false;
while (finprog<>true) do
begin
    writeln('Tapez 1 pour la difference entre SDL et SDL2');
    writeln('Tapez 2 pour le dessin, se ferme automatiquement au bout de 5 secondes');
    writeln('Tapez 3 pour afficher le bitmap, se ferme automatiquement au bout de 5 secondes');
    writeln('Tapez 4 pour le mini-jeu, attention de bien cliquer sur la fenetre. Tirez avec ESPACE.');
    writeln('Tapez 5 pour quitter');
    readln(choix);
    case choix of
     1 : begin
         clrscr;
         writeln('SDL2 est tout simplement une mise a jour importante de SDL, une version 2.0.');
         writeln('Elle est plus optimisee, supporte et permet de faire plus de choses qu''auparavant');
         writeln('Surtout, elle est distribuee sous la licence zlib qui permet d''etre utilisee gratuitement sous n''importe quel projet, sans avoir besoin de preciser son usage, ce qui n''etait pas forcement le cas de la licence LGPL sous SDL1.2. ');
         writeln();
        end;
     2 : dessin(); 
     3 : bitmap(); 
     4 : jeu(); 
     5 : finprog := true;
    end;
    while ((choix<1) or (choix>5)) do
    begin
      writeln('Bien essaye ! Entre 1 et 5 maintenant je vous prie');
      readln(choix);
      end;
end;
end.

