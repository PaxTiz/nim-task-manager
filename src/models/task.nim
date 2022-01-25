type
  Task* = object
    id*: int
    content*: string
    completed*: bool

proc newTask*(id: int, content: string, completed: bool = false): Task =
  result.id = id
  result.content = content
  result.completed = completed
