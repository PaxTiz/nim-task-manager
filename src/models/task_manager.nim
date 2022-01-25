import os, osproc, json, marshal, strformat, strutils, sequtils, options
import ./project

let username = execProcess("echo $USER").strip()
let filename = (fmt"/Users/{username}/Library/Mobile Documents/com~apple~CloudDocs/.tasks.json")

type
  TaskManager* = object
    projects*: seq[Project]

proc initTaskManager*(projects: seq[Project]): TaskManager =
  result.projects = projects

# Read the database file and deserialize it as a `TaskManager`
# =====
proc newTaskManager*(): TaskManager =
  if fileExists(filename):
    let file = open(filename)
    let content = file.readAll()
    file.close()

    let jsonContent = parseJson(content)
    let taskManager = to(jsonContent, TaskManager)
    return taskManager
  else:
    let task = %*{
      "name": "default",
      "tasks": %*[]
    }
    let body = %*{
      "projects": @[task]
    }

    writeFile(filename, $body)
    return to(body, TaskManager)

# Stringify and save the task manager to the database file
# =====
proc save*(taskManager: TaskManager) =
  writeFile(filename, $$taskManager)

#[
  Try to find a project with given name
  - Return some(Project) if one is found
  - Return none(Project) otherwise
]#
# =====
proc findProjectByName(taskManager: TaskManager, project: string): Option[Project] =
  let project = taskManager.projects.filterIt(it.name == project)
  if project.len() == 0:
    return none(Project)
  else:
    return some(project[0])

# Lists all projects
# =====
proc listProjects*(taskManager: TaskManager) =
  echo "List of available projects :"
  for project in taskManager.projects:
    let projectTasks = project.tasks.len()
    echo (fmt"  — {project.name}, {projectTasks} tasks")

# Create a project with given `name`
# =====
proc createProject*(taskManager: TaskManager, projectName: string) =
  validateProjectName(projectName)
  let project = taskManager.findProjectByName(projectName)
  if project.isNone:
    raise newException(ValueError, "Project `" & projectName & "` already exists.")
  else:
    var projects = taskManager.projects
    let project = newProject(projectName)
    projects.add(project)

    initTaskManager(projects).save()
    echo "Success : Project `" & projectName & "` has been created."
    echo "You can now create task for this project and see it in the list."

# Delete the project with given `name`
# =====
proc deleteProject*(taskManager: TaskManager, projectName: string) =
  validateProjectName(projectName)
  let project = taskManager.findProjectByName(projectName)
  if project.isSome:
    let projects = taskManager.projects.filterIt(it.name != projectName)
    initTaskManager(projects).save()

    echo "Success : Project `" & projectName & "` has been deleted."
    echo "All it's tasks have also been deleted."
  else:
    raise newException(ValueError, "Project `" & projectName & "` doesn' exists.")

# List all tasks for the requested `project`
# =====
proc listTasksForProject*(taskManager: TaskManager, projectName: string) =
  validateProjectName(projectName)
  let project = taskManager.findProjectByName(projectName)
  if project.isSome:
    project.get.listTasks()
  else:
    raise newException(ValueError, "Project `" & projectName & "` doesn' exists.")
