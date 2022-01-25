import strformat
import ./task

type
  Project* = object
    name*: string
    tasks*: seq[Task]

proc newProject*(name: string, tasks: seq[Task] = @[]): Project =
  result.name = name
  result.tasks = tasks

# Throw an exception is string `name` is too small
# =====
proc validateProjectName*(name: string) =
  if name.len() <= 1:
    raise newException(ValueError, "Please provide a valid project name")

# List all tasks related to the requested `project`
# =====
proc listTasks*(project: Project) =
  echo "List of tasks for the project " & project.name & " :"
  if project.tasks.len() == 0:
    echo "  There is no task for this project.."
  else:
    for task in project.tasks:
      if task.completed:
        echo (fmt"  — [x] {task.content}")
      else:
        echo (fmt"  — [ ] {task.content}")
