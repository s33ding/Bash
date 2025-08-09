# `fg` on Linux shell — quick reference

`fg` is a **shell builtin** (bash/zsh/fish) used with **job control** to bring a background or stopped job into the **foreground**, attaching it to your terminal so it can read input and show output.

## Quick how-to
1. Start something in the background:
```bash
sleep 300 &
```
2. See your jobs:
```bash
jobs       # shows [1]  Running   sleep 300 &
```
3. Bring it to the foreground:
```bash
fg         # defaults to the “current” job, marked with +
```

## Target a specific job (jobspec)
```bash
fg %1        # job number 1
fg %+        # current job
fg %-        # previous job
fg %vim      # job whose command starts with "vim"
fg %?ssh     # job whose command contains "ssh"
```

## Common flows
Suspend, then resume in foreground:
```bash
long_cmd
# press Ctrl+Z to suspend (stopped)
fg            # resumes it in the foreground (sends SIGCONT)
```

Background then foreground:
```bash
long_cmd &
fg %long_cmd
```

## Notes & gotchas
- `fg` is a **shell builtin**; `which fg` may show nothing, and `sudo fg` won’t work (run `fg` in the shell that owns the job).
- If there’s no current job, `fg` errors with “no current job.”
- Use `jobs -l` to see PIDs; `bg` to resume in background; `kill -STOP/CONT <pid>` to stop/continue by signal.
- Job control is usually on in **interactive** shells; in non-interactive scripts it’s typically off. (You can `set -m` in bash to enable job control, but it’s uncommon in scripts.)
- You **can’t** “attach” to arbitrary processes with `fg`. It only works for jobs started in the same shell and session (use tmux/screen for persistent sessions).
- `fg` returns the exit status of the job it foregrounds (useful in scripts *if* job control is enabled).

## See also
- `bg` — continue a stopped job in the background
- `jobs` — list shell-managed jobs
- `disown` — remove a job from the shell’s job table
- `kill` — send signals (e.g., `-STOP`, `-CONT`)
- `tmux`, `screen` — for detachable/persistent sessions

