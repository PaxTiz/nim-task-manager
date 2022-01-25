import os, osproc, json, marshal, strformat, strutils, sequtils
import ./project

let username = execProcess("echo $USER").strip()
let filename = (fmt"/Users/{username}/Library/Mobile Documents/com~apple~CloudDocs/.tasks.json")

type
  TaskManager* = object
    projects*: seq[Project]

proc initTaskManager*(projects: seq[Project]): TaskManager =
  result.projects = projects

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

proc save*(taskManager: TaskManager) =
  writeFile(filename, $$taskManager)

proc findProjectByName(taskManager: TaskManager, project: string): bool =
  return taskManager.projects.filterIt(it.name == project).len() > 0

proc listProjects*(taskManager: TaskManager) =
  echo "List of available projects :"
  for project in taskManager.projects:
    let projectTasks = project.tasks.len()
    echo (fmt"  — {project.name}, {projectTasks} tasks")

proc createProject*(taskManager: TaskManager, projectName: string) =
  validateProjectName(projectName)
  if taskManager.findProjectByName(projectName):
    raise newException(ValueError, "Project `" & projectName & "` already exists.")
  else:
    var projects = taskManager.projects
    let project = newProject(projectName)
    projects.add(project)

    initTaskManager(projects).save()
    echo "Success : Project `" & projectName & "` has been created."
    echo "You can now create task for this project and see it in the list."

proc deleteProject*(taskManager: TaskManager, projectName: string) =
  validateProjectName(projectName)
  if taskManager.findProjectByName(projectName):
    let projects = taskManager.projects.filterIt(it.name != projectName)
    initTaskManager(projects).save()

    echo "Success : Project `" & projectName & "` has been deleted."
    echo "All it's tasks have also been deleted."
  else:
    raise newException(ValueError, "Project `" & projectName & "` doesn' exists.")
  