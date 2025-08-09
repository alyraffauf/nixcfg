# Forĝejo

NixOS module for [Forĝejo](https://forgejo.org/) self-hosted Git forge.

Used to host [git.aly.codes](https://git.aly.codes).

## Usage

```nix
{
  myNixOS.services.forgejo = {
    enable = true;
    db = "sqlite"; # or "postgresql"
  };
}
```

## Storage

Data stored in **Backblaze B2** (`aly-forgejo` bucket).

## Required Secrets

- `forgejo-b2Id` / `forgejo-b2Key`: Backblaze B2 credentials
- `forgejo-mailer-passwd`: SMTP password (Resend)
- `postgres-forgejo`: Database password (PostgreSQL only)
