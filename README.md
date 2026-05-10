# Secure Message App

Secure Message App is a security-focused web application for encrypted messaging with attachments.  
The project demonstrates practical implementation of end-to-end encryption, digital signatures, two-factor authentication, and secure delivery through HTTPS behind a reverse proxy.

## Architecture and Tech Stack

The system is containerized and built as a three-service architecture:

1. `frontend` (React + TypeScript + Vite + Ant Design)
   - User interface for registration, login, and messaging.
   - Client-side key generation and cryptographic operations.
   - Uses `@noble/curves` and Web Crypto API.

2. `backend` (FastAPI + SQLAlchemy + SQLite)
   - REST API for users, authentication, and message storage.
   - Password hashing with Argon2id (`passlib[argon2]`).
   - Input validation with Pydantic and rate limiting with `slowapi`.

3. `proxy` (NGINX)
   - TLS termination and HTTP to HTTPS redirect.
   - Reverse proxy routing (`/` to frontend, `/api/` to backend).
   - Security headers and request body size limits.

Communication flow:
- Clients connect only to NGINX over HTTPS.
- Frontend and backend are exposed internally in Docker network.
- API traffic is routed via `/api/` through the proxy.

## Security-Focused Design

This project is centered around security engineering decisions:

- **End-to-end encryption (E2EE)**: message payloads are encrypted in the browser with AES-GCM before being sent to the API.
- **Per-recipient key wrapping**: a random AES session key is encrypted separately for each recipient using X25519 ECDH + HKDF.
- **Integrity and authenticity**: encrypted message bundles are signed with Ed25519 and verified on receipt.
- **Protected private keys**: private key material is encrypted client-side with AES-GCM; encryption keys are derived from user password via PBKDF2 (high iteration count).
- **Strong authentication**: login passwords are hashed with Argon2id on the backend.
- **Two-factor authentication**: TOTP-based 2FA is required; TOTP secrets are stored encrypted server-side.
- **Secure session handling**: session cookies are HTTP-only and delivered over HTTPS.
- **Transport security**: NGINX enforces TLS 1.2/1.3, HTTPS redirect, and security headers (including HSTS and CSP).
- **Abuse resistance**: backend rate limiting and NGINX request size limits reduce brute-force and oversized-payload risks.

## How to Run

### Setup script

Use the setup script. It generates required `.env` files.  
You can also configure everything manually (see below).

```bash
./setup.py [reset]
```

or

```bash
python3 setup.py [reset]
```

### Manual configuration

#### 1) SSL certificates

```bash
mkdir -p nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
  -keyout nginx/certs/selfsigned.key \
  -out nginx/certs/selfsigned.crt
```

#### 2) Environment variables (`.env`)

Create `.env` in project root (`./message-app/.env`):

```env
DOMAIN_NAME=localhost
VITE_API_URL=https://localhost/api
SESSION_SECRET_KEY=backend_key
TOTP_SECRET_KEY=totp_key
DATABASE_URL=sqlite:///./data/app.db
```

### Run application

```bash
docker compose up --build [-d]
```

Application URL: `https://localhost`

### Development mode (hot reload)

```bash
docker compose -f dev-docker-compose.yml up --build [-d]
```

