# Sistema Especialista para Diagnóstico de Falhas Automotivas



Este repositório contém o projeto prático desenvolvido para a disciplina de Laboratório de Programação. O objetivo do trabalho é resolver o mesmo problema computacional — um sistema especialista de diagnóstico mecânico — utilizando três linguagens de programação sob três paradigmas distintos, analisando os pontos fortes, limitações e a elegância de cada abordagem.


# Base de Conhecimento (Regras de Negócio)



O sistema foi modelado com base em 10 cenários reais de falhas mecânicas e eletrónicas estruturadas na seguinte matriz de dados:



| Sintomas (Input) | Diagnóstico (Output 1) | Peça a Verificar (Output 2) |

| :--- | :--- | :--- |

| `motor\_não\_liga` + `luz\_bateria\_acesa` | `bateria\_descarregada` | Bateria |

| `motor\_não\_liga` + `partida\_fraca` | `motor\_de\_arranque\_defeituoso` | Motor de arranque |

| `luz\_bateria\_acesa` + `carro\_desliga\_em\_movimento` | `alternador\_com\_defeito` | Alternador |

| `superaquecimento` + `vazamento\_de\_líquido` | `falha\_no\_radiador` | Radiador |

| `superaquecimento` + `nível\_baixo\_de\_líquido` | `falha\_na\_bomba\_dágua` | Bomba d'água |

| `ruído\_metálico` + `perda\_de\_potência` | `desgaste\_do\_motor` | Motor |

| `luz\_injeção\_acesa` + `consumo\_alto` | `falha\_na\_injeção` | Sistema de injeção |

| `dificuldade\_na\_partida` + `consumo\_alto` | `velas\_desgastadas` | Velas |

| `fumaça\_preta` + `consumo\_alto` | `mistura\_rica` | Sistema de injeção |

| `vibração\_excessiva` + `perda\_de\_potência` | `problema\_na\_transmissão` | Transmissão |



---



# Estrutura do Repositório



```text

├── python/

│   └── main.py             # Implementação em Orientação a Objetos

├── prolog/

│   └── diagnostico.pl      # Base de conhecimento e regras em Prolog

├── lisp/

│   └── diagnostico.lisp    # Funções puras e processamento de listas em Lisp

├── relatorio\_tecnico.pdf   # Relatório detalhado comparando os paradigmas

└── README.md               # Instruções e documentação do projeto

