<p align="center">
  🦷 <h1>Encanto Odontologia & Estética</h1>
  <i>Sistema de Banco de Dados Relacional – SQL Server</i>
</p>

---

## 📖 Descrição Geral

O projeto **Encanto Odontologia & Estética** foi desenvolvido com o objetivo de estruturar um **banco de dados completo e robusto** voltado para o gerenciamento de uma clínica odontológica e estética.  
A modelagem contempla desde o cadastro de pacientes, profissionais e procedimentos, até o registro de consultas, atendimentos, consumo de materiais e pagamentos.

Esse projeto demonstra **domínio técnico em SQL Server**, aplicando conceitos de **modelagem relacional, integridade referencial, automação de massa de dados** e uso de **procedures** para simulação de operações reais.

---

## 🧩 Estrutura do Banco de Dados

O banco foi projetado com **12 tabelas normalizadas**, distribuídas entre entidades base, associativas e operacionais — garantindo clareza, integridade e fácil manutenção.

### 🏠 **Entidades Base**
Representam os principais elementos do negócio:  
`ENDERECO`, `PACIENTE`, `PROFISSIONAL`, `ESPECIALIDADE`, `PROCEDIMENTO`, `PRODUTO_ESTOQUE`

### 🔗 **Tabelas Associativas**
Controlam relacionamentos **N:N** entre especialidades, profissionais e produtos:  
`PROFISSIONAL_ESPECIALIDADE`, `CONSUMO_PADRAO`

### 💬 **Tabelas Operacionais**
Responsáveis pelo ciclo completo de uma consulta até o pagamento:  
`CONSULTA`, `ATENDIMENTO_PROCEDIMENTO`, `USO_MATERIAL`, `PAGAMENTO_PACIENTE`

📘 **Resumo:**  
> Cada entidade foi modelada com **chaves primárias e estrangeiras bem definidas**, seguindo padrões de **normalização até 3FN**.  
> O design favorece **performance, consistência e escalabilidade**, sendo ideal para ambientes de QA e testes automatizados.

---

## ⚙️ Recursos Implementados

### ✅ **Massa de Dados Automatizada**
Scripts inteligentes de inserção automática e parametrizada, simulando comportamentos reais da clínica.

**Recursos aplicados:**
- Geração dinâmica de dados via `CTEs`, `CROSS APPLY` e `NEWID()`
- Distribuição realista de procedimentos e consumo proporcional de insumos
- Relacionamentos automáticos e consistentes entre entidades
- **Updates** e **Deletes** controlados, com validações de integridade

---

## 🧮 Procedures Principais

### 🩺 **SP_REGISTRAR_ATENDIMENTO**
- Registra automaticamente atendimentos  
- Calcula valores, comissões e consumo de materiais  
- Atualiza custo total e estoque  

### 💰 **SP_REGISTRAR_PAGAMENTO**
- Registra pagamentos e forma de recebimento  
- Atualiza status de consultas e controle financeiro  

---

## 🧠 Consultas e Views

Criação de **6 views** para análise de indicadores operacionais e financeiros:
- Histórico de pacientes  
- Produtividade por especialidade  
- Custos e comissões  
- Estoque crítico  
- Fluxo de pagamentos  
- Receita por produto  

---

## 🧱 Principais Conceitos Aplicados

- Normalização até **3ª Forma Normal (3FN)**  
- Chaves primárias simples e compostas  
- Controle de **FKs** com `ON DELETE` / `UPDATE`  
- Automação via `CTE` e `CROSS APPLY`  
- Procedures simulando rotinas reais de negócio  
- Scripts **parametrizados e reexecutáveis**  
- Massa de dados **escalável** para QA e testes automatizados  

---

## 💡 Destaques Técnicos

✅ Projeto 100% desenvolvido em **Microsoft SQL Server**  
✅ Foco em **qualidade de dados e performance**  
✅ Ideal para testes de **consultas complexas (JOINs, subqueries, agregações)**  
✅ Scripts documentados e de fácil manutenção  
✅ Aplicação prática de **pensamento analítico de QA** em banco de dados  

