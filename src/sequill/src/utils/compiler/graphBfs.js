/**
 * 广度优先搜索算法
 * @param {g} node 
 * @returns 
 */
export function breadthFirstTravel (root, edges, node) {
  const res = [];
  const nodeList = []; // 存储需要被访问的节点
  nodeList.push(root);
  while (nodeList.length > 0) {
    const currentNode = nodeList.shift(0);
    res.push(currentNode);
    for (var i = 0, childrens = currentNode.children; i < childrens.length; i++) {
      nodeList.push(childrens[i]);
    }   
  }
  return res;
}

/**
 * 返回节点的最短父亲节点，包含路径
 * @param {g} node 
 * @returns 
 */
export function parentTravel (nodes, edges, node) {  
  const nodeList = []; // 存储需要被访问的节点Id
  const edgeList = [];
  nodeList.push(node.id);
  
  while (nodeList.length > 0) {
    const currentNode = nodeList.shift(0);    
    for(let i=0;i<edges.length;i++){
      if(edges[i].target===currentNode){
        edgeList.push(edges[i]);
        nodeList.push(edges[i].source);
        break;
      }
    }  
  }
  return edgeList;
}


/**
 * 返回节点的当前状态
 * @param {g} node 
 * @returns 
 */
export function parentTravelVariables (nodes, edges, variables, node) {
  const res = {};
  for(let v of variables){
    v.value = v.initialValue;
    res[v.id] = v;
  }

  const edgeList = parentTravel(nodes,edges,node);
  for(let i = edgeList.length-1; i>=0; i--){
    const actions = edgeList[i].data.actions;
    for(let action of actions){
      doAction(action,res);
    }
  } 
  
  return res;
}

const getText = (text,variables) =>{
  const lastInput = '{{response}}';
  return text.replace(/{{(.*?)}}/g, (match, p1) =>
      p1 === "response" ? `${lastInput}` : `${variables[p1].value}`
    );
}
    

const trueValue = (value, type, variables) => {
  let trueValue = value;
  if (typeof trueValue === "string") {
    trueValue = getText(trueValue,variables);
    switch (type) {
      case "Number":
        trueValue = Number(trueValue);
        break;
      case "Boolean":
        trueValue = trueValue === "true" || trueValue === "yes" || trueValue === "1";
        break;
      case "List":
        trueValue = value.split(",");
        break;
      default:
        break;
    }
  }
  return trueValue;
};

function doAction(action,variables){
  const variable = variables[action.variable];
  const value = trueValue(action.value, variable.type, variables);
  switch (variable.type) {
    case "Text":
      switch (action.action) {
        case "Set":
          variable.value = value;
          return;
        case "Append":
          variable.value += value;
          return;
      }
    case "Number":
      switch (action.action) {
        case "Set":
          variable.value = value;
          return;
        case "Add":
          variable.value += value;
          return;
        case "Subtract":
          variable.value -= value;
          return;
        case "Multiply":
          variable.value *= value;
          return;
        case "Divide":
          variable.value /= value;
          return;
      }
    case "Boolean":
      switch (action.action) {
        case "Set":
          variable.value = value;
          return;
        case "Not":
          variable.value = !value;
          return;
        case "And":
          variable.value = variable.value && value;
          return;
        case "Or":
          variable.value = variable.value || value;
          return;
      }
    case "List":
      switch (action.action) {
        case "Set":
          variable.value = action.value;
          return;
        case "Append":
          variable.value = variable.value.concat(value);
          return;
        case "Remove":
          variable.value = variable.value.filter(
            (item) => !value.includes(item)
          );
          return;
      }
  }
}

