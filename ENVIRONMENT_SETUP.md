# Environment & Token Management

## Local Development

This repo keeps the MotherDuck token out of Git. The simplest workflow is to store it in a local `.envrc` file and source it whenever you run Terraform or other scripts.

### Recommended Setup

1. Make sure the actual token is saved in the repo-local `.envrc` file.
2. Source it before using Terraform:
   ```bash
   cd /Users/triciaengel/Documents/GitHub/f1-telemetry-platform
   source .envrc
   ```
3. Then run Terraform commands with the env var available:
   ```bash
   cd terraform
   TF_VAR_motherduck_token="$MOTHERDUCK_TOKEN" terraform plan
   TF_VAR_motherduck_token="$MOTHERDUCK_TOKEN" terraform apply -auto-approve
   ```

This keeps the token out of the Git repo while still being easy to use in a local shell session.

### If you want the token in your shell every time

You can also export it once in your current shell session:
```bash
export MOTHERDUCK_TOKEN="your_motherduck_token_here"
```

Then run:
```bash
cd /Users/triciaengel/Documents/GitHub/f1-telemetry-platform/terraform
TF_VAR_motherduck_token="$MOTHERDUCK_TOKEN" terraform plan
```

### `direnv` option

If you want auto-loading in future sessions, you can use `direnv` later, but for now the manual `source .envrc` approach is the simplest and most reliable option.

## CI/CD (GitHub Actions)

Store your token as a GitHub secret:

1. Go to repo settings → **Secrets and variables** → **Actions**
2. Create a new repository secret named `MOTHERDUCK_TOKEN`
3. Paste your MotherDuck API token
4. Reference it in workflows:
   ```yaml
   env:
     TF_VAR_motherduck_token: ${{ secrets.MOTHERDUCK_TOKEN }}
   ```

## Files

- `.envrc` — Local environment variables (gitignored, contains your real token)
- `.envrc.example` — Template for other developers

**Never commit `.envrc` to git.**
