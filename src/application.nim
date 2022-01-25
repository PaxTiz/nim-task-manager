import ./models/task_manager

type
  Application* = object
    taskManager*: TaskManager

proc newApplication*(): Application =
  result.taskManager = newTaskManager()

proc listProjects*(app: Application) =
  app.taskManager.listProjects()

proc createProject*(app: Application, projectName: string) =
  app.taskManager.createProject(projectName)

proc deleteProject*(app: Application, projectName: string) =
  app.taskManager.deleteProject(projectName)
