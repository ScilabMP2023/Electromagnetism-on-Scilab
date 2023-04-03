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

a=cercleLJ(500,[49,20],250,250,[10,-10])
F0=a
N=20


    tic()
    [Nx,Ny]=size(F0)// on prend les valeurs de ligne et de colonne de F0
    F0E = zeros(Nx+2,Ny+2) ;
    F0E(2:Nx+1,2:Ny+1) = F0(1:Nx,1:Ny) ;
    B = zeros(Nx+2,Ny+2) ; 
    B(2:Nx+1,2) = 1 ;
    B(2:Nx,Ny+1) = 1 ;
    B(2,2:Ny+1) = 1 ;
    B(Nx+1,2:Ny+1) = 1 ; 
    B(2:Nx+1,2:Ny+1) = abs(sign(F0(1:Nx,1:Ny))) ;//La matrice B prend la valeur de F0
    F = F0 ; 
    Fcour = zeros(Nx+2,Ny+2) ;
    H = 0.25*[0,1,0;1,0,1;0,1,0] ;
    eps = 1e-2 ;
    for i = 1:2000 ;
        Fcour = conv2(F,H) ; 
        Fcour = Fcour.*(1-B) + F0E.*B ; 
        e = max(abs(F(1:Nx,1:Ny)-Fcour(2:Nx+1,2:Ny+1))) 
        if (e <= eps) then
            disp("La convergence à eu lieu, i = ",i) ;
            break ;
        end
        F(1:Nx,1:Ny) = Fcour(2:Nx+1,2:Ny+1) ; 
    end
    z=toc()//affichage du temps d'exécution
    disp("temps de calcul:",string(z)+" s")
    // Observation des équipotentielles
    figure(1)
    title("Tracé des surface equipotentielle dune distribution de charge")
    grayplot(1:Nx,1:Ny,F0')
    contour(1:Nx,1:Ny,F',N)
    colorbar(min(F0),max(F0))
    ylabel("Tension [V]")
    title("V")
