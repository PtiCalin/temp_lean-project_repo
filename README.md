# Lean Project Template

A language-agnostic starter that keeps only the essentials so you can ship faster with either Python or Node.js.

## What's included
- Minimal `src/`, `tests/`, and `scripts/` layout.
- Smart CI that auto-detects Python or Node projects.
- Lightweight tooling: `pre-commit`, `.editorconfig`, `.gitignore`.
- MIT-licensed, ready for open collaboration.

## Quick start
1. Clone this repo and pick Python or Node — delete the bits you don't need.
2. (Optional) Install pre-commit hooks: `pre-commit install`.
3. Use the Makefile helpers:
   - `make run`
   - `make test`
   - `make format`

Check `scripts/dev.sh` for the detection logic used by the helpers.

## Continuous integration
GitHub Actions will automatically detect and run either Python (`pytest`) or Node (`npm test`) workflows based on the files present in your repo.

## License
This project is licensed under the [MIT License](LICENSE).
