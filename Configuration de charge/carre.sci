function m=bresenham_carre(xp, yp, r ,m,v)
    //CarractÃ©ristiques initiales
    x = 0;
    y = r;
    d = 3-2*r;
    
    while x <= y do
        //affiche les points. 8 ligne car se sont des arcs de 0Â° Ã  45Â°
        figure(2);
        plot(xp+x, yp+y,'*r');
        plot(xp-x, yp+y,'*r');
        plot(xp+x, yp-y,'*r');
        plot(xp-x, yp-y,'*r');
        plot(xp+y, yp+x,'*r');
        plot(xp+y, yp-x,'*r');
        plot(xp-y, yp+x,'*r');
        plot(xp-y, yp-x,'*r');
        
        //RÃ©cuppÃ©ration des valeurs dans une matrice afin de pouvoir l'utiliser avec LaplaceJacobi
        m(xp+x, yp+y)=v;
        m(xp-x, yp+y)=v;
        m(xp+x, yp-y)=v;
        m(xp-x, yp-y)=v;
        m(xp+y, yp+x)=v;
        m(xp-y, yp+x)=v;
        m(xp+y, yp-x)=v;
        m(xp-y, yp-x)=v;
        
        //Formule du cour pour définir le carré
        if d <= 0 then
            d = d + 4*(x-y) + 10;
            
        else
            d = d + 4*x - 6;
            y = y - 1;
        end
        x = x + 1;
    end
    //on retourne la matrice après exécution de la fonction
    m=return (m);
endfunction
