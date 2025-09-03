function Test()

    clear all;
    close all;

    % Carregar o conjunto de dados de teste
    dados_teste = readtable('Test.csv', 'Delimiter',';', 'DecimalSeparator', '.');

    % Dividir o conjunto de dados de teste em entrada (X) e alvo (y)
    input_teste = dados_teste{:, 2:end-1}; % Todas as colunas exceto a primeira e a última são atributos de entrada
    output_teste = dados_teste{:, end}; % Última coluna é o atributo alvo (Stroke)

    % Carregar a melhor rede treinada salva anteriormente
    load('99.8361.mat', 'net');

    % Utilizar a rede para fazer previsões no conjunto de dados de teste
    out_teste = sim(net, input_teste');
    out_teste = mapminmax(out_teste,0,1);

    out_teste = (out_teste >=0.5);

    % Calcular a precisão total
    total_correct_teste = sum(output_teste' == out_teste);
    
    total_accuracy_teste = total_correct_teste / length(output_teste) * 100;
    
    for i=1:size(out_teste,2)
        [~, d] = max(out_teste(:,i));
        %disp(d-1')
    end
    % Exibir métricas de acurácia
    fprintf('Precisão total no conjunto de dados de teste: %.2f%%\n', total_accuracy_teste);

    % Plotar a matriz de confusão do conjunto de dados de teste
    plotconfusion(output_teste', out_teste); % Matriz de confusão

end