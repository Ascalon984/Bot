<#
Simple PowerShell helper to push this repository to your GitHub repo.

USAGE:
1. Open PowerShell in this folder: cd C:\Users\User\Downloads\BotWA
2. Run: .\push_to_github.ps1

Notes:
- This script will create a commit with all current files (if none exists) and set the remote to the URL below.
- When `git push` runs, Git will ask for credentials (your GitHub username & password or a Personal Access Token).
- Alternatively, authenticate beforehand using `gh auth login` (GitHub CLI) or set up an SSH key.
- The script is conservative: it won't overwrite an existing remote named 'origin' unless you confirm.
#>

$remoteUrl = 'https://github.com/Ascalon984/StaticBot.git'
$branch = 'main'

param(
  [switch]$NoPush,
  [switch]$AutoSSH
)

Write-Host "This script will add, commit and push the current folder to: $remoteUrl" -ForegroundColor Cyan

# ensure git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "Git is not installed or not in PATH. Install Git first and rerun."
  exit 1
}

# initialize repo if needed
if (-not (Test-Path .git)) {
  Write-Host "No .git folder found - initializing a new git repository..."
  git init
}

# check for existing remote
$existing = git remote 2>$null | Select-Object -First 1
if ($existing -and $existing -ne '') {
  Write-Host "Existing remotes found:"
  git remote -v
  # Safer prompt: avoid ambiguous characters and accept 'y' or 'Y' as confirmation
  $ans = Read-Host "Replace existing 'origin' remote with $remoteUrl? Type 'y' to confirm (default: N)"
  if ($ans -match '^[yY]') {
    git remote remove origin 2>$null
    git remote add origin $remoteUrl
  } else {
    Write-Host "Keeping existing remotes. If you want to add the repo manually, run: git remote add origin $remoteUrl" -ForegroundColor Yellow
  }
} else {
  git remote add origin $remoteUrl
}

# add and commit
git add -A
$commitMessage = Read-Host "Commit message (enter to use default)"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
  $commitMessage = 'Update BotWA files'
}
# only commit if there are staged changes
$staged = git diff --cached --name-only
if (-not [string]::IsNullOrWhiteSpace($staged)) {
  git commit -m "$commitMessage"
} else {
  Write-Host "No changes to commit." -ForegroundColor Yellow
}

# ensure branch
git branch --show-current 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  git checkout -b $branch
} else {
  $curr = git branch --show-current
  if ($curr -ne $branch) {
    Write-Host "Switching branch to $branch (creating if not present)..."
    git checkout -B $branch
  }
}

Write-Host "Pushing to origin/$branch..." -ForegroundColor Cyan
if ($NoPush) {
  Write-Host "NoPush flag detected - skipping 'git push' (dry run)." -ForegroundColor Yellow
  Write-Host "If everything looks good, re-run without -NoPush to actually push to remote." -ForegroundColor Yellow
  return
}

if ($AutoSSH) {
  # Ensure SSH key exists; if not, generate one and show public key for manual GitHub addition
  $sshDir = Join-Path $env:USERPROFILE '.ssh'
  if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir | Out-Null }
  $keyPath = Join-Path $sshDir 'id_ed25519'
  if (-not (Test-Path $keyPath)) {
    Write-Host "SSH key not found. Generating ed25519 key at $keyPath (no passphrase)..." -ForegroundColor Cyan
    ssh-keygen -t ed25519 -f $keyPath -N '' | Out-Null
  } else {
    Write-Host "Found existing SSH key at $keyPath" -ForegroundColor Cyan
  }

  $pub = Get-Content "${keyPath}.pub" -ErrorAction Stop
  Write-Host "\n=== SSH public key (copy and add to GitHub → Settings → SSH and GPG keys) ===\n" -ForegroundColor Yellow
  Write-Host $pub
  Write-Host "\nAdd the key on GitHub, then press Enter to continue (or Ctrl+C to cancel)..." -ForegroundColor Yellow
  Read-Host | Out-Null

  Write-Host "Switching remote to SSH and attempting push..." -ForegroundColor Cyan
  git remote set-url origin git@github.com:Ascalon984/StaticBot.git
  git push -u origin $branch
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Push completed successfully over SSH." -ForegroundColor Green
  } else {
    Write-Error "SSH push failed. Please ensure your key was added to GitHub and that SSH agent/port 22 is allowed by your network." 
  }
  return
}

Write-Host "You will be prompted for credentials if not already authenticated." -ForegroundColor Yellow
git push -u origin $branch

if ($LASTEXITCODE -eq 0) {
  Write-Host "Push completed successfully." -ForegroundColor Green
} else {
  Write-Error "Push failed. Check the output above - likely authentication or network issue." 
}
