extends Node

var trackedNodes = {}

func getNode(path):
	return trackedNodes[path]

func trackNode(node):
	trackedNodes[node.get_path()] = node
func untrackNode(node):
	trackedNodes.erase(node.get_path())
