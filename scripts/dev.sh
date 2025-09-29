#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<USAGE
Usage: $(basename "$0") <command> [args...]

Commands:
  run [args]     Run the project (auto-detects Python or Node).
  test [args]    Run the test suite.
  format [args]  Format code via pre-commit.
  help           Show this message.

Set DEV_RUNTIME=python or DEV_RUNTIME=node to override auto detection.
USAGE
}

has_python() {
    [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || compgen -G "src/*.py" >/dev/null || compgen -G "tests/*.py" >/dev/null
}

has_node() {
    [[ -f "package.json" ]]
}

choose_runtime() {
    local override=${DEV_RUNTIME:-}
    if [[ -n "$override" ]]; then
        echo "$override"
        return 0
    fi

    local python=false node=false
    if has_python; then python=true; fi
    if has_node; then node=true; fi

    if [[ "$python" == true && "$node" == false ]]; then
        echo "python"
    elif [[ "$node" == true && "$python" == false ]]; then
        echo "node"
    elif [[ "$python" == true && "$node" == true ]]; then
        echo "python"
        echo "Both Python and Node detected. Defaulting to Python (set DEV_RUNTIME=node to override)." >&2
    else
        echo "" >&2
        return 1
    fi
}

run_python() {
    if [[ -f "src/__main__.py" ]]; then
        python -m src "$@"
    elif [[ -f "src/main.py" ]]; then
        python src/main.py "$@"
    elif [[ -f "src/example.py" ]]; then
        python src/example.py "$@"
    else
        echo "No Python entry point found in src/." >&2
        return 1
    fi
}

run_node() {
    if command -v npm >/dev/null 2>&1; then
        if npm run start --if-present -- "$@"; then
            return 0
        fi
    fi

    if [[ -f "src/index.mjs" ]]; then
        node src/index.mjs "$@"
    elif [[ -f "src/example.mjs" ]]; then
        node src/example.mjs "$@"
    else
        echo "No Node entry point found in src/." >&2
        return 1
    fi
}

run_tests_python() {
    if command -v pytest >/dev/null 2>&1; then
        pytest "$@"
    else
        python -m pytest "$@"
    fi
}

run_tests_node() {
    if command -v npm >/dev/null 2>&1; then
        npm test -- "$@"
    else
        echo "npm is not installed." >&2
        return 1
    fi
}

run_format() {
    if command -v pre-commit >/dev/null 2>&1; then
        pre-commit run --all-files "$@"
    else
        echo "Install pre-commit to run format checks (pip install pre-commit)." >&2
        return 1
    fi
}

main() {
    local cmd=${1:-run}
    shift || true

    case "$cmd" in
    run)
        local runtime
        runtime=$(choose_runtime) || { echo "No supported runtime detected." >&2; exit 1; }
        if [[ "$runtime" == "python" ]]; then
            run_python "$@"
        elif [[ "$runtime" == "node" ]]; then
            run_node "$@"
        else
            echo "Unknown runtime: $runtime" >&2
            exit 1
        fi
        ;;
    test)
        local runtime
        runtime=$(choose_runtime) || { echo "No supported runtime detected." >&2; exit 1; }
        if [[ "$runtime" == "python" ]]; then
            run_tests_python "$@"
        else
            run_tests_node "$@"
        fi
        ;;
    format)
        run_format "$@"
        ;;
    help|-h|--help)
        usage
        ;;
    *)
        echo "Unknown command: $cmd" >&2
        usage >&2
        exit 1
        ;;
    esac
}

main "$@"
