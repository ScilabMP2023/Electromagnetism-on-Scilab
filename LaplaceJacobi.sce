function LaplaceJacobi(F0, N)//F0 est la matrice de taille (Nx,Ny,2) que l'on insert avec les charge de base avec comme deuxième fond la matrice contenant les charges nuls, N est le nombre d'Équipotentiel
    if size(size(F0))(2)> [2] then
        b = F0(:,:,2)
    else
        b=0
    end
    tic()
    [Nx,Ny]=size(F0)// on prend les valeurs de ligne et de colonne de F0
    F0E = zeros(Nx+2,Ny+2) ;
    F0E(2:Nx+1,2:Ny+1) = F0(1:Nx,1:Ny) ;
    B = zeros(Nx+2,Ny+2) ; 
    B(2:Nx+1,2) = 1 ;
    B(2:Nx,Ny+1) = 1 ;
    B(2,2:Ny+1) = 1 ;
    B(Nx+1,2:Ny+1) = 1 ; 
    B(2:Nx+1,2:Ny+1) = abs(sign(F0(1:Nx,1:Ny))) +b;//La matrice B prend la valeur de F0 et rajoute la matrice de charge nul s'il le faut
    F = F0 ; 
    Fcour = zeros(Nx+2,Ny+2) ;
    H = 0.25*[0,1,0;1,0,1;0,1,0] ;
    eps = 1e-2 ;
    for i = 1:2000 ;
        Fcour = conv2(F(:,:,1),H) ; 
        Fcour = Fcour.*(1-B) + F0E.*B ; 
        e = max(abs(F(1:Nx,1:Ny)-Fcour(2:Nx+1,2:Ny+1))) 
        if (e <= eps) then
            disp("La convergence à  eu lieu, i = ",i) ;
            break ;
        end
        F(1:Nx,1:Ny) = Fcour(2:Nx+1,2:Ny+1) ; 
    end
    z=toc()//affichage du temps d'exécution
    disp("temps de calcul:",string(z)+" s")
endfunction 
