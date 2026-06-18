# =====================================================================
# Sistema Especialista para Diagnóstico de Falhas Automotivas
# Paradigma: Orientação a Objetos (Python)
# Equipe: Diele Ilana Coelho Cantanhede, Maria Eduarda Pereira Lima, Matheus Macário Sousa e Rian Emmanoel Santos Bastos.
# =====================================================================

# MODELAGEM DE COMPONENTES E HERANÇA
class Componente:
    """Classe base abstrata que representa uma peça do veículo."""
    
    def __init__(self, nome, diagnostico, sintomas_esperados):
        self.nome = nome
        self.diagnostico = diagnostico
        # Usamos 'set' (conjunto) para facilitar a comparação matemática dos sintomas
        self.sintomas_esperados = set(sintomas_esperados)
        self.tipo_sistema = "Geral"

    def verificar_falha(self, sintomas_observados):
        """
        Encapsulamento: O próprio componente sabe dizer se está falhando.
        Retorna True se todos os seus sintomas esperados estiverem nos observados.
        """
        return self.sintomas_esperados.issubset(set(sintomas_observados))

# Herança: Especializando os tipos de componentes do carro
class ComponenteEletrico(Componente):
    def __init__(self, nome, diagnostico, sintomas_esperados):
        super().__init__(nome, diagnostico, sintomas_esperados)
        self.tipo_sistema = "Elétrico"

class ComponenteMecanico(Componente):
    def __init__(self, nome, diagnostico, sintomas_esperados):
        super().__init__(nome, diagnostico, sintomas_esperados)
        self.tipo_sistema = "Mecânico"

class ComponenteEletronico(Componente):
    def __init__(self, nome, diagnostico, sintomas_esperados):
        super().__init__(nome, diagnostico, sintomas_esperados)
        self.tipo_sistema = "Eletrônico"


# MODELAGEM DA FALHA
class Falha:
    """Representa o resultado de um diagnóstico encontrado."""
    
    def __init__(self, componente, diagnostico):
        self.componente = componente
        self.diagnostico = diagnostico

    def __str__(self):
        return f"[{self.componente.tipo_sistema}] Peça: {self.componente.nome} | Diagnóstico: {self.diagnostico}"


# MODELAGEM DO VEÍCULO (O Motor de Inferência OO)
class Carro:
    """Representa o veículo, armazena seus componentes e gerencia os diagnósticos."""
    
    def __init__(self):
        # Utilizando um Dicionário para gerenciar os componentes por uma chave-ID,
        # garantindo acesso rápido e mapeamento direto das peças.
        self.componentes = {}

    def registrar_componente(self, id_regra, componente):
        """Adiciona um componente ao mapeamento interno do carro."""
        self.componentes[id_regra] = componente

    def diagnosticar(self, sintomas_observados):
        falhas_encontradas = []
        
        # O carro itera sobre seus próprios componentes, delegando a verificação
        for _, comp in self.componentes.items():
            if comp.verificar_falha(sintomas_observados):
                falhas_encontradas.append(Falha(comp, comp.diagnostico))
                
        return falhas_encontradas


# =====================================================================
# INICIALIZAÇÃO DA BASE DE CONHECIMENTO E TESTES
# =====================================================================
if __name__ == "__main__":
    
    # Instanciamos o objeto principal
    meu_carro = Carro()
    
    # Registramos as "regras" instanciando os componentes corretos e populando o dicionário
    meu_carro.registrar_componente("regra1", ComponenteEletrico("Bateria", "bateria_descarregada", ["motor_nao_liga", "luz_bateria_acesa"]))
    meu_carro.registrar_componente("regra2", ComponenteEletrico("Motor de arranque", "motor_de_arranque_defeituoso", ["motor_nao_liga", "partida_fraca"]))
    meu_carro.registrar_componente("regra3", ComponenteEletrico("Alternador", "alternador_com_defeito", ["luz_bateria_acesa", "carro_desliga_em_movimento"]))
    meu_carro.registrar_componente("regra4", ComponenteMecanico("Radiador", "falha_no_radiador", ["superaquecimento", "vazamento_de_liquido"]))
    meu_carro.registrar_componente("regra5", ComponenteMecanico("Bomba d'água", "falha_na_bomba_dagua", ["superaquecimento", "nivel_baixo_de_liquido"]))
    meu_carro.registrar_componente("regra6", ComponenteMecanico("Motor", "desgaste_do_motor", ["ruido_metalico", "perda_de_potencia"]))
    meu_carro.registrar_componente("regra7", ComponenteEletronico("Sistema de injeção", "falha_na_injecao", ["luz_injecao_acesa", "consumo_alto"]))
    meu_carro.registrar_componente("regra8", ComponenteEletrico("Velas", "velas_desgastadas", ["dificuldade_na_partida", "consumo_alto"]))
    meu_carro.registrar_componente("regra9", ComponenteEletronico("Sistema de injeção", "mistura_rica", ["fumaca_preta", "consumo_alto"]))
    meu_carro.registrar_componente("regra10", ComponenteMecanico("Transmissão", "problema_na_transmissao", ["vibracao_excessiva", "perda_de_potencia"]))

    # Função auxiliar para rodar os testes e exibir bonitinho
    def imprimir_resultado(teste_num, sintomas):
        print(f"--- Teste {teste_num} ---")
        print(f"Sintomas: {sintomas}")
        resultados = meu_carro.diagnosticar(sintomas)
        
        if not resultados:
            print("Resultado: Falha desconhecida ou sintomas insuficientes.\n")
        else:
            for falha in resultados:
                print(f"Resultado: {falha}")
            print()

    # Executando os mesmos testes usados no Lisp e Prolog para garantir equivalência
    imprimir_resultado(1, ["motor_nao_liga", "luz_bateria_acesa"])
    imprimir_resultado(2, ["consumo_alto", "luz_injecao_acesa", "fumaca_preta"])
    imprimir_resultado(3, ["pneu_furado"])