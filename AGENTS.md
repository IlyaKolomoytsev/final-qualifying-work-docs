# Project Agents

This document describes specialized agents configured for the FQW (Final Qualification Work) thesis project.

Each agent is responsible for specific aspects of the project and is configured in `.claude/agents/`.

## Terminology Guardian

**File**: `.claude/agents/terminology-guardian.yaml`

**Purpose**: Maintains controlled terminology consistency across all thesis documentation.

**Canonical reference**: `./docs/terminology.md` — the single source of truth for all project terminology.

### When to use

Invoke the Terminology Guardian when:
- Adding new technical terms to the thesis
- Reviewing documentation for terminology consistency
- Changing or clarifying term definitions
- Detecting duplicate, vague, or conflicting terminology
- Need to verify semantic precision of definitions

### Key concepts

**One concept = One preferred term**: The same idea must be referred to by the same canonical Russian term throughout the thesis.

**Aliases are rare**: Alternative names are only allowed when they are actually used in source documents, standards, or common technical practice — not as "additional synonyms."

**Precise, neutral definitions**: Definitions must be suitable for an academic thesis. Avoid marketing language, circular definitions, and overly broad terms.

**Semantic distinctions matter**: The agent carefully distinguishes between similar concepts:
- цель / задача / требование / ограничение (goal / task / requirement / constraint)
- система / приложение / модуль / компонент / сервис (system / app / module / component / service)
- пользователь / оператор / клиент / администратор (user / operator / client / administrator)
- метод / подход / алгоритм / технология / инструмент (method / approach / algorithm / technology / tool)
- данные / сведения / параметры / признаки / атрибуты (data / information / parameters / attributes / features)

### How the agent works

1. **Reviews existing terminology** in `./docs/terminology.md`
2. **Searches project documentation** for overlapping terms and usage patterns
3. **Decides** whether a new term is genuinely new or duplicates an existing concept
4. **Suggests replacements** using existing canonical terms when duplicates are found
5. **Adds new terms** only when justified, with precise definitions and context
6. **Removes obsolete terms** that are no longer used anywhere in the project
7. **Commits changes** with clear, atomic Git commits using the format:
   ```
   agent(terminology-guardian): <what changed and why>
   ```

### Example interactions

**Adding a new term**:
```
You: "I need to add the term 'параметр приёмника' to the technical assignment"
Agent: Checks docs/terminology.md → searches project → proposes definition →
       adds term with examples → commits with proper message
```

**Finding duplicate terminology**:
```
You: "Should I use 'передача данных' or 'трансмиссия' here?"
Agent: Checks both terms → finds only one is canonical → recommends replacement →
       explains semantic reason → (optionally) updates docs/terminology.md
```

**Reviewing terminology consistency**:
```
You: "Can you review Chapter 3 for terminology consistency?"
Agent: Scans chapter → identifies inconsistent terms → suggests replacements →
       reports obsolete terms → recommends updates to docs/terminology.md
```

### Terminology file structure

The controlled terminology database (`./docs/terminology.md`) follows this structure:

```markdown
# Терминология проекта

## Правила ведения терминологии
[Rules about canonical terms, synonyms, semantic distinctions...]

## Активные термины

### <Canonical Russian Term>

- **Статус:** active
- **Краткое определение:** [One sentence, precise definition]
- **Расширенное пояснение:** [Optional, 1-3 sentences for context]
- **Допустимые варианты:** [Aliases actually used, or "нет"]
- **Недопустимые варианты:** [Forbidden variants or "нет"]
- **Связанные термины:** [Related canonical terms or "нет"]
- **Контекст использования:** [Where the term should be used]
- **Пример корректного употребления:** [Short phrase or sentence]
- **Дата добавления:** YYYY-MM-DD
- **Последняя проверка:** YYYY-MM-DD
```

Terms are sorted **alphabetically by canonical term name** within the "Активные термины" section.

### Git discipline

All terminology changes are committed atomically with descriptive messages:

**Good commit messages**:
- `agent(terminology-guardian): add term "компонент системы" for architecture chapter consistency`
- `agent(terminology-guardian): replace duplicate term "программный блок" with "модуль"`
- `agent(terminology-guardian): remove unused term "подсистема импорта" after documentation cleanup`
- `agent(terminology-guardian): clarify "требование" to distinguish it from implementation task`

**Bad commit messages** (do not use):
- `update terminology`
- `fix docs`
- `changes`
- `terminology edits`

### What the agent does NOT do

- Does not make unrelated code changes
- Does not rewrite large sections unless explicitly asked
- Does not introduce new terms without checking existing terminology
- Does not modify files other than `./docs/terminology.md` unless explicitly requested
- Does not keep obsolete unused terms in the active terminology base

---

## How agents are configured

Agents in this project are defined in the `.claude/agents/` directory as YAML files.

Each agent has:
- **name** — unique identifier
- **description** — brief purpose
- **role** — what the agent is responsible for
- **scope** — what the agent can and cannot do
- **procedures** — step-by-step decision rules
- **discipline rules** — how changes are made and committed

The Terminology Guardian is the primary specialized agent for this FQW thesis project.
