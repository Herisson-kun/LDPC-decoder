function c_hard = HARD_DECODER_GROUPE3(c, H, MAX_ITER)
    % Décodage LDPC hard-decision avec un algorithme itératif dans un canal BSC
    % Arguments :
    % c - vecteur binaire [N x 1] (mot reçu avec erreur)
    % H - matrice de parité binaire [M x N]
    % MAX_ITER - nombre maximal d'itérations
    
    [M, N] = size(H); % M : nombre de c_nodes; N : nombre de v_nodes

    r_ji = zeros(M, N); % Messages de c_node -> v_node
    
    % Initialisation des messages v-node -> c-node
    c_hard = c; % Mot corrigé initialisé avec le mot reçu
    
    % Boucle itérative du décodage
    for iteration = 1:MAX_ITER
        % Étape 2 : Mise à jour des messages des c_nodes -> v_nodes
        
        for j = 1:M
            Vj = find(H(j, :) == 1); % Ensemble des v_nodes connectés à c_node f_j
            for i = Vj
                % Calcul des messages r_ji(b) pour chaque v_node connecté à f_j
                temp_sum = 0;
                for l = setdiff(Vj, i)  % Exclure i de l'ensemble des v_nodes connectés
                    temp_sum = mod(temp_sum + c_hard(l), 2);
                end
                r_ji(j, i) = temp_sum;  % Message de c_node vers v_node
            end
        end
        
        % Étape 3 : Mise à jour des messages v_nodes -> c_nodes (décision hard)
        for i = 1:N
            Ci = find(H(:, i) == 1); % Ensemble des c_nodes connectés à v_node c_i
            
            sum = 0;
            % Additionner les messages reçus des c_nodes pour chaque v_node
            for j = Ci
                sum = sum + r_ji(j, i);
            end
            sum = sum/length(Ci);
            
            % Prise de décision hard-decision basée sur le signe total
            if sum > 0.5
                c_hard(i) = 1;  % Si la moyenne est superieur à 0.5, c_i = 1
            else
                c_hard(i) = 0;  % sinon, c_i = 0
            end
        end
        
        % Vérification des contraintes de parité (fin du décodage si validées)
        if all(mod(H * c_hard, 2) == 0)
            % Si toutes les contraintes sont respectées, fin du décodage
            break;
        end
    end
end
