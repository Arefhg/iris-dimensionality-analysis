# GitHub Setup Guide — Step by Step for Beginners

This is your complete guide to putting this project on GitHub for the first time.

---

## Step 1 — Create a GitHub Account (skip if you already have one)

1. Go to https://github.com
2. Click **Sign up** and create a free account
3. Verify your email

---

## Step 2 — Create a New Repository

1. Once logged in, click the **+** button in the top-right corner
2. Select **New repository**
3. Fill in the form:
   - **Repository name:** `iris-dimensionality-analysis`
   - **Description:** `Dimensionality reduction and clustering on the Iris dataset using PCA, SVD, LDA, K-Means and K-Medoids in MATLAB`
   - **Visibility:** Public (so others can see your work)
   - **DO NOT** check "Add a README file" (we already have one)
4. Click **Create repository**

---

## Step 3 — Install Git on Your Computer

- **Windows:** Download from https://git-scm.com/download/win and install
- **Mac:** Open Terminal and run: `git --version` (it will prompt to install if missing)
- **Linux:** Run: `sudo apt install git`

After installing, configure your identity (do this once):
```
git config --global user.name "Aref Haghgoorostami"
git config --global user.email "aref.hg96@gmail.com"
```

---

## Step 4 — Organize Your Project Folder

Your folder should look exactly like this before uploading:

```
iris-dimensionality-analysis/
│
├── data/
│   └── Iris.csv                     ← Copy the Iris.csv file here
│
├── src/
│   └── iris_analysis.m              ← The main MATLAB script
│
├── report/
│   └── Iris_Analysis_Report.docx   ← The written report
│
├── README.md                        ← The GitHub page description
└── GITHUB_SETUP_GUIDE.md           ← This file (you can delete it after setup)
```

**Important:** Make sure `Iris.csv` is placed inside the `data/` folder, because the
MATLAB script uses the path `../data/Iris.csv` to find it.

---

## Step 5 — Upload Your Files

### Option A — Upload via the GitHub Website (easiest for beginners)

1. Go to your new repository page on GitHub
2. Click **uploading an existing file** (the link in the middle of the empty repo page)
3. Drag and drop your entire `iris-dimensionality-analysis/` folder
4. Scroll down, write a commit message: `Initial commit - add full project files`
5. Click **Commit changes**

### Option B ℔ Upload via Git Command Line (recommended for future projects)

Open Terminal (Mac/Linux) or Git Bash (Windows) and run:

```bash
# 1. Navigate to your project folder
cd path/to/iris-dimensionality-analysis

# 2. Initialize git
git init

# 3. Add all files
git add .

# 4. Make your first commit
git commit -m "Initial commit - Iris dimensionality reduction project"

# 5. Connect to your GitHub repo (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/iris-dimensionality-analysis.git

# 6. Push to GitHub
git branch -M main
git push -u origin main
```

---

## Step 6 ℔ Verify Your Repository

1. Go to `https://github.com/YOUR-USERNAME/iris-dimensionality-analysis`
2. You should see:
   - The README displayed automatically on the page
   - All folders: `data/`, `src/`, `report/`
   - All files listed

---

## What Your Repository Will Look Like

Visitors to your GitHub page will see:

- A professional **README** explaining the project, methods, and results
- A clean **MATLAB script** with full comments explaining every step
- A **written report** they can download
- A clear **folder structure** that shows you know how to organize a project

---

## Tips for a Good GitHub Profile

- Pin this repository to your profile so it appears at the top
- Add a profile picture and short bio in your GitHub settings
- For future projects, always write a README — it's the first thing people read
- Commit often with meaningful messages like `"Add LDA visualization"` rather than `"update"`

---

## Common Git Commands You Will Use

| Command | What it does |
|---|---|
| `git status` | Show which files have changed |
| `git add filename` | Stage a specific file for commit |
| `git add .` | Stage all changed files |
| `git commit -m "message"` | Save a snapshot with a description |
| `git push` | Upload your commits to GitHub |
| `git pull` | Download latest changes from GitHub |
| `git log` | Show history of all commits |

---

*You are now ready to put your first project on GitHub. Good luck!*
