# Infrastructure standards

Fill in the `<...>` placeholders for your project, then delete this line.

## Stack

- Cloud: `<AWS / GCP / Azure>`. IaC: `<Terraform>`. Containers: Docker. CI: `<GitHub Actions>`.

## Docker

- Use a pinned base image tag, never `latest`. Prefer slim or distroless images.
- Use multi-stage builds so build tools stay out of the final image.
- Run as a non-root user. Add a `.dockerignore`.
- One process per container. Configuration comes from environment variables.

## Terraform

- Pin provider and module versions. Keep remote state with locking.
- One module per concern. Variables have types and descriptions; outputs are documented.
- Run `terraform fmt`, `validate`, and `plan` before proposing a change. Never run `apply` without explicit approval.
- Tag every resource with `project` and `environment`.

## CI/CD

- Every pull request runs lint, tests, and a build. Merges to `main` require all to pass.
- Secrets live in the CI secret store, never in the repo or in logs.
- Deploys are automated, repeatable, and reversible.

## Safety

- Treat anything that changes shared or production resources as needing human approval first.
