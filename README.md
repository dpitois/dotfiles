# .dotfiles

Dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi).

## Installation & Configuration

These dotfiles use templates to adapt to different environments (Personal vs. Work).

### First-time installation

When you initialize `chezmoi` on a new machine, it will interactively prompt you for:
- **Email address**: Used to configure your `.gitconfig`.
- **Is this a work machine?**: If `true`, specific tools like `pnpm` will be configured in your `.bashrc`.

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize and apply (replace with your repo URL)
chezmoi init --apply https://github.com/dpitois/dotfiles.git
```

### SSH & Commit Signing (Optional but Recommended)

To securely push changes and sign your commits without entering credentials every time:

1. **Generate a unique SSH key** for this machine:
   ```bash
   ssh-keygen -t ed25519 -C "github-$(hostname)" -f ~/.ssh/id_ed25519
   ```
2. **Add the public key to GitHub**:
   Copy the output of `cat ~/.ssh/id_ed25519.pub` to your [GitHub SSH keys](https://github.com/settings/keys) as an **Authentication Key** (and optionally as a **Signing Key**).
3. **Enjoy Transparency**:
   Once `chezmoi apply` is run, Git will automatically use SSH for all GitHub interactions (even for repos cloned via HTTPS) thanks to the `insteadOf` configuration.

### Changing your configuration

If you need to update your email or switch the machine type after installation:

```bash
# Re-run initialization to trigger prompts again
chezmoi init

# Apply the new configuration
chezmoi apply
```

## Daily Usage

```bash
# Add a new file to chezmoi
chezmoi add ~/.bashrc

# Pull latest changes from your repo and apply them
chezmoi update

# See what changes will be applied
chezmoi diff

# Manually apply changes from the source directory
chezmoi apply
```

