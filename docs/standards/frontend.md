# Frontend standards

Fill in the `<...>` placeholders for your project, then delete this line.

## Stack

- Framework: `<React / Next.js / Vue / ...>`. Language: `<TypeScript>`. Styling: `<Tailwind / CSS modules>`.

## Structure

- One component per file. File name matches the component name (`UserCard.tsx`).
- Group by feature (`features/billing/`), not by type. Shared code goes in `shared/`.
- Components render UI. Data fetching and business logic live in hooks or services.

## Rules

- Type everything. No `any` without a comment that explains why.
- Keep components under about 150 lines; split when they grow past that.
- Handle loading, empty, and error states for every data-driven view.
- Use semantic HTML and label every form control. Every interactive element must work with a keyboard.
- Do not store server data in global client state; use `<React Query / SWR / ...>`.
- No inline styles or magic numbers; use design tokens.

## Commands

- Dev: `<npm run dev>`. Test: `<npm test>`. Lint: `<npm run lint>`. Build: `<npm run build>`.
