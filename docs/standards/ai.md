# AI standards

Rules for code that calls an LLM or embedding API: chat, RAG, agents, extraction, classification. Fill in the `<...>` placeholders for your project, then delete this line.

## Stack

- Provider and SDK: `<Anthropic / OpenAI / ...>`. Models: `<large model for hard tasks, small model for simple ones>`. Embeddings: `<...>`. Vector store: `<pgvector / ...>`. Evals: `<promptfoo / pytest / ...>`.

## Structure

- All model calls go through one adapter behind an interface (`LlmClient`, `EmbeddingClient`). Services never import the vendor SDK.
- Model ids, `max_tokens`, and temperature live in config, not in code.
- Prompts live in their own files or constants, one per task, with a version. Never assemble a prompt from strings scattered across the code.
- Keep instructions in the system prompt. Put user input, retrieved documents, and tool results in clearly delimited blocks (for example XML tags), never mixed into the instructions.

## Output

- When code consumes the output, use structured output or tool calling with a schema, and validate the response against it.
- Handle every stop reason: a response cut off at `max_tokens` is incomplete, not an answer. Treat a refusal or invalid output as an error path: retry once, then fail clearly.
- Model output is untrusted. Never execute it, put it in SQL, or render it as HTML without validation and escaping.

## Cost and latency

- Use the smallest model that passes the evals. Move a task to a larger model only when evals show it needs one.
- Set `max_tokens` on every call, sized to the expected answer.
- Order every prompt stable-first: system prompt, tool definitions, and fixed documents first, the changing part last, so provider prompt caching applies. Enable caching where the provider supports it.
- Send only what the task needs: trim or summarize chat history, and pass retrieved chunks, not whole documents.
- Stream responses that a user waits for. Run offline or bulk work as background jobs, using the provider's batch API when it has one.
- Log per call: model, input and output tokens, cache hits, latency, and request id. Never log secrets, and redact personal data from logged prompts.
- Retry rate-limit and server errors with exponential backoff and a cap, and set a timeout on every call.

## RAG

- Chunk along the document's structure (headings, paragraphs) with a small overlap. Store the source id and metadata with every chunk for citations and filtering.
- One embedding model per index. Changing the model means building a new index version, not mixing vectors.
- Filter by tenant and user permissions in the retrieval query. Never rely on the prompt to hide data.
- Retrieve a small top-k. Add keyword (hybrid) search or a reranker only when evals show retrieval misses.
- Answer only from the retrieved context, cite the sources, and say when the answer is not there.

## Agents and tools

- Each tool does one thing, has a typed schema, and has a description that says when to use it. Validate tool arguments like any other input.
- Tools run with the user's permissions, not admin. A tool that changes data or spends money needs authorization, and confirmation when the action cannot be undone.
- Cap every agent loop: maximum steps, maximum tokens, and a timeout. Stop with a clear result when a cap is hit.
- Prefer a fixed workflow (call the model, then the next step in code) over an open agent loop when the steps are known.

## Evals

- Unit tests use a fake `LlmClient` and never call the real API.
- Every prompt or model change runs an eval set: a versioned file of realistic inputs, including edge cases and injection attempts, with the expected property of each answer.
- Assert properties, not exact text: the schema is valid, a source is cited, a forbidden action is refused, a fact is present.
- Report the pass rate, and the average tokens and cost per call, before and after the change.

## Commands

- Evals: `<npm run eval>`.
