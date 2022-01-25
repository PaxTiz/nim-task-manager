import tables
import clapfn
import ./models/task_manager

let parser = ArgumentParser(
  programName: "tasks",
  fullName: "Tasks Manager",
  description: "Manage tasks from CLI",
  version: "0.0.1",
  author: "Valentin Cernuta <vcernuta3@gmail.com>"
)

when isMainModule:
  # Commands
  # [x]  - new --project=<p> : create a new project
  # [x]  - projects : list all projects
  # [x]  - delete --project=<p> : delete project with given name

  # [x]  - list --project=<p> : list all tasks for the given project
  
  # [ ]  - add <text> --project=<p> : add a new task for the given project, as non-completed
  # [ ]  - complete <taskId> --project=<p> : set the task with given id as complete
  # [ ]  - delete <taskId> --project=<p> : delete the task with given id

  parser.addRequiredArgument(
    name = "command",
    help = "Command to execute"
  )
  parser.addStoreArgument(
    shortName = "-p",
    longName = "--project",
    usageInput = "project",
    default = "",
    help = "Name of the project"
  )
  parser.addSwitchArgument(
    shortName = "-d",
    longName = "--debug",
    default = false,
    help = "Enable debug printing"
  )

  let args = parser.parse()
  let command = args["command"]
  let project = args["project"]
  let debug = args["debug"]

  let app = newTaskManager()

  try:
    case command:
      of "projects": app.listProjects()
      of "new": app.createProject(project)
      of "delete": app.deleteProject(project)

      of "list": app.listTasksForProject(project)
      else: echo "Unknown command"
  except Exception:
    echo "Error : " & getCurrentExceptionMsg()
