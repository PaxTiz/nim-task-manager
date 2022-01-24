import ../../models/[task_manager, project]

proc createNewProject*(projectName: string) = 
    validateProjectName(projectName)

    let taskManager = newTaskManager()
    
    if taskManager.findProjectByName(projectName):
        raise newException(ValueError, "Project `" & projectName & "` already exists.")
    else:
        var projects = taskManager.projects
        let project = newProject(projectName)
        projects.add(project)

        initTaskManager(projects).save()
        echo "Success : Project `" & projectName & "` has been created."
        echo "You can now create task for this project and see it in the list."
