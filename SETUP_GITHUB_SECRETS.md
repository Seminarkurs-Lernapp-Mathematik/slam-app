# GitHub Secrets Setup Guide

This guide explains how to set up the required secrets for GitHub Actions deployment.

---

## Required Secrets

You need to add these secrets to your GitHub repository:

### 1. CLOUDFLARE_API_TOKEN

**Purpose:** Allows GitHub Actions to deploy to Cloudflare Pages and Workers

**How to get:**
1. Go to https://dash.cloudflare.com/profile/api-tokens
2. Click "Create Token"
3. Use template: "Edit Cloudflare Workers"
4. Or create custom token with these permissions:
   - Account > Cloudflare Pages > Edit
   - Account > Account Settings > Read
   - Zone > Workers Routes > Edit
5. Copy the generated token

**How to add to GitHub:**
1. Go to your repository on GitHub
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `CLOUDFLARE_API_TOKEN`
5. Value: (paste your token)
6. Click "Add secret"

---

### 2. CLOUDFLARE_ACCOUNT_ID

**Purpose:** Identifies your Cloudflare account for deployments

**How to get:**
1. Go to https://dash.cloudflare.com/
2. Select any website (or go to Workers & Pages)
3. Look at the URL: `https://dash.cloudflare.com/{ACCOUNT_ID}/...`
4. Or find it in: Workers & Pages → Account ID (in sidebar)

**How to add to GitHub:**
1. Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `CLOUDFLARE_ACCOUNT_ID`
4. Value: (paste your account ID)
5. Click "Add secret"

---

## Verification

After adding secrets, they should appear in:
- Settings → Secrets and variables → Actions → Repository secrets

You should see:
- ✅ CLOUDFLARE_API_TOKEN
- ✅ CLOUDFLARE_ACCOUNT_ID
- ✅ GITHUB_TOKEN (automatically provided by GitHub)

---

## Testing the Workflow

1. **Trigger deployment:**
   ```bash
   git add .
   git commit -m "Test deployment"
   git push origin main
   ```

2. **Monitor deployment:**
   - Go to: Actions tab on GitHub
   - Watch the "Deploy Flutter Web to Cloudflare Pages" workflow
   - Check for any errors

3. **Verify deployment:**
   ```bash
   curl https://learn-smart.app
   ```

---

## Troubleshooting

### "Error: API token invalid"
- Re-generate the API token with correct permissions
- Update the secret in GitHub

### "Error: Account ID not found"
- Double-check your account ID from Cloudflare dashboard
- Make sure there are no extra spaces

### "Error: Zone not found"
- Ensure `learn-smart.app` is added to your Cloudflare account
- Check DNS is properly configured

---

## Security Notes

- ⚠️ **Never commit secrets to git**
- 🔒 Secrets are encrypted in GitHub
- 🔐 Only workflows in the same repository can access them
- ♻️ Rotate tokens regularly (every 90 days recommended)

---

## Optional: Backend Secrets

For Cloudflare Workers backend, you'll also need to set these via Wrangler CLI:

```bash
cd backend

# Set Claude API key (optional - users can provide their own)
npx wrangler secret put CLAUDE_API_KEY

# Set Gemini API key (optional - users can provide their own)
npx wrangler secret put GEMINI_API_KEY

# Set Firebase Service Account (if using Firestore caching)
npx wrangler secret put FIREBASE_SERVICE_ACCOUNT
```

These are **not** needed for the GitHub Actions workflow, only for the backend Workers.

---

## Next Steps

1. ✅ Add secrets to GitHub
2. ✅ Push code to trigger deployment
3. ✅ Verify deployment at https://learn-smart.app
4. ✅ Deploy backend: `cd backend && npm run deploy:production`
5. ✅ Test API: `curl https://api.learn-smart.app`

---

For more information, see:
- `.github/workflows/deploy-web.yml` - Production deployment
- `.github/workflows/deploy-web-staging.yml` - Staging deployment
- `backend/Claude.md` - Backend setup guide
