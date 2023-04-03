function m=bersenham_cercle(xp, yp, r, m, V)
    //Carractéristiques initiales
    x = 0;
    y = r;
    d = 3-2*r;
    
    while x < y do
        //affiche les points. 8 ligne car se sont des arcs de 0° à 45°
        figure(1);
        plot(xp+x, yp+y,'*r');
        plot(xp-x, yp+y,'*r');
        plot(xp+x, yp-y,'*r');
        plot(xp-x, yp-y,'*r');
        plot(xp+y, yp+x,'*r');
        plot(xp+y, yp-x,'*r');
        plot(xp-y, yp+x,'*r');
        plot(xp-y, yp-x,'*r');
        
        //Récuppération des valeurs dans une matrice afin de pouvoir l'utiliser avec LaplaceJacobi
        m(xp+x, yp+y)=V;
        m(xp-x, yp+y)=V;
        m(xp+x, yp-y)=V;
        m(xp-x, yp-y)=V;
        m(xp+y, yp+x)=V;
        m(xp-y, yp+x)=V;
        m(xp+y, yp-x)=V;
        m(xp-y, yp-x)=V;
        
        //Formule du cour pour définir le cercle
        if d > 0 then
            d = d + 4*(x-y) + 10;
            y = y - 1;
        else
            d = d + 4*x - 6;
        end
        x = x + 1;
    end
    //on retourne à la matrice après exécution de la fonction
    disp(m);
    m=return (m);
endfunction

function a=cercleLJ(Matrice,R,Cx,Cy,V)//R comprend deux valeurs [R1,R2]. Idem pour V
    M = zeros(Matrice,Matrice);
    b=bersenham_cercle(Cx,Cy,R(1),M,V(1))
    b1=b//On crée une copie de la première matrice contenant 1 cerlce
    b2=bersenham_cercle(Cx,Cy,R(2),b1,V(2))
    a=return(b2)
endfunction


