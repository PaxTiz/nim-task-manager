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
        let body = %*{
            "default": @[]
        }

        writeFile(filename, $body)
        return to(body, TaskManager)

proc save*(taskManager: TaskManager) =
    writeFile(filename, $$taskManager)

proc findProjectByName*(taskManager: TaskManager, project: string): bool =
    return taskManager.projects.filterIt(it.name == project).len() > 0
