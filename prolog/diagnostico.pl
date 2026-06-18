% =====================================================================
% Sistema Especialista para Diagnóstico de Falhas Automotivas
% Paradigma: Lógico (SWI-Prolog)
% Equipe: Diele Ilana Coelho Cantanhede, Maria Eduarda Pereira Lima, Matheus Macário Sousa e Rian Emmanoel Santos Bastos
% =====================================================================

% REGRAS DE INFERÊNCIA (O Motor Lógico)
% Conforme a especificação, as regras seguem a estrutura clássica:
% SE sintoma_A presente E sintoma_B presente, ENTÃO diagnóstico é X.
%
% O predicado member/2 age como nossa unificação e condição Lógica AND.
% Ele verifica se os sintomas necessários existem na lista informada.

diagnostico(Sintomas, bateria_descarregada, 'Bateria') :-
    member(motor_nao_liga, Sintomas),
    member(luz_bateria_acesa, Sintomas).

diagnostico(Sintomas, motor_de_arranque_defeituoso, 'Motor de arranque') :-
    member(motor_nao_liga, Sintomas),
    member(partida_fraca, Sintomas).

diagnostico(Sintomas, alternador_com_defeito, 'Alternador') :-
    member(luz_bateria_acesa, Sintomas),
    member(carro_desliga_em_movimento, Sintomas).

diagnostico(Sintomas, falha_no_radiador, 'Radiador') :-
    member(superaquecimento, Sintomas),
    member(vazamento_de_liquido, Sintomas).

% Usamos duas aspas simples ('') para escapar o apóstrofo dentro da string
diagnostico(Sintomas, falha_na_bomba_dagua, 'Bomba d''agua') :- 
    member(superaquecimento, Sintomas),
    member(nivel_baixo_de_liquido, Sintomas).

diagnostico(Sintomas, desgaste_do_motor, 'Motor') :-
    member(ruido_metalico, Sintomas),
    member(perda_de_potencia, Sintomas).

diagnostico(Sintomas, falha_na_injecao, 'Sistema de injecao') :-
    member(luz_injecao_acesa, Sintomas),
    member(consumo_alto, Sintomas).

diagnostico(Sintomas, velas_desgastadas, 'Velas') :-
    member(dificuldade_na_partida, Sintomas),
    member(consumo_alto, Sintomas).

diagnostico(Sintomas, mistura_rica, 'Sistema de injecao') :-
    member(fumaca_preta, Sintomas),
    member(consumo_alto, Sintomas).

diagnostico(Sintomas, problema_na_transmissao, 'Transmissao') :-
    member(vibracao_excessiva, Sintomas),
    member(perda_de_potencia, Sintomas).


% INTERFACE DE CONSULTA (Agrupamento de Resultados)
% O predicado findall/3 coleta todas as regras que unificaram (bateram) 
% com os sintomas informados e devolve uma lista de respostas.

consultar_falhas(Sintomas, ResultadosFinais) :-
    findall(
        [Diag, Peca], 
        diagnostico(Sintomas, Diag, Peca), 
        ResultadosEncontrados
    ),
    % Condicional (-> ;) para tratar o caso de nenhum sintoma bater
    (   ResultadosEncontrados == []
    ->  ResultadosFinais = [['Falha desconhecida ou sintomas insuficientes', 'Nenhuma peca especifica']]
    ;   ResultadosFinais = ResultadosEncontrados
    ).

% =====================================================================
% EXECUÇÃO DOS TESTES (Para o OneCompiler)
% =====================================================================
:- initialization(main).

main :-
    % Teste 1: Falha na bateria
    consultar_falhas([motor_nao_liga, luz_bateria_acesa], Resposta1),
    write('Teste 1: '), write(Resposta1), nl,

    % Teste 2: Sintomas misturados (O sistema deve achar duas intersecoes)
    consultar_falhas([consumo_alto, luz_injecao_acesa, fumaca_preta], Resposta2),
    write('Teste 2: '), write(Resposta2), nl,

    % Teste 3: Sintoma isolado que nao aciona nenhuma regra completa
    consultar_falhas([pneu_furado], Resposta3),
    write('Teste 3: '), write(Resposta3), nl,
    
    halt. % Encerra o programa
   