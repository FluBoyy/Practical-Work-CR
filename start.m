% function start()
% 
% clear all;
%     close all;
% 
%     % Carregar os dados
%     dados = readtable('Start.csv', 'Delimiter',';', 'DecimalSeparator', '.');
% 
%     % Dividir o conjunto de dados em entrada (X) e target (y)
%     X = dados{:, 2:end-1}; % Todas as colunas exceto a primeira e a última são atributos de entrada
%     y = dados{:, end}; % Última coluna é o atributo alvo (Stroke)
% 
%     % Normalizar os dados
%     %X = normalize(X);
% 
%     % Definir a arquitetura da rede neural
%     net = feedforwardnet(10); % Criar rede neuronal feedforward com 10 neurônios na camada oculta
% 
%     % Indicar a função de treino
%     net.trainFcn = 'trainlm'; % Usando o algoritmo Levenberg-Marquardt
% 
%     % Indicar as funções de ativação das camadas escondidas e de saída
%     net.layers{1}.transferFcn = 'tansig'; % Função tangente sigmoidal para camada oculta
%     net.layers{2}.transferFcn = 'purelin'; % Função log-sigmoid para camada de saída
% 
%     net.divideParam
% 
%     % Treinar a rede neural
%     tic; % Iniciar contagem de tempo
%     net = train(net, X', y');
%     tempo_execucao = toc; % Tempo de execução
% 
%     % Simular a rede apenas no conjunto de teste
%     out = sim(net, X');
%     out = mapminmax(out,0,1);
%     out = (out >=0.5);
% 
%     % Calcular a precisão total
%     total_correct = sum(y' == round(out));
%     total_accuracy = total_correct / length(y) * 100;
%     fprintf('Precisão total: %.2f%%\n', total_accuracy);
%     erro = perform(net,out,y');
%     fprintf('Precisão do erro: %.2f%%\n', erro*100);
% 
%     % Mostrar o tempo de execução
%     fprintf('Tempo de execução: %.2f segundos\n', tempo_execucao);
% 
%     % Plotar a matriz de confusão
%     plotconfusion(y', out); % Matriz de confusão
% end

function start()

    clear all;
    close all;

    % Carregar os dados
    dados = readtable('Start.csv', 'Delimiter',';', 'DecimalSeparator', '.');

    % Dividir o conjunto de dados em entrada (X) e target (output)
    input = dados{:, 2:end-1}; % Todas as colunas exceto a primeira e a última são atributos de entrada
    output = dados{:, end}; % Última coluna é o atributo alvo (Stroke)

    % Normalizar os dados
    input = normalize(input);

    % Definir a arquitetura da rede neural
    net = feedforwardnet(10); % Criar rede neuronal feedforward com 10 neurônios na camada oculta

    % Indicar a função de treino
    net.trainFcn = 'trainlm'; % Usando o algoritmo Levenberg-Marquardt

    % Indicar as funções de ativação das camadas escondidas e de saída
    net.layers{1}.transferFcn = 'poslin'; % Função tangente sigmoidal para camada oculta
    net.layers{2}.transferFcn = 'logsig'; % Função para camada de saída
    
    %%dividir os exemplos
    net.divideFcn='dividerand';
    net.divideParam.trainRatio = 1.0;
    net.divideParam.valRatio = 0.0;
    net.divideParam.testRatio = 0.0;
    % Treinar a rede neural
    tic; % Iniciar contagem de tempo
    net = train(net, input', output');
    tempo_execucao = toc; % Tempo de execução

    % Simular a rede apenas no conjunto de teste
    out = sim(net, input');
    out = mapminmax(out,0,1);
    out = (out >=0.5);

    % Calcular a precisão total
    total_correct = sum(output' == round(out));
    total_accuracy = total_correct / length(output) * 100;
    fprintf('Precisão total: %.2f%%\n', total_accuracy);
    erro = perform(net,out,output');
    fprintf('Precisão do erro: %.2f%%\n', erro*100);

    % Mostrar o tempo de execução
    fprintf('Tempo de execução: %.2f segundos\n', tempo_execucao);

    % Plotar a matriz de confusão
    plotconfusion(output', out); % Matriz de confusão

end
