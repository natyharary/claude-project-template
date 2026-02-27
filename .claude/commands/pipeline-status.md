# Pipeline Status

Show the current state of the active pipeline.

---

Read `.claude/pipeline/tasks.md` using the Read tool. If the file does not exist, tell the user no pipeline is active and suggest running `/pipeline <feature>`.

Format and display the contents as follows:

1. **Request**: Show the FEATURE and TIMESTAMP
2. **Spec**: Show GOAL and the acceptance criteria checklist
3. **Tasks**: For each TASK block, show a status summary table:

   | ID | Status | Assigned | Description |
   |----|--------|----------|-------------|
   | T1 | done   | coder    | ...         |

4. **Sign-off**: Show SIGN_OFF_STATUS and any notes

If tasks.md does not exist, tell the user no pipeline is active and suggest running `/pipeline <feature>`.

If the pipeline appears to be in progress (any STATUS: in_progress), note that a pipeline is currently running.
