module visualization::DuplicationTree

import vis::Figure;
import vis::Render;
import vis::KeySym;
import String;
import List;

import util::Visualization;

// TODO add legends

void generateDuplicationTree(lrel[loc, list[str], lrel[loc, list[str]]] duplicationMethods) {
	list[Figure] trees = [];
	str separator = "\n\n\t.....\n\n";
	
	for(duplicationMethod <- duplicationMethods) {
		loc originalLoc = duplicationMethod[0];
		str originalPath = originalLoc.path;
		list[str] originalLines = duplicationMethod[1];
		str originalLine = ("<originalPath> <separator> <head(originalLines)>" | it + "<line>\n" | line <- tail(originalLines));
		lrel[loc, list[str]] clones = duplicationMethod[2];
		
		list[Figure] children = [];
		for(clone <- clones) {
			loc cloneLoc = clone[0];
			str clonePath = cloneLoc.path;
			list[str] cloneLines = clone[1];
			str cloneLine = ("<clonePath> <separator> <head(cloneLines)>" | it + "<line>\n" | line <- tail(cloneLines));
			str methodName = getMethodName(clonePath);
			children += box(text(methodName), popup(cloneLine), openMethodOnClick(cloneLoc), fillColor("red"), resizable(false));
		}
		
		str methodName = getMethodName(originalPath);
		trees += tree(box(text(methodName), popup(originalLine), openMethodOnClick(originalLoc), fillColor("green"), resizable(false)), children, std(gap(20)));
	}
	
	render("Code Duplication Tree", pack(trees, std(gap(50))));
}

// just take the method name without the argument(s) from the path
private str getMethodName(str methodFullPath) {
	return substring(methodFullPath, findLast(methodFullPath, "/") + 1, findFirst(methodFullPath, "("));
}
