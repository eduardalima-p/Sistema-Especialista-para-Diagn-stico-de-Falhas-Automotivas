;;;; =====================================================================
;;;; Sistema Especialista para Diagnóstico de Falhas Automotivas
;;;; Paradigma: Funcional (Common Lisp)
;;;; Equipe: Diele Ilana Coelho Cantanhede, Maria Eduarda Pereira Lima, Matheus Macário Sousa e Rian Emmanoel Santos Bastos
;;;; =====================================================================

;; CASOS POSSÍVEIS (BASE DE REGRA)

(defparameter *base-regras*
  '(((motor_nao_liga luz_bateria_acesa) bateria_descarregada "Bateria")
    ((motor_nao_liga partida_fraca) motor_de_arranque_defeituoso "Motor de arranque")
    ((luz_bateria_acesa carro_desliga_em_movimento) alternador_com_defeito "Alternador")
    ((superaquecimento vazamento_de_liquido) falha_no_radiador "Radiador")
    ((superaquecimento nivel_baixo_de_liquido) falha_na_bomba_dagua "Bomba d'agua")
    ((ruido_metalico perda_de_potencia) desgaste_do_motor "Motor")
    ((luz_injecao_acesa consumo_alto) falha_na_injecao "Sistema de injecao")
    ((dificuldade_na_partida consumo_alto) velas_desgastadas "Velas")
    ((fumaca_preta consumo_alto) mistura_rica "Sistema de injecao")
    ((vibracao_excessiva perda_de_potencia) problema_na_transmissao "Transmissao")))


(defun subconjunto-p (requeridos informados)
;; verifica se todos os sintomas exigidos pela regra estão presentes na lista de sintomas informados pelo mecânico.
  (cond
    ((null requeridos) t) 
    ;; condição de parada, se a base de regras estiver vazia, exibe a mensagem de erro.
    ((member (car requeridos) informados) 
     (subconjunto-p (cdr requeridos) informados)) 
    ;; Extrai o 1º requisito (car) e checa se foi informado (member). 
    ;; Se sim, faz recursão com o resto da lista (cdr)
    (t nil))) 
    ;; Se o cond chegar aqui o sintoma não estava na lista, ele entra na condição t e retorna nil (Falso).

;; Função principal de filtragem (Recursão Estrutural)
;; Percorre a base de regras eliminando hipóteses que não batem com os sintomas.
(defun filtrar-diagnosticos (sintomas regras)
  (cond
    ((null regras) nil) 
    ;; Cria a função. A condição de parada é: se a lista de regras acabar (null), retorna nil (uma lista vazia).
    ((subconjunto-p (caar regras) sintomas) 
    ;; caar: atalho para extrair o 1º elemento da 1ª regra (os sintomas). Verifica se os sintomas informados satisfazem a hipótese atual.
     (cons (cdar regras) 
     ;; cdar extrai apenas o diagnóstico/peça da regra. O cons anexa esse dado à recursão do restante da lista, mantendo a imutabilidade (sem usar append). 
           (filtrar-diagnosticos sintomas (cdr regras)))) 
           
    (t (filtrar-diagnosticos sintomas (cdr regras)))))
    ;; Se a regra não for satisfeita, apenas ignora a atual e avança a 
    ;; recursão para avaliar o resto das regras (cdr).

;; 3. FUNÇÃO DE INTERFACE
;; Função que o usuário (mecânico) chama para obter o diagnóstico final.
(defun diagnosticar (sintomas)
  (let ((resultados (filtrar-diagnosticos sintomas *base-regras*)))
    (if (null resultados)
        '(("Falha desconhecida ou sintomas insuficientes." "Nenhuma peca especifica"))
        resultados)))


;; =====================================================================
;; ALGUNS EXEMPLOS DE EXECUÇÃO
;; =====================================================================

;; Teste 1: Falha na bateria
(print (diagnosticar '(motor_nao_liga luz_bateria_acesa)))
;; Saída esperada: ((BATERIA_DESCARREGADA "Bateria"))

;; Teste 2: Sintomas misturados (O sistema deve filtrar e achar as interseções)
(print (diagnosticar '(consumo_alto luz_injecao_acesa winver ruido_metalico)))
;; Saída esperada: ((FALHA_NA_INJECAO "Sistema de injecao"))

;; Teste 3: Sintoma isolado que não aciona nenhuma regra completa
(print (diagnosticar '(perda_de_potencia)))
;; Saída esperada: (("Falha desconhecida ou sintomas insuficientes." "Nenhuma peca especifica"))