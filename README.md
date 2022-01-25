# Task Manager

## Summary

## Usage
```
Usage: tasks [-h] [-v] [-p=project] [-d] command

Required arguments:
    command                        Command to execute

Optional arguments:
    -h, --help                     Show this help message and exit.
    -v, --version                  Show version number and exit.
    -p=project, --project=project  Name of the project
    -d, --debug                    Enable debug printing
```

`tasks projects`: list all projects

`tasks new -p=demo`: create a project with name 'demo'

`tasks delete -p=demo`: delete the project with name 'demo'

`tasks list -p=demo`: list all tasks related to project 'demo'

## How is it stored ?
All data are stored in a single json file in the iCloud documents folder.

A task looks like this :
```json
{
    "id": 1,
    "content": "Learn Nim deeper :)",
    "completed": true
}
```

A task is inside a project, and you can have multiple projects so the `database` have this format :
```json
{
    "projects": [
        {
            "name": "nim_learning", 
            "tasks": [
                {
                    "id": 1,
                    "content": "Learn Nim deeper :)",
                    "complete": true
                }
            ]
        }
    ]
}
```

## How to build ?


## Todo
- [x] `new --project=<p>` : create a new project
- [x] `projects` : list all projects
- [x] `delete --project=<p>` : delete project with given name

- [x] `list --project=<p>` : list all tasks for the given project

- [ ] `add <text> --project=<p>` : add a new task for the given project, as non-completed
- [ ] `complete <taskId> --project=<p>` : set the task with given id as complete
- [ ] `delete <taskId> --project=<p>` : delete the task with given id
