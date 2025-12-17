# Copilot instructions for SREN

Purpose: give actionable, repo-specific guidance so an AI coding agent is immediately productive.

Big picture

- This is a split repo: an Angular frontend (root `src/`) and a TypeScript Express backend (`backend/`).
- Backend uses Prisma + MySQL (see `backend/prisma/schema.prisma`) and a small local JSON storage fallback
  (`backend/src/services/storage.service.ts`).

Where to look (quick links)

- Backend entry: backend/src/index.ts
- Backend routes: backend/src/routes/
- Backend services: backend/src/services/
- Prisma schema: backend/prisma/schema.prisma
- Frontend entry: src/main.ts
- Frontend app root: src/app/

Key patterns & conventions

- ESM + TypeScript: `type: "module"` is used. Compiled/imported files in backend use `.js` extensions in import paths
  (e.g. `import { registerRoutes } from './routes/index.js'`). Keep imports with explicit extensions when editing
  TypeScript source so the compiled ESM output works.
- Backend dev: uses `tsx watch src/index.ts` (`npm run dev` inside `backend/`) — quick iterative workflow without full
  compile.
- Build vs run: backend build uses `tsc` -> produces `dist/`; `npm start` runs `node dist/index.js`.
- Database: Prisma + `DATABASE_URL` env var. Use `npm run prisma:generate` and `npm run prisma:migrate` from `backend/`
  when schema changes.
- Local data sync: `ensureDataFileExists()` and `syncWithDatabase()` are used to sync local JSON storage with DB on
  startup — check `backend/src/services/storage.service.ts` before changing startup logic.

Common commands

- Frontend (root): `npm start` (runs `ng serve`), `npm run build`, `npm test`.
- Backend (cd backend): `npm run dev` (dev server), `npm run build`, `npm start`, `npm run test` (jest).
- Prisma (backend): `npm run prisma:generate`, `npm run prisma:migrate`, `npm run prisma:studio`.
- Format / lint: root `npm run format`, root `npm run lint`; backend has its own `npm run lint`.

Testing & CI hints

- Frontend tests run with Angular/Karma (`ng test`). Backend tests use Jest (`backend` `npm run test`).
- Husky + lint-staged are present; follow existing ESLint/Prettier configs.

Integration points & deployments

- Docker files and compose exist in `backend/` for containerized deployment; Portainer is referenced in docs.
- Supabase scripts exist in root `package.json` but are optional unless the project uses Supabase services.

When editing code

- Follow existing folder boundaries (routes/controllers/services in `backend/src/`); add new routes via
  `backend/src/routes/index.ts` registration.
- Preserve ESM import style and explicit `.js` extension to avoid runtime import errors after compile.
- If changing DB models, update `backend/prisma/schema.prisma` and run Prisma migrate + generate.

Examples

- To run backend fast during development:
  - cd backend
  - npm install
  - npm run dev
- To add a new API route: add file under `backend/src/routes/`, export a router, and register it in
  `backend/src/routes/index.ts`.

If anything here is unclear or you want more details (CI, Docker deployment, or frontend conventions), tell me which
area to expand.
