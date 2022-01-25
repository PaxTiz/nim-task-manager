import ./task

type
  Project* = object
    name*: string
    tasks*: seq[Task]

proc newProject*(name: string, tasks: seq[Task] = @[]): Project =
  result.name = name
  result.tasks = tasks

proc validateProjectName*(name: string) =
  if name.len() <= 1:
    raise newException(ValueError, "Please provide a valid project name")
