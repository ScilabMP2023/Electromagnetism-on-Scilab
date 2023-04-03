// Test de simulation de mouvement de particules chargées dans un champ électromagnétique
// ======================================================================================
// 
// JL BURAUD mars 2023.
// Cas élémentaire champ E et B uniformes et constants.
// Limitation : mécanique classique (s'assurer que la vitesse obtenue est toujours très inférieur
// à celle de la lumière)
//
// Code des fonctions utilisées
// ----------------------------
// Produit vectoriel
// La fonction PV(A,B) calcul le produit vectoriel des deux vecteurs A et B à 3 composantes
function [C] = PV(A,B)
    C(1) = A(2)*B(3) - A(3)*B(2) ;
    C(2) = A(3)*B(1) - A(1)*B(3) ;
    C(3) = A(1)*B(2) - A(2)*B(1) ;
endfunction
//
//Utilisation de ODE pour la résolution
// Pour résoudre une équation différentielle ordinaire du type :
// dy/dt = f(t,y) (attention à l'ordre des termes : t est en premier)
// la syntaxe est y = ode(y0,t0,t,f)
// où y0 est le vecteur des conditions initiales, t0 la date initiale et t le vecteur des dates de calcul
// t = [t(1), t(2),...]
// y est le vecteur de retour y=[y(t(1)),y(t(2)),...].
//
// Fonction d'initialisation du champ (différentes configurations sont possibles)
// Le choix ci-dessous produit un mouvement hélicoïdal
function [E,B] = ChampEM(E,B)
    // Cas simple 
    E(1) = 0;
    E(2) = 0;
    E(3) = 0;
    B(1) = 0;
    B(2) = 0;
    B(3) = 10;
endfunction
// Constantes de la particule
// Cas d'un électron
q = -1.602176634E-19 ;  // en Coulomb
m = 9.1093837015E-31 ; // en kg
// Champ électromagnétique déclaration des vecteurs pour appel avec la fonction ChampEM
E = zeros(3,1) ;        // Champ électrique nul. Vecteur colonne : indispensable pour ode
B = zeros(3,1) ;        // Champ magnétique nul. Vecteur colonne : indispensable pour ode

// Calcul de la fonction f
// Le principe fondamental donne : mdv/dt = q[E + v vecteur B] et x = dv/dt
// Soit V = [x ; v].
// la fonctioçn inconnue est la position de la particule, sa dérivée est la vitesse.
// D'où f(t,V) = dV/dt = [v ; (q/m)*(E + PV(v,B))]. Vecteur colonne (3 comp x + 3 comp v)
function [Vdiscret] = fonc(t,V)
    Vdiscret(1:3) = V(4:6) ;
    Vdiscret(4:6) = E + PV(V(4:6),B) ;
    Vdiscret(4:6) = (q/m)*Vdiscret(4:6) ;
endfunction
//
//
// Code programme principal
// -------------------------
//
// On initialise le champ électromagnétique
[E,B] = ChampEM(E,B) ;
//
// On se donne des conditions initiales
x0(1) = 0 ;
x0(2) = 0 ;
x0(3) = 0 ;
v0(1) = 0 ; // vitesse initiale (m.s-1)
v0(2) = 10 ;
v0(3) = 0 ;  // Cas simple pour avoir une hélice
t0 = 0 ;    // date initiale
// Vecteur initial pour ode
y0 = [x0(1);x0(2);x0(3);v0(1);v0(2);v0(3)] ;    // Vecteur colonne (pour ode)
// Dans ce cas simple la pulsation cyclotron est wc = abs(qB/m)
wc = norm(q*B/m) ;   // On utilise la norme au lieu de abs(q*B(3)) 
// car cela permet de regarder une pulsation quelque soit B
// Pour observer trois rotations il faut la durée :
duree = 6*%pi/wc ;  // à redéfinir si B = 0 (car alors wc = 0)
tmin = t0 ;
tmax = tmin + duree ;
Ndates = 10000 ;     // Nombre de dates pour calculer la vitesse
Dt = (tmax-tmin)/Ndates ;
Inter_t = tmin :Dt:tmax ;
// Appel à ODE :
V = ode(y0,t0,Inter_t,fonc)     // v est une matrice de 3 lignes et N+1 colonnes 
// chaque colonne est une valeur du vecteur position (indice 1 à 3) 
// et du vecteur vitesse ( indice 4 à 6).
//
// Test observation de la solution
figure(1,"name","Observation de la vitesse")
param3d(V(4,:), V(5,:), V(6,:)) ;   // Dans ce cas cela donne un cercle d'altitude voz et de rayon v0x.
//
figure(2,"name","Observation de la position")
param3d(V(1,:), V(2,:), V(3,:)) ;   // Dans ce cas cela donne une hélice de pas v0z*2*pi/wc et de rayon 10.
