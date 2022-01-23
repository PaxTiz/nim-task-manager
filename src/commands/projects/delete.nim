import sequtils
import ../../models/task_manager
import ../../models/project

proc newDeleteProject*(projectName: string) =
    validateProjectName(projectName)

    let taskManager = newTaskManager()

    if taskManager.findProjectByName(projectName):
        let projects = taskManager.projects.filterIt(it.name != projectName)
        initTaskManager(projects).save()

        echo "Success : Project `" & projectName & "` has been deleted."
        echo "All it's tasks have also been deleted."
    else:
        raise newException(ValueError, "Project `" & projectName & "` doesn' exists.")
