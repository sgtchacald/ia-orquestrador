---
name: dsc-contexto-cursos
description: Use when answering questions about Spring MVC, Thymeleaf, Spring Security, DataTables, AJAX, or any pattern already implemented in the dscproject-spring-mvc project - loads reference examples from course demo projects before responding
---

# DSC Contexto Cursos

## Overview

Antes de responder perguntas sobre padrões Spring MVC/Thymeleaf no projeto do usuário, busca exemplos reais nos projetos de curso em `/mnt/04D660D763C8D42B/DEV_HOME/DSC_HOME/contexto-i.a/`.

## Projetos Disponíveis

| Projeto | Foco | Quando usar |
|---------|------|-------------|
| `curso-spring-mvc` | CRUD completo, DAO customizado, conversores, validadores, fragmentos Thymeleaf | Estrutura de controllers, formulários, listagem, paginação |
| `spring-mvc-ajax` | DataTables, AJAX, DTOs, notificações | Tabelas dinâmicas, requisições assíncronas, modais |
| `spring-mvc-security` | Spring Security, perfis/roles, email, agendamento, DataTables integrado | Autenticação, autorização, recuperação de senha |

## Fluxo de Busca

```
Pergunta do usuário
       ↓
O tópico tem exemplo em algum dos cursos?
       ↓ sim                    ↓ não
Leia os arquivos relevantes    Responda normalmente
       ↓
Mostre o exemplo do curso
       ↓
Adapte/compare com o projeto atual
```

## Mapeamento Tópico → Arquivo

**Controllers CRUD**
```
curso-spring-mvc/src/main/java/.../web/controller/FuncionarioController.java
curso-spring-mvc/src/main/java/.../web/controller/CargoController.java
```

**Spring Security Config**
```
spring-mvc-security/src/main/java/.../config/SecurityConfig.java
spring-mvc-security/src/main/java/.../web/controller/UsuarioController.java
spring-mvc-security/src/main/java/.../service/UsuarioService.java
```

**DataTables + AJAX**
```
spring-mvc-ajax/src/main/java/.../web/controller/PromocaoController.java
spring-mvc-ajax/src/main/java/.../service/PromocaoDataTablesService.java
spring-mvc-security/src/main/java/.../datatables/Datatables.java
```

**Thymeleaf Templates (layout, fragmentos)**
```
curso-spring-mvc/src/main/resources/templates/layout.html
curso-spring-mvc/src/main/resources/templates/fragments/
spring-mvc-security/src/main/resources/templates/layout.html
```

**Conversores (StringTo...)**
```
curso-spring-mvc/src/main/java/.../web/conversor/
spring-mvc-security/src/main/java/.../web/conversor/
```

**Validadores customizados**
```
curso-spring-mvc/src/main/java/.../web/validator/FuncionarioValidator.java
spring-mvc-security/src/main/java/.../web/controller/PacienteValidator.java
```

**Repositórios / DAO**
```
curso-spring-mvc/src/main/java/.../dao/AbstractDao.java
curso-spring-mvc/src/main/java/.../dao/FuncionarioDaoImpl.java
```

**Email / Notificação**
```
spring-mvc-security/src/main/java/.../service/EmailService.java
spring-mvc-ajax/src/main/java/.../service/NotificacaoService.java
```

## Como Usar

1. Identifique o tópico da pergunta
2. Localize o(s) arquivo(s) correspondentes na tabela acima
3. Leia o arquivo com `Read`
4. Apresente o exemplo do curso e compare/adapte para o contexto atual do projeto

## Quando NÃO Usar

- Perguntas sobre Angular, Spring Boot REST puro (sem MVC/Thymeleaf)
- Erros de compilação/runtime sem relação com padrões dos cursos
- Perguntas gerais de Java não relacionadas ao stack Spring MVC
