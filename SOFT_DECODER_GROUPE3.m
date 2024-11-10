function c_chapeau = SOFT_DECODER_GROUPE3(c, H, p, MAX_ITER)
    % Décodage LDPC soft avec l'algorithme Belief Propagation dans un canal BSC.
    % Arguments :
    % c - vecteur colonne binaire [N x 1] (mot reçu)
    % H - matrice de parité binaire [M x N]
    % p - vecteur colonne [N x 1] des probabilités a priori que c(i) = 1
    % MAX_ITER - nombre maximal d'itérations

    [M, N] = size(H); % M : nombre de c_nodes; N : nombre de v_nodes

    % Initialisation des messages comme matrice de vecteur à deux valeurs q_ij = ( qij(0), qij(1) )
    q_ij = zeros(N, M, 2); % Messages v_node -> c_node
    r_ji = zeros(M, N, 2); % Messages c_node -> v_node
    Q_i = zeros(N, 2);

    % Initialisation des messages avec les probabilités v_node -> c_node
    for i = 1:N
        % Probabilités initiales des messages q_ij
        q_ij(i, H(:, i) == 1, 1) = 1 - p(i); % qij(0)
        q_ij(i, H(:, i) == 1, 2) = p(i);     % qij(1)
        % H(:, i) == 1 renvoie un vecteur logique qui vaut "true" pour chaque c_node qui est connecté au v_node i
    end

    c_chapeau = c; % Initialisation du mot corrigé

    % Boucle itérative du décodage
    for iteration = 1:MAX_ITER
        % Étape 2 : Mise à jour des messages r_ji des c_node -> v_node
        for j = 1:M
            Vj = find(H(j, :) == 1); % Ensemble des v_nodes c_i connectés à f_j
            for i = Vj
                % Calcul des messages r_ji(b) pour chaque i dans Vj
                temp_prod = 1;
                for l = setdiff(Vj, i)
                    temp_prod = temp_prod * (1 - 2 * q_ij(l, j, 2));
                end
                r_ji(j, i, 1) = 0.5 + 0.5 * temp_prod;   % rji(0)
                r_ji(j, i, 2) = 1 - r_ji(j, i, 1) ;   % rji(1)
            end
        end
     
        % Étape 3 : Mise à jour des messages q_ij des v_node -> c_node
        for i = 1:N
            Ci = find(H(:, i) == 1)'; % Ensemble des nœuds de parité connectés à c_i
            for j = Ci
                temp_prod_0 = 1;
                temp_prod_1 = 1;
                for l = setdiff(Ci, j)
                    temp_prod_0 = temp_prod_0 * r_ji(l, i, 1);
                    temp_prod_1 = temp_prod_1 * r_ji(l, i, 2);
                end
                Kij = 1 / ((1 - p(i)) * temp_prod_0 + p(i) * temp_prod_1); % Constante de normalisation
                q_ij(i, j, 1) = Kij * (1 - p(i)) * temp_prod_0;       % qij(0)
                q_ij(i, j, 2) = Kij * p(i) * temp_prod_1;             % qij(1)

                Q_i(1) = r_ji(j, i, 1)*q_ij(i, j, 1)/Kij;             % Qi(0)
                Q_i(2) = r_ji(j, i, 2)*q_ij(i, j, 2)/Kij;             % Qi(1)
            end
            % Décision pour c_i dans l'itération
            if Q_i(2) > Q_i(1)
                c_chapeau(i) = 1;
            else
                c_chapeau(i) = 0;
            end
        end
        % Vérification des contraintes de parité
        if all(mod(H * c_chapeau, 2) == 0)
            % Si toutes les contraintes sont respectées, fin du décodage
            break;
        end
    end