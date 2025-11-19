# CLAUDE.md - AI Assistant Guide for SUPERNOVA-AIHT Repository

## Repository Overview

**Repository Type:** GitHub Profile Repository
**Owner:** SUPERNOVA-AIHT
**Purpose:** This is a special GitHub profile repository. The README.md file in this repository appears on the user's GitHub profile page.

**Current State:** New repository with initial setup
- **Created:** Initial commit (17ab3c1)
- **Main Branch:** Not yet established
- **Current Files:** README.md

## Repository Structure

```
SUPERNOVA-AIHT/
├── .git/                 # Git repository metadata
├── README.md            # Profile README (displays on GitHub profile)
└── CLAUDE.md           # This file - AI assistant documentation
```

## Development Workflow

### Git Branch Strategy

**Branch Naming Convention:**
- All Claude-managed branches MUST follow the pattern: `claude/<descriptive-name>-<session-id>`
- Example: `claude/claude-md-mi5qqxsz240oor6p-01MU75XTsixBhXgFcXsGHU4f`
- **CRITICAL:** Branch names must start with `claude/` and end with the matching session ID, otherwise push operations will fail with 403 HTTP errors

**Working with Branches:**
1. Always develop on designated Claude feature branches
2. Create branches locally if they don't exist: `git checkout -b <branch-name>`
3. Push with upstream tracking: `git push -u origin <branch-name>`
4. Never push to different branches without explicit permission

### Git Operations Best Practices

**Push Operations:**
- Always use: `git push -u origin <branch-name>`
- Retry policy for network failures:
  - Retry up to 4 times with exponential backoff (2s, 4s, 8s, 16s)
  - Only retry on network errors, not authentication/permission failures

**Fetch/Pull Operations:**
- Prefer specific branch fetches: `git fetch origin <branch-name>`
- For pulls: `git pull origin <branch-name>`
- Apply same retry logic for network failures

**Commit Guidelines:**
- Write clear, descriptive commit messages
- Follow conventional commit format when appropriate:
  - `feat:` for new features
  - `fix:` for bug fixes
  - `docs:` for documentation changes
  - `refactor:` for code refactoring
  - `chore:` for maintenance tasks
- Use present tense ("Add feature" not "Added feature")
- Keep first line under 72 characters
- Add detailed description in commit body if needed

### Security Considerations

**Never Commit:**
- Credentials or API keys
- `.env` files with secrets
- Private keys or certificates
- Personal access tokens
- Sensitive configuration files

**If Accidentally Committed:**
1. Warn the user immediately
2. Do not push the commit
3. Help remove sensitive data using `git reset` or `git rebase`

## Code Conventions

### File Organization

**Documentation Files:**
- `README.md` - Main profile display (user-facing content)
- `CLAUDE.md` - AI assistant documentation (this file)
- Additional docs should go in a `/docs` directory when created

**Future Structure Recommendations:**
As the repository grows, consider organizing into:
```
SUPERNOVA-AIHT/
├── docs/              # Additional documentation
├── projects/          # Project showcases
├── assets/            # Images, badges, media
├── scripts/           # Automation scripts
└── .github/           # GitHub-specific configurations
```

### Markdown Style Guide

**For README.md Profile:**
- Use emoji sparingly and purposefully
- Maintain professional yet personal tone
- Include sections like:
  - Introduction/About Me
  - Skills & Technologies
  - Current Projects
  - Contact Information
  - GitHub Stats (optional)
- Keep formatting consistent
- Test rendering on GitHub's markdown engine

**General Markdown:**
- Use ATX-style headers (# Header)
- Include blank lines around headers and code blocks
- Use code fences with language specification
- Keep line length reasonable (80-120 characters when possible)

## AI Assistant Instructions

### Task Approach

1. **Read First:** Always read existing files before editing
2. **Plan with Todos:** Use TodoWrite tool for multi-step tasks
3. **Incremental Changes:** Make small, testable changes
4. **Verify Operations:** Check git status after commits/pushes
5. **Error Handling:** Retry network operations with backoff

### When Working on Tasks

**Before Making Changes:**
- Check current branch: `git branch`
- Review git status: `git status`
- Read relevant files completely
- Understand user's intent fully

**During Implementation:**
- Track progress with TodoWrite tool
- Mark todos as in_progress, then completed
- Commit logical units of work
- Write descriptive commit messages

**After Changes:**
- Verify changes with git diff
- Test if applicable
- Commit with clear message
- Push to the correct branch
- Report completion to user

### Common Operations

**Creating/Updating Profile README:**
```bash
# Edit README.md with user's content
# Commit changes
git add README.md
git commit -m "docs: update profile README with [description]"
git push -u origin <branch-name>
```

**Adding New Files:**
```bash
# Create file(s)
# Stage and commit
git add <files>
git commit -m "feat: add [description]"
git push -u origin <branch-name>
```

**Documentation Updates:**
```bash
# Update documentation
git add <doc-files>
git commit -m "docs: update [what was updated]"
git push -u origin <branch-name>
```

## Pull Request Guidelines

**When Creating PRs:**
1. Analyze all commits that will be included (not just the latest)
2. Use git log and git diff to understand full change scope
3. Write comprehensive PR description with:
   - Summary of changes (bullet points)
   - Test plan or verification steps
   - Any breaking changes or considerations

**PR Title Format:**
- Be clear and descriptive
- Follow conventional commit style when appropriate
- Example: "Add comprehensive profile README"

**PR Body Template:**
```markdown
## Summary
- Bullet point summary of changes
- Key features or fixes implemented

## Test Plan
- [ ] Verified markdown renders correctly
- [ ] Checked all links work
- [ ] Reviewed formatting on GitHub

## Additional Notes
Any relevant context or considerations
```

## Troubleshooting

### Common Issues

**Push Fails with 403:**
- Verify branch name starts with `claude/` and includes session ID
- Check branch name matches expected pattern
- Confirm you're on correct branch: `git branch`

**Network Failures:**
- Implement retry logic (4 attempts with exponential backoff)
- Check if issue is network vs. permissions
- Report persistent failures to user

**Merge Conflicts:**
- Fetch latest changes: `git fetch origin`
- Review conflicting files
- Consult with user before resolving complex conflicts

## Repository Evolution

As this repository grows, update this CLAUDE.md file to include:

1. **New Directory Structure:** Document any new folders and their purposes
2. **Build/Deploy Processes:** If automation is added
3. **Testing Conventions:** If tests are introduced
4. **Code Style Guides:** Language-specific conventions
5. **Dependencies:** Package managers and version requirements
6. **Environment Setup:** Instructions for development environment

## Version History

- **2025-11-19:** Initial CLAUDE.md created
  - Documented profile repository structure
  - Established git workflow conventions
  - Defined AI assistant guidelines

## Additional Resources

- [GitHub Profile README Guide](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/customizing-your-profile/managing-your-profile-readme)
- [Markdown Guide](https://www.markdownguide.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Best Practices](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)

---

**Last Updated:** 2025-11-19
**Maintained By:** AI Assistants working with SUPERNOVA-AIHT
**Status:** Active Development
