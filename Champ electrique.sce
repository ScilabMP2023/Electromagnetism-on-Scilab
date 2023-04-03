function champelec(F0)//F0 est la matrice que l'on insert avec les potentiels de base, N est le nombre d'équipotentiel
    tic()
    if size(size(F0))(2)> [2] then
        b = F0(:,:,2)
    else
        b=0
    end
    [Nx,Ny,Nz]=size(F0)// on prend les valeurs de ligne et de colonne de F0
    Nx = Nx/2
    Ny = Ny/2
    F0E = zeros(Nx+2,Ny+2) ;
    F0E(2:Nx+1,2:Ny+1) = F0(1:Nx,1:Ny,1) ;
    B = zeros(Nx+2,Ny+2) ; 
    B(2:Nx+1,2) = 1 ;
    B(2:Nx,Ny+1) = 1 ;
    B(2,2:Ny+1) = 1 ;
    B(Nx+1,2:Ny+1) = 1 ; 
    B(2:Nx+1,2:Ny+1) = abs(sign(F0(1:Nx,1:Ny,1)))+b ;//La matrice B prend la valeur de F0
    F = F0(:,:,1) ; 
    Fcour = zeros(Nx+2,Ny+2) ;
    H = 0.25*[0,1,0;1,0,1;0,1,0] ;
    eps = 1e-2 ;
    for i = 1:2000 ;
        Fcour = conv2(F,H) ; 
        Fcour = Fcour.*(1-B) + F0E.*B ; 
        e = max(abs(F(1:Nx,1:Ny)-Fcour(2:Nx+1,2:Ny+1))) 
        if (e <= eps) then
            disp("La convergence à  eu lieu, i = ",i) ;
            break ;
        end
        F(1:Nx,1:Ny) = Fcour(2:Nx+1,2:Ny+1) ; 
    end
    // calcul du champ electrique
    E = F
    E0E = zeros(Nx+2,Ny+2) ;
    E0E(2:Nx+1,2:Ny+1) = E(1:Nx,1:Ny) ;
    EP = zeros(Nx+2,Ny+2) ; 
    EP(2:Nx+1,2) = 1 ;
    EP(2:Nx,Ny+1) = 1 ;
    EP(2,2:Ny+1) = 1 ;
    EP(Nx+1,2:Ny+1) = 1 ; 
    EP(2:Nx+1,2:Ny+1) = abs(sign(E(1:Nx,1:Ny))) ;//La matrice B prend la valeur de F0
    Excour = zeros(Nx+2,Ny+2) ;
    Eycour = zeros(Nx+2,Ny+2) ;
    gradientx = 0.5*[0,0,0;1,0,-1;0,0,0]
    gradienty = 0.5*[0,1,0;0,0,0;0,-1,0]
    for i = 1:2000
        Excour = conv2(E,gradientx) ;
        Eycour = conv2(E,gradienty) ; 
        Excour = Excour.*(1-EP) + E0E.*EP ;
        Eycour = Eycour.*(1-EP) + E0E.*EP ;
        Exf(1:Nx,1:Ny) = Excour(2:Nx+1,2:Ny+1) ; 
        Eyf(1:Nx,1:Ny) = Eycour(2:Nx+1,2:Ny+1) ; 
    end
    z=toc()//affichage du temps d'exécution
    disp("temps de calcul:",string(z)+" s")
    // Visulaisation graphique
endfunction
