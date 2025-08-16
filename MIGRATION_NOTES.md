# Migration Notes

## Structure
```
apps/
  <brand>/           # thin Next.js app
packages/
  core-web/          # shared UI and pages
  core-cms/          # shared CMS client
  brand-<name>/      # brand configs
```

To add a third brand:
1. Create `packages/brand-<new>/config.ts` following existing shape.
2. Add `apps/<new>/` with thin `app/layout.tsx` and `app/page.tsx` importing from core packages.
3. Point `apps/<new>/tsconfig.json` path `brand/config` to the new config file.

## Environment variables
Each Firebase App Hosting app must define:
- `NEXT_PUBLIC_CMS_BASE_URL`
- `CMS_API_TOKEN`

## Running locally
```
pnpm dev:kekkonbu
pnpm dev:sakeflow
```

## Deploying
CI workflow `.github/workflows/app-hosting.yml` deploys both brands.
To deploy locally:
```
cd apps/kekkonbu && pnpm build && npx firebase deploy --only hosting
cd apps/sakeflow && pnpm build && npx firebase deploy --only hosting
```

## Updating shared packages
Changes inside `packages/core-*` affect all brands. Avoid runtime brand checks; use config and path aliases instead.
