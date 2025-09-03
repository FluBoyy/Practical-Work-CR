function [retrieved_indexes, similarities, new_case] = retrieve(case_library, new_case, threshold)
    
    weighting_factors = [2 5 2 3 3 3 5 2 3];

    retrieved_indexes = [];
    similarities = [];
    
    max_values = get_max_values(case_library);

    to_remove=[];
    if ~isfield(new_case, 'gender')
        to_remove = [to_remove 1];
    end

    if ~isfield(new_case, 'age')
        to_remove = [to_remove 2];
    end

    if ~isfield(new_case, 'hypertension')
        to_remove = [to_remove 3];
    end

    if ~isfield(new_case, 'heart_disease')
        to_remove = [to_remove 4];
    end

    if ~isfield(new_case, 'ever_married')
        to_remove = [to_remove 5];
    end

    if ~isfield(new_case, 'Residence_type')
        to_remove = [to_remove 6];
    end

    if ~isfield(new_case, 'avg_glucose_level')
        to_remove = [to_remove 7];
    end

    if ~isfield(new_case, 'bmi')
        to_remove = [to_remove 8];
    end

    if ~isfield(new_case, 'smoking_status')
        to_remove = [to_remove 9];
    end
    
    weighting_factors(to_remove)=[];

    for i=1:size(case_library,1)
        
        distances = zeros(1,9);

        if isfield(new_case, 'gender')
            distances(1,1) = calculate_linear_distance(case_library{i,'gender'}, new_case.gender);
        end

        if isfield(new_case, 'age')
            distances(1,2) = calculate_linear_distance(case_library{i,'age'} / max_values('age'), ... 
                new_case.age / max_values('age'));
        end
        
        if isfield(new_case, 'hypertension')
            distances(1,3) = calculate_linear_distance(case_library{i,'hypertension'}, new_case.hypertension);
        end
                            
        if isfield(new_case, 'heart_disease')
            distances(1,4) = calculate_linear_distance(case_library{i,'heart_disease'}, new_case.heart_disease);
        end
        
        if isfield(new_case, 'ever_married')
            distances(1,5) = calculate_linear_distance(case_library{i,'ever_married'}, new_case.ever_married);
        end
        
        if isfield(new_case, 'Residence_type')
            distances(1,6) = calculate_linear_distance(case_library{i,'Residence_type'}, new_case.Residence_type);
        end
                            
        if isfield(new_case, 'avg_glucose_level')
            distances(1,7) = calculate_euclidean_distance(case_library{i,'avg_glucose_level'}/max_values('avg_glucose_level'),...
                new_case.avg_glucose_level/max_values('avg_glucose_level'));
        end
        
        if isfield(new_case, 'bmi')
            distances(1,8) = calculate_euclidean_distance(case_library{i,'bmi'}/max_values('bmi'),...
                new_case.bmi/max_values('bmi'));
        end

        if isfield(new_case, 'smoking_status')
            distances(1,9) = calculate_linear_distance(case_library{i,'smoking_status'}, new_case.smoking_status);
        end
                            
        distances(to_remove)=[];
        
        DG = (distances*weighting_factors')/sum(weighting_factors);
        final_similarity = 1 - DG;
        
        if final_similarity >= threshold
            retrieved_indexes = [retrieved_indexes i];
            similarities = [similarities final_similarity];
        end
        
        fprintf('Case %d out of %d has a similarity of %.2f%%...\n', i, size(case_library,1), final_similarity*100);
    end
end


function [res] = calculate_linear_distance(val1, val2)

    res=abs(val1-val2);
end

function [res] = calculate_euclidean_distance(val1, val2)

    res=sqrt((val1-val2)^2);
end

function [max_values] = get_max_values(case_library)
    key_set = {'age', 'avg_glucose_level', 'bmi'};
    value_set = {max(case_library.age), max(case_library.avg_glucose_level), max(case_library.bmi)};
    max_values = containers.Map(key_set, value_set);
    
end