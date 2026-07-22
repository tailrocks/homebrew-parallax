# GitHub workflow guidance

- Keep one workflow shape for Velnor, GitHub, and `both` lanes.
- Velnor is the default; GitHub uses pinned `ubuntu-26.04` only when selected.
- Install workflow tools through mise and commit `mise.lock`.
- Pin every third-party action to a full commit SHA.
- Keep permissions least-privilege, concurrency bounded, and every job timed out.
- Preserve identical verification semantics across lanes.
- Gate tap mutation with `matrix.config.writer`; `both` has exactly one writer.
