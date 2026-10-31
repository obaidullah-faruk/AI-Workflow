# Backend standards

Fill in the `<...>` placeholders for your project, then delete this line. Database rules are in [database.md](database.md).

## Stack

- Language/framework: `<Node + Express / Python + FastAPI / Java + Spring Boot / ...>`. Database: `<PostgreSQL>`.

## Architecture: loosely coupled, deployable as one or many

Start as a **modular monolith**: one deployable app, split into modules by business capability (`users`, `billing`, `orders`). Move a module into its own microservice only for a concrete reason: it must scale independently, a separate team owns it, or it needs failure isolation or a different tech stack. Record that decision in `docs/decisions/`. Do not split "just in case".

The rules below keep that move cheap, because a module that follows them can be extracted without rewriting its callers.

**Modules**

- Each module has a small public interface (service functions or an interface type). Other modules call only that.
- A module never imports another module's repository, database models, or internals.
- A module owns its tables. No other module reads or writes them, and no SQL joins across modules. Ask the owning module through its interface, and fetch in batches (`getUsersByIds(ids)`).
- Modules exchange plain data objects (DTOs), never ORM entities.

**Layers inside a module**

1. **Handler/controller**: parses the request, validates input, returns the response. No business logic.
2. **Service**: business rules. Depends on interfaces only.
3. **Repository/adapter**: the only place that knows about the database, HTTP clients, email, payment, or queue SDKs.

Dependencies point inward. Business logic never imports the web framework, the ORM, or a third-party SDK. Define the interface (for example `PaymentGateway`, `UserRepository`, `JobQueue`) next to the service that needs it, implement it in an adapter, inject it through the constructor, and wire everything in one place at startup.

**Talking between modules**

- Need an answer now: call the other module's interface.
- Side effect that others may react to (an order was placed): publish an event such as `OrderPlaced` through an `EventBus` interface. Use an in-process bus now. A message broker can replace it later without changing the modules.
- Events carry ids and the data consumers need, and are versioned.

## Background jobs

Do the work in a background worker, not in the request, when it:

- takes more than about a second or has unpredictable duration (reports, image or file processing, bulk imports);
- calls a slow or unreliable third party (email, SMS, payments, webhooks);
- needs retries, or must run on a schedule;
- fans out into many pieces.

Rules:

- Put the queue behind a `JobQueue` interface. A job handler only parses its payload and calls a service, so the same logic can also run in a request.
- Jobs must be **idempotent**: running one twice has the same result as running it once.
- Job payloads carry ids, not whole objects. The handler loads fresh data.
- Retry with exponential backoff and a maximum attempt count. Failed jobs go to a dead-letter queue and raise an alert.
- Enqueue after the database transaction commits. If the job must never be lost, use the outbox pattern (write the job to a table in the same transaction, and a relay publishes it).
- For user-triggered long work, return `202 Accepted` with a status URL.
- The worker is the same codebase with its own entry point, so it scales separately from the web process.

## API rules

- Validate every request body and query parameter with a schema before use.
- Return one consistent error shape: `{ "error": { "code": "...", "message": "..." } }`. Use correct HTTP status codes.
- Never return stack traces or internal details to clients.
- Every endpoint that changes data checks authorization, not just authentication.
- Paginate every list endpoint. Never return unbounded results.
- Keep endpoints idempotent where retries are likely (payments, webhooks).
- Log with structured fields (request id, user id). Never log secrets or personal data.

## Commands

- Dev: `<...>`. Test: `<...>`. Lint: `<...>`. Migrate: `<...>`. Worker: `<...>`.
