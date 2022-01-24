import tables
import clapfn
import ./commands/projects/[list, new, delete]

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

  # [ ]  - list --project=<p> : list all tasks for the given project
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

  try:
    case command:
      of "projects":
        newListProjects()
      of "new":
        createNewProject(project)
      of "delete":
        newDeleteProject(project)
      else:
        echo "Unknown command"
  except Exception:
    echo "Error : " & getCurrentExceptionMsg()