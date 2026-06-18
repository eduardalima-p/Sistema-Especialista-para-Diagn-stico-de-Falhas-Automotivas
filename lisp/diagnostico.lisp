;;;; =====================================================================
;;;; Sistema Especialista para Diagnóstico de Falhas Automotivas
;;;; Paradigma: Funcional (Common Lisp)
;;;; Equipe: Diele Ilana Coelho Cantanhede, Maria Eduarda Pereira Lima, Matheus Macário Sousa e Rian Emmanoel Santos Bastos
;;;; =====================================================================

;; 1. BASE DE CONHECIMENTO (IMUTÁVEL)
;; Representada como uma Association List (Alist). 
;; Cada elemento tem o formato: ((sintomas...) diagnostico peca)
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


;; 2. FUNÇÕES PURAS E RECURSIVAS

;; Função auxiliar pura: verifica se todos os sintomas exigidos pela regra 
;; estão presentes na lista de sintomas informados pelo mecânico.
(defun subconjunto-p (requeridos informados)
  (cond
    ;; Caso base 1: se não há mais requisitos a checar, é verdadeiro
    ((null requeridos) t) 
    ;; Passo recursivo: se o 1º requisito está na lista informada, testa o resto
    ((member (car requeridos) informados) 
     (subconjunto-p (cdr requeridos) informados)) 
    ;; Caso base 2: se faltou algum sintoma, retorna falso
    (t nil))) 

;; Função principal de filtragem (Recursão Estrutural)
;; Percorre a base de regras eliminando hipóteses que não batem com os sintomas.
(defun filtrar-diagnosticos (sintomas regras)
  (cond
    ;; Caso base: fim da base de conhecimento (retorna lista vazia)
    ((null regras) nil) 
    
    ;; Se os sintomas desta regra forem um subconjunto dos sintomas informados...
    ((subconjunto-p (caar regras) sintomas) 
     ;; ...transforma o dado mantendo apenas o diagnóstico e a peça, e continua a busca
     (cons (cdar regras) 
           (filtrar-diagnosticos sintomas (cdr regras)))) 
           
    ;; Se não bater, apenas ignora a regra atual e continua filtrando o resto
    (t (filtrar-diagnosticos sintomas (cdr regras)))))


;; 3. FUNÇÃO DE INTERFACE
;; Função que o usuário (mecânico) chama para obter o diagnóstico final.
(defun diagnosticar (sintomas)
  (let ((resultados (filtrar-diagnosticos sintomas *base-regras*)))
    (if (null resultados)
        '(("Falha desconhecida ou sintomas insuficientes." "Nenhuma peca especifica"))
        resultados)))


;; =====================================================================
;; EXEMPLOS DE EXECUÇÃO (Para testar no terminal)
;; =====================================================================

;; Teste 1: Falha na bateria
;; (print (diagnosticar '(motor_nao_liga luz_bateria_acesa)))
;; Saída esperada: ((BATERIA_DESCARREGADA "Bateria"))

;; Teste 2: Sintomas misturados (O sistema deve filtrar e achar as interseções)
;; (print (diagnosticar '(consumo_alto luz_injecao_acesa winver ruido_metalico)))
;; Saída esperada: ((FALHA_NA_INJECAO "Sistema de injecao"))

;; Teste 3: Sintoma isolado que não aciona nenhuma regra completa
;; (print (diagnosticar '(perda_de_potencia)))
;; Saída esperada: (("Falha desconhecida ou sintomas insuficientes." "Nenhuma peca especifica"))