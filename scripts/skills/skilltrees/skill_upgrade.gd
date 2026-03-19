extends Node
class_name SkillUpgrade

enum OpType { ADD, MULTIPLY, OVERRIDE } 

@export var stat_name: String = ""  
@export var operation: OpType = OpType.ADD
@export var value: float = 0.0
