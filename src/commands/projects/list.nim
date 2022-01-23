import strformat
import ../../models/task_manager

proc newListProjects*() =
    let taskManager = newTaskManager()
    echo "List of available projects :"
    for project in taskManager.projects:
        let projectTasks = project.tasks.len()
        echo (fmt"  — {project.name}, {projectTasks} tasks")
