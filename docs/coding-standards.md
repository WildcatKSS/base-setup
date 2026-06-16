# Coding Standards

## Product-Neutral Rule

Do not add product-specific code before product selection and MVP Gate approval.

## TypeScript

- strict mode
- avoid `any`
- validate external input
- separate business logic from UI

## Security

- no secrets in repository
- least privilege
- authorization checks near data access
- rate limit sensitive endpoints

## Testing

- unit tests for business logic
- integration tests for API/database
- E2E tests for critical flows

## Maintainability

- small modules
- explicit boundaries
- readable names
- minimal dependency surface
