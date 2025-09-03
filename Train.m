function Train()
    clear all;
    close all;

    % Carregar os dados
    dados = readtable('Train_atualizado.csv', 'Delimiter', ',', 'DecimalSeparator', '.');

    % Dividir o conjunto de dados em entrada (X) e target (y)
    X = dados{:, 2:end-1}'; % Todas as colunas exceto a primeira e a última são atributos de entrada
    y = dados{:, end}'; % Última coluna é o atributo alvo (Stroke)

    preGlobal = 0;
    preErro = 0;
    MediaTeste = 0;

    % Simulação e avaliação da rede neural
    for i = 1:10
        net = feedforwardnet([10 30 15]); % Criar rede neuronal feedforward com 10 neurônios em cada camada oculta

        % Indicar a função de treino
        net.trainFcn = 'trainlm'; % Usando o algoritmo Levenberg-Marquardt

        % Indicar as funções de ativação das camadas escondidas e de saída
        net.layers{1}.transferFcn = 'tansig'; % Função tangente sigmoidal para camada oculta
        net.layers{2}.transferFcn = 'tansig'; % Função tangente sigmoidal para camada oculta
        net.layers{3}.transferFcn = 'tansig'; % Função tangente sigmoidal para camada oculta
        net.layers{4}.transferFcn = 'purelin'; % Função linear para camada de saída

        net.divideFcn = 'dividerand';
        net.divideParam.trainRatio = 0.8;
        net.divideParam.valRatio = 0.15;
        net.divideParam.testRatio = 0.05;

        [net, tr] = train(net, X, y);

        target = y(:, tr.testInd);
        
        % Simular a rede apenas no conjunto de teste
        out2 = sim(net, X(:, tr.testInd));
        out2 = mapminmax(out2, 0, 1);
        out2 = (out2 >= 0.5);

        % Calcular a precisão de teste
        correctCount = sum(out2 == target);
        accuracy = correctCount / numel(target) * 100;
        MediaTeste = MediaTeste + accuracy;
        %fprintf('Precisão teste: %.2f%%\n', accuracy);
        % Simular a rede apenas no conjunto de teste
        out = sim(net, X);
        out = mapminmax(out, 0, 1);
        out = (out >= 0.5);

        % Calcular o erro
        erro = perform(net, y, out); 
        preErro = preErro + (erro * 100);

        % Calcula e mostra a precisão global no conjunto de teste
        globalCorrectCount = sum(out == y);
        globalAccuracy = globalCorrectCount / numel(y) * 100;
        %fprintf('Precisão global: %.2f%%\n', globalAccuracy);
        preGlobal = preGlobal + globalAccuracy;
        
        % files = dir('*.mat');
        % 
        %     % Iterate through each file
        %     if length(files) < 3
        %         save(append(num2str(globalAccuracy),'.mat'),'net');
        %     else
        %         for j = 1:length(files)
        %             filename = files(j).name;
        % 
        %             % Remove the .mat extension
        %             file_accuracy = strrep(filename, '.mat', '');
        % 
        %             if(globalAccuracy > str2double(file_accuracy))
        %                 delete(filename)
        %                 save(append(num2str(globalAccuracy),'.mat'),'net'); 
        %                 break;
        %             end
        % 
        %         end
        %     end

    end

    % Calcular médias
    preGlobal = preGlobal / 10;
    preErro = preErro / 10;
    MediaTeste = MediaTeste / 10;

    % Exibir resultados
    fprintf('=====================\n');
    fprintf('Precisão Global: %.2f%%\n', preGlobal);
    fprintf('Erro médio: %.2f%%\n', preErro);
    fprintf('Precisão do Teste média: %.2f%%\n', MediaTeste);
end