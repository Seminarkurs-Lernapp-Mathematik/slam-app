# Cloudflare Pages Setup for Flutter Web

This guide explains how to configure Cloudflare Pages deployment for the Flutter web app.

## Required GitHub Secrets

Add these secrets to the **slam-app** repository only:

### 1. CLOUDFLARE_API_TOKEN

**How to get it:**

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Click on your profile icon (top right) → **My Profile**
3. Navigate to **API Tokens** (left sidebar)
4. Click **Create Token**
5. Use the **Edit Cloudflare Workers** template
6. Configure permissions:
   - **Account** → **Cloudflare Pages** → **Edit**
   - **Account** → **Cloudflare Workers** → **Edit**
7. Click **Continue to summary** → **Create Token**
8. **Copy the token** (you won't see it again!)

**Add to GitHub:**
```
Repository → Settings → Secrets and variables → Actions → New repository secret
Name: CLOUDFLARE_API_TOKEN
Value: [paste your token]
```

### 2. CLOUDFLARE_ACCOUNT_ID

**How to get it:**

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Select any domain/site (or go to Workers & Pages)
3. The **Account ID** is visible in the right sidebar under "Account ID"
4. Or look in the URL: `dash.cloudflare.com/<ACCOUNT_ID>/workers`

**Add to GitHub:**
```
Repository → Settings → Secrets and variables → Actions → New repository secret
Name: CLOUDFLARE_ACCOUNT_ID
Value: [paste your account ID]
```

## How It Works

Once secrets are configured:

1. **Push to `main` branch** → Automatically builds Flutter web app
2. **GitHub Actions workflow** runs:
   - Installs Flutter 3.38.9
   - Runs `flutter pub get`
   - Generates code with `build_runner`
   - Builds web app: `flutter build web --release`
   - Deploys to Cloudflare Pages
3. **Live at:** https://learn-smart.app

## Manual Deployment

Trigger deployment manually:
1. Go to **Actions** tab in GitHub
2. Select "Deploy Flutter Web to Cloudflare Pages"
3. Click **Run workflow** → Select `main` branch → **Run**

## Verify Deployment

After deployment completes, visit:
- **Production:** https://learn-smart.app
- **Check logs:** GitHub Actions tab → Latest workflow run

## Troubleshooting

**Error: "Invalid API token"**
- Regenerate the token with correct permissions
- Ensure it has "Edit Cloudflare Pages" permission

**Error: "Account ID not found"**
- Double-check the Account ID from dashboard
- Ensure it matches your Cloudflare account

**Build fails with "lottie" dependency error**
- Verify workflow uses Flutter 3.38.9 (includes Dart 3.9.0+)
- Check `.github/workflows/deploy-web.yml` line 16

---

**Backend Note:** The backend at `api.learn-smart.app` auto-deploys via Cloudflare's GitHub integration. No GitHub Actions needed for backend.

**Need help?** Check [Cloudflare Pages Docs](https://developers.cloudflare.com/pages/)