---

## 🖼️ Prints do Projeto

Inclua aqui prints ilustrativos para demonstrar visualmente o funcionamento e resultados do projeto.  
**Sugestão de organização dos prints 👇**

### 📌 **Estrutura do Banco**

Diagrama ER (DER) completo com relacionamentos:  
<img width="1206" height="613" alt="image" src="https://github.com/user-attachments/assets/53439fbd-1480-4d49-82ce-c9e632dc5853" />

<br>

**Estrutura das 12 Tabelas**  
<img width="295" height="363" alt="image" src="https://github.com/user-attachments/assets/995b60e7-afab-42b0-a255-9f74f30f8dc9" />

**Estrutura das 6 Views**  
<img width="308" height="219" alt="image" src="https://github.com/user-attachments/assets/96582993-f5a6-4431-9410-7a89cf8abb2f" />

**Estrutura das 2 Procedures**  
<img width="331" height="258" alt="image" src="https://github.com/user-attachments/assets/04cdfe16-5f92-41e5-8453-0708d877b846" />

---

### 📊 **Consultas e Views**

`HISTORICO_FINANCEIRO_PACIENTE`  
<img width="1165" height="648" alt="image" src="https://github.com/user-attachments/assets/a400237c-bf5d-4d19-a4c1-bd04640f70d4" />

`PRODUTIVIDADE_ESPECIALIDADE`  
<img width="797" height="260" alt="image" src="https://github.com/user-attachments/assets/21f19674-1629-41be-80a5-d5d549333a16" />

`RELATORIO_COMISSAO_CUSTO`  
<img width="688" height="285" alt="image" src="https://github.com/user-attachments/assets/e028adc2-d164-4b01-901e-afba64c6d864" />

`RELATORIO_ESTOQUE_CRITICO`  
<img width="884" height="697" alt="image" src="https://github.com/user-attachments/assets/01521667-b5da-49fa-b47d-e746e0e2aeca" />

`RELATORIO_FLUXO_PAGAMENTO`  
<img width="456" height="182" alt="image" src="https://github.com/user-attachments/assets/6d3a8c7b-b24a-459d-a488-534d38a697e6" />

`RELATORIO_RECEITA_PRODUTO`  
<img width="964" height="320" alt="image" src="https://github.com/user-attachments/assets/05bd55c1-4e8e-4e02-b0d4-a437b45a7962" />

---

### ⚙️ **Procedures em Execução**
<img width="867" height="786" alt="image" src="https://github.com/user-attachments/assets/e6fa3203-cb35-4f30-bc9c-9754a3f5abbb" />

---

### 💾 **Exemplos de Massa de Dados Automatizada**
**ENDERECO:**  
<img width="1011" height="557" alt="image" src="https://github.com/user-attachments/assets/2d50f16f-977a-46a8-a8ff-0d5c8b1fe71b" />

**CONSULTA:**  
<img width="1003" height="514" alt="image" src="https://github.com/user-attachments/assets/639e566f-70f0-4bde-be2e-3586048e3c46" />

**PACIENTE:**  
<img width="1158" height="574" alt="image" src="https://github.com/user-attachments/assets/f15ca576-aa39-4dc8-a273-0fa781e6619f" />

**PROFISSIONAL:**  
<img width="1479" height="592" alt="image" src="https://github.com/user-attachments/assets/6bda359e-2427-4dbd-9c68-a2ff7b85caf1" />

**PRODUTO_ESTOQUE:**  
<img width="676" height="516" alt="image" src="https://github.com/user-attachments/assets/ec3da1f5-7e05-4859-884c-3233c189e26d" />

---

<p align="center">
  👩‍💻 <b>Autora:</b><br>
  <b>Hanna Teles</b><br>
  <i>Analista de Qualidade de Software Sênior | Especialista em SQL Server & Automação de Testes de Dados</i><br>
  📍 Projeto acadêmico com foco em excelência técnica e visão analítica de QA
</p>
