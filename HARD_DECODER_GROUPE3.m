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
            % Ensemble des c_nodes connectés au v_node i
            Ci = find(H(:, i) == 1);
            
            % Calcul de la somme des messages reçus des c_nodes connectés
            sum_msg = sum(r_ji(Ci, i));

            % Inclure la valeur reçue initialement dans le vote de majorité
            majority_vote = sum_msg + c_hard(i); % Ajout de c_hard(i) pour un vote de majorité incluant le bit reçu

            % Décision hard: si la majorité est de 1, alors c_hard(i) = 1; sinon c_hard(i) = 0
            if majority_vote >= (numel(Ci) + 1) / 2
                c_hard(i) = 1;
            else
                c_hard(i) = 0;
            end
        end

        
        % Vérification des contraintes de parité (fin du décodage si validées)
        if all(mod(H * c_hard, 2) == 0)
            % Si toutes les contraintes sont respectées, fin du décodage
            break;
        end
    end
end
