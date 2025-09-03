function cbr()

    similarity_threshold = 0.8;

    case_library = readtable('Train.csv','Delimiter', ',', 'DecimalSeparator','.');

    na_indices = isnan(case_library.stroke);
    case_library.stroke(na_indices) = -1;

    
    % Valores Category = -1 (NA)
    na_stroke_cases = case_library(case_library.stroke == -1, :);

    % Outros valores Category
    case_library_no_na = case_library(case_library.stroke ~= -1, :);

    
    % Percorrer os casos com "NA" na coluna "stroke" e imputar os valores de "stroke" mais próximos
    for i = 1:size(na_stroke_cases, 1)

        currentRow = na_stroke_cases(i, :);
        
        % Copiar os valores de cada campo do caso atual com "NA" para o novo caso
        new_case.age = currentRow.age;
        new_case.gender = currentRow.gender;
        new_case.hypertension = currentRow.hypertension;
        new_case.heart_disease = currentRow.heart_disease;
        new_case.ever_married = currentRow.ever_married;
        new_case.Residence_type = currentRow.Residence_type;
        new_case.avg_glucose_level = currentRow.avg_glucose_level;
        new_case.bmi = currentRow.bmi;
        new_case.smoking_status = currentRow.smoking_status;

        % 
        [retrieved_indexes, similarities, new_case] = retrieve(case_library_no_na, new_case, similarity_threshold);
    
        % 
        retrieved_cases = case_library_no_na(retrieved_indexes, :);

        % 
        retrieved_cases.Similarity = similarities';

        % 
        %disp(retrieved_cases);
        % Find the index of the highest similarity
        [max_similarity, max_index] = max(retrieved_cases.Similarity);


        % Trocar NA pelo valor categoria do resultado mais próximo
        for j = 1:size(case_library, 1)
            
            % Verificar se o ID atual coincide com o ID do caso com NA
            if case_library.id(j) == currentRow.id
                    % Atribuir o valor de 'stroke' do caso mais similar
                    case_library.stroke(j) = retrieved_cases.stroke(max_index);
            end
        end
        
    end
    writetable(case_library,'Train_atualizado.csv','Delimiter',',');
end
