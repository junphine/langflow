const states = {"start":{"id":"start","type":"input","pathType":"text","text":"<p style=\"text-align:left\"></p><img src=https://pic3.zhimg.com/v2-d1f733345b0d11ea4d1bde0e2511dbc8_720w.jpg?source=172ae18b></img><p style=\"text-align:left\"></p><p style=\"text-align:left\">很高兴认识你，长得很可爱的小朋友！ 你叫什么名字？</p>","ignoreCapitalisation":true,"ignorePunctuation":true,"ignoreArticles":true,"transitions":{"":{"to":"b6e01ae0-7707-4178-b03a-b505ffb4e97e","actions":[{"id":"e8e1d563-f23c-4b04-966e-e3e653876657","action":"Set","variable":"7b38f283-7c54-4a68-b9a0-a081d9be2d66","value":"{{response}}"},{"id":"2ec90848-7a74-4204-8aab-7994264e838a","action":"Add","variable":"74846864-6bbb-48a6-92f2-c179917309d5","value":1}]},"我不告诉你":{"to":"293b95de-e353-4de7-a234-108a5c6f0dd1","actions":[{"id":"0433d622-8edf-49a0-ae85-1d8a0fb6f64b","action":"Add","variable":"958d3e5c-dc64-4187-ae87-4ae4d940ca01","value":1},{"id":"414ca016-aa46-457b-b5a8-4e837b9a1fff","action":"Subtract","variable":"89be333a-42cc-451f-a730-cdd7c4732961","value":1},{"id":"8df9d2a4-6db7-4f99-9b4f-04e7a8be4b69","action":"Add","variable":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","value":2}]}}},"f0f4c035-c3a2-4438-be28-4935863eaa94":{"id":"f0f4c035-c3a2-4438-be28-4935863eaa94","type":"output","pathType":"button","text":"<p style=\"text-align:left\">恭喜你成为都市白领！</p><p style=\"text-align:left\">The End.</p>","transitions":{}},"6a425da5-9099-47b4-a355-c1b4d6f732e1":{"id":"6a425da5-9099-47b4-a355-c1b4d6f732e1","type":"output","pathType":"button","text":"<p style=\"text-align:left\">恭喜你继承家产，可以做个顽固子弟！ </p><p style=\"text-align:left\">The End.</p>","transitions":{}},"c5536d68-5787-47a8-9dc0-024b5f4c0064":{"id":"c5536d68-5787-47a8-9dc0-024b5f4c0064","type":"default","pathType":"button","text":"<p style=\"text-align:left\">加油吧，少年！你今年岁了，将来一定能考上大学。</p>","transitions":{"我会的，而且我还要天天上补习班":{"to":"kaoshangdaxue","actions":[{"id":"ec9c5a6d-75ec-4448-bfd8-882ff4b35da6","action":"Subtract","variable":"89be333a-42cc-451f-a730-cdd7c4732961","value":1},{"id":"11f7cbf9-fe11-47a0-bc4e-7a14224a0783","action":"Subtract","variable":"4676adbf-c04e-471d-8b16-ce3fb51ce26d","value":1},{"id":"e17f0918-5a1b-45de-9aa2-ff408b83515b","action":"Add","variable":"958d3e5c-dc64-4187-ae87-4ae4d940ca01","value":1},{"id":"b46cb266-6a1a-4e2d-af22-08ca11d1c601","action":"Subtract","variable":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","value":1}]},"我会的，但是我太笨了":{"to":"63eb2f60-c768-41c3-82a6-9011b9f74eb3","actions":[{"id":"16bc9b1e-1179-4537-8fc2-d8193d26a0b3","action":"Subtract","variable":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","value":2}]}}},"9a436f59-3343-4293-a96e-ce44838fb15c":{"id":"9a436f59-3343-4293-a96e-ce44838fb15c","type":"default","pathType":"text","text":"<p style=\"text-align:left\">真是有福气的孩子！祝你生活愉快！</p>","ignoreCapitalisation":true,"ignorePunctuation":true,"ignoreArticles":true,"transitions":{"命好而已":{"to":"6a425da5-9099-47b4-a355-c1b4d6f732e1","actions":[{"id":"9cf8a3fc-bb11-4be7-8d43-ff6dbdf1b9ab","action":"Add","variable":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","value":1}]},"":{"to":"9c6ee63f-1070-4372-83b6-1e25764f1a1f","actions":[]}}},"kaoshangdaxue":{"id":"kaoshangdaxue","type":"default","pathType":"button","text":"<p style=\"text-align:left\">多年以后...</p><p style=\"text-align:left\">你真的考上大学! 大学毕业后，你找到一份不错工作！</p>","transitions":{"我要努力工作":{"to":"f0f4c035-c3a2-4438-be28-4935863eaa94","actions":[]},"老板，我一定要取而代之":{"to":"9c6ee63f-1070-4372-83b6-1e25764f1a1f","actions":[]}}},"b6e01ae0-7707-4178-b03a-b505ffb4e97e":{"id":"b6e01ae0-7707-4178-b03a-b505ffb4e97e","type":"default","pathType":"button","text":"<p style=\"text-align:left\">真是别致的名字！</p><p style=\"text-align:left\">{{7b38f283-7c54-4a68-b9a0-a081d9be2d66}},你对上学有兴趣吗？</p>","transitions":{"当然":{"to":"c5536d68-5787-47a8-9dc0-024b5f4c0064","actions":[{"id":"d7de457e-4d57-4a55-a60b-d67fb8d552ee","action":"Add","variable":"74846864-6bbb-48a6-92f2-c179917309d5","value":2},{"id":"d82c6a0e-a308-4766-9be9-fd07193f73a6","action":"Add","variable":"89be333a-42cc-451f-a730-cdd7c4732961","value":1},{"id":"15c25c0f-e81b-44bb-bbf7-017cf6e4a32b","action":"Add","variable":"958d3e5c-dc64-4187-ae87-4ae4d940ca01","value":1}]},"我更喜欢玩游戏，睡觉":{"to":"9a436f59-3343-4293-a96e-ce44838fb15c","actions":[{"id":"193d94ed-e3c2-44b6-bfc1-7e628413cd3c","action":"Add","variable":"74846864-6bbb-48a6-92f2-c179917309d5","value":4},{"id":"6d4eba1a-6ec9-4d2a-808b-e9f57c97a7fb","action":"Add","variable":"958d3e5c-dc64-4187-ae87-4ae4d940ca01","value":1}]}}},"293b95de-e353-4de7-a234-108a5c6f0dd1":{"id":"293b95de-e353-4de7-a234-108a5c6f0dd1","type":"default","pathType":"button","text":"<p style=\"text-align:left\">小家伙挺谨慎的吗！</p><p style=\"text-align:left\">你家里一定很有钱吧？</p>","transitions":{"勉强温饱":{"to":"16df7aa0-829e-4084-a489-2128aed1a91f","actions":[{"id":"771f22a7-2178-447c-adce-6976acfaf800","action":"Add","variable":"4676adbf-c04e-471d-8b16-ce3fb51ce26d","value":1}]},"我爸是当官的":{"to":"9a436f59-3343-4293-a96e-ce44838fb15c","actions":[{"id":"95af67b5-8d7e-4619-abc6-d94d95a5c386","action":"Add","variable":"4676adbf-c04e-471d-8b16-ce3fb51ce26d","value":10}]}}},"16df7aa0-829e-4084-a489-2128aed1a91f":{"id":"16df7aa0-829e-4084-a489-2128aed1a91f","type":"default","pathType":"button","text":"<p style=\"text-align:left\">那你的生活经历肯定丰富多彩，经历了别人没有经历过的事情！</p>","transitions":{"是的，可惜同学们老欺负我":{"to":"63eb2f60-c768-41c3-82a6-9011b9f74eb3","actions":[{"id":"7dbb7f60-a11d-4e65-8c17-3922b54a25c9","action":"Subtract","variable":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","value":1},{"id":"efcc3e37-2c99-4c9e-b12c-2f6d32f684aa","action":"Subtract","variable":"4676adbf-c04e-471d-8b16-ce3fb51ce26d","value":1}]},"是的，但我学习也很好":{"to":"kaoshangdaxue","actions":[{"id":"218e6deb-dc8a-4f8a-beae-adcf4f1714ae","action":"Add","variable":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","value":2}]}}},"9c6ee63f-1070-4372-83b6-1e25764f1a1f":{"id":"9c6ee63f-1070-4372-83b6-1e25764f1a1f","type":"output","pathType":"button","text":"<p style=\"text-align:left\">恭喜你成为商人</p>","transitions":{}},"63eb2f60-c768-41c3-82a6-9011b9f74eb3":{"id":"63eb2f60-c768-41c3-82a6-9011b9f74eb3","type":"default","pathType":"button","text":"<p style=\"text-align:left\">进入社会也是不错的选择！</p>","transitions":{"我会努力赚钱的":{"to":"9c6ee63f-1070-4372-83b6-1e25764f1a1f","actions":[]},"生活真悲哀啊！我要奋力一搏":{"to":"blackshehui","actions":[]}}},"blackshehui":{"id":"blackshehui","type":"output","pathType":"button","text":"<p style=\"text-align:left\">恭喜你加入黑社会，前途无量！</p><p style=\"text-align:left\">The End.</p>","transitions":{}}};

var variables = {"74846864-6bbb-48a6-92f2-c179917309d5":{"id":"74846864-6bbb-48a6-92f2-c179917309d5","name":"年龄","type":"Number","initialValue":10,"value":10},"958d3e5c-dc64-4187-ae87-4ae4d940ca01":{"id":"958d3e5c-dc64-4187-ae87-4ae4d940ca01","name":"文科知识","type":"Number","initialValue":0,"value":0},"89be333a-42cc-451f-a730-cdd7c4732961":{"id":"89be333a-42cc-451f-a730-cdd7c4732961","name":"理科知识","type":"Number","initialValue":0,"value":0},"7b38f283-7c54-4a68-b9a0-a081d9be2d66":{"id":"7b38f283-7c54-4a68-b9a0-a081d9be2d66","name":"姓名","type":"Text","initialValue":"小朋友","value":"小朋友"},"4676adbf-c04e-471d-8b16-ce3fb51ce26d":{"id":"4676adbf-c04e-471d-8b16-ce3fb51ce26d","name":"金钱","type":"Number","initialValue":0,"value":0},"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7":{"id":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","name":"智商","type":"Number","initialValue":0,"value":0}};

var state = {"id":"start","type":"input","pathType":"text","text":"<p style=\"text-align:left\"></p><img src=https://pic3.zhimg.com/v2-d1f733345b0d11ea4d1bde0e2511dbc8_720w.jpg?source=172ae18b></img><p style=\"text-align:left\"></p><p style=\"text-align:left\">很高兴认识你，长得很可爱的小朋友！ 你叫什么名字？</p>","ignoreCapitalisation":true,"ignorePunctuation":true,"ignoreArticles":true,"transitions":{"":{"to":"b6e01ae0-7707-4178-b03a-b505ffb4e97e","actions":[{"id":"e8e1d563-f23c-4b04-966e-e3e653876657","action":"Set","variable":"7b38f283-7c54-4a68-b9a0-a081d9be2d66","value":"{{response}}"},{"id":"2ec90848-7a74-4204-8aab-7994264e838a","action":"Add","variable":"74846864-6bbb-48a6-92f2-c179917309d5","value":1}]},"我不告诉你":{"to":"293b95de-e353-4de7-a234-108a5c6f0dd1","actions":[{"id":"0433d622-8edf-49a0-ae85-1d8a0fb6f64b","action":"Add","variable":"958d3e5c-dc64-4187-ae87-4ae4d940ca01","value":1},{"id":"414ca016-aa46-457b-b5a8-4e837b9a1fff","action":"Subtract","variable":"89be333a-42cc-451f-a730-cdd7c4732961","value":1},{"id":"8df9d2a4-6db7-4f99-9b4f-04e7a8be4b69","action":"Add","variable":"d81aacb0-8d96-4bf8-aa87-9448a90bcdf7","value":2}]}}};

var lastInput = "";
var replaceContent = false;
var cursor = ">";
var errorMessages = [("我似乎没听懂你的回答！")];

$(document).ready(function () {
  const convertInput = (input) => {
    let string = input;
    if (state.pathType === "text") {
      if (state.ignoreCapitalisation) string = string.toLowerCase();
      if (state.ignorePunctuation)
        string = string.replace(
          /['!"#$%&\\'()\*+,\-\.\/:;<=>?@\[\\\]\^_`{|}~']/g,
          ""
        );
      if (state.ignoreArticles)
        string = string.replace(/(?:(the|a|an) +)/gi, "");
      string = string.replace(/\s+/g, " ");
    }
    return string;
  };

  const getText = (text) =>
    text.replace(/{{(.*?)}}/g, (match, p1) =>
      p1 === "response" ? `${lastInput}` : `${variables[p1].value}`
    );

  const trueValue = (value, type) => {
    let trueValue = value;
    if (typeof trueValue === "string") {
      trueValue = getText(trueValue);
      switch (type) {
        case "Number":
          trueValue = Number(trueValue);
          break;
        case "Boolean":
          trueValue = trueValue === "true";
          break;
        case "List":
          trueValue = value.split(",");
          break;
      }
    }
    return trueValue;
  };

  const doAction = (action) => {
    const variable = variables[action.variable];
    const value = trueValue(action.value, variable.type);
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
            variable.value * value;
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
  };

  const next = (input) => {
    const nextTransition =
      state.transitions[convertInput(input)] || state.transitions[""];
    if (nextTransition) {
      return [states[nextTransition.to], nextTransition.actions];
    } else {
      return [undefined, undefined];
    }
  };

  const met = (condition) => {
    const variable = variables[condition.variable];
    const v1 = variable.value;
    const v2 = trueValue(condition.value, variable.type);
    switch (condition.condition) {
      case "equal to":
        return v1 === v2;
      case "not equal to":
        return v1 !== v2;
      case "greater than":
        return v1 > v2;
      case "less than":
        return v1 < v2;
      case "greater than or equal to":
        return v1 >= v2;
      case "less than or equal to":
        return v1 <= v2;
      case "contains":
        return v1.includes(v2);
      case "doesn't contain":
        return !v1.includes(v2);
    }
  };

  const meets = (conditions) => {
    if (conditions.length === 0) return false;
    let groups = [[conditions[0]]];
    for (let i = 1; i < conditions.length; i++) {
      if (conditions[i].connective === "or") {
        groups.push([conditions[i]]);
      } else {
        groups[groups.length - 1].push(conditions[i]);
      }
    }
    for (let i = 0; i < groups.length; i++) {
      let satisfied = true;
      for (let c = 0; c < groups[i].length; c++) {
        if (!met(groups[i][c])) {
          satisfied = false;
          break;
        }
      }
      if (satisfied) {
        return true;
      }
    }
    return false;
  };

  const transition = (input) => {
    lastInput = input;
    $("#buttons").empty();
    const [nextState, actions] = next(input);
    if (nextState) {
      actions.forEach(doAction);
      state = nextState;
      if (state.pathType === "condition") {
        let nextState = states[state.transitions.default];
        let conditions = state.transitions.conditions;
        for (let i = 0; i < conditions.length; i++) {
          if (meets(conditions[i].requires)) {
            nextState = states[conditions[i].to];
            break;
          }
        }
        state = nextState;
      }
      if (replaceContent) {
        $("#output").empty();
      }
      $("#output").append(`<div class="previousResponse"><p>${cursor}${input}</p></div>`);
      $("#output").append(`<div class="node" id="${state.id}">${getText(state.text)}</div>`);
      if (state.type === "output") $("#input").hide();
      showInput(state);
    } else {
      $("#output").append(`<div class="previousResponse"><p>${cursor}${input}</p></div>`);
      $("#output").append(
        `<div class="node errorMessage"><p>${
          errorMessages[Math.floor(Math.random() * errorMessages.length)]
        }</p></div>`
      );
    }
    $("body").animate({
      scrollTop: $("body").prop("scrollHeight"),
    });
    $("#text").get(0).focus();
  };

  const showInput = () => {
    switch (state.pathType) {
      case "text":
        $("#buttons").hide();
        $("#textrow").show();
        $("#text")
          .val("")
          .unbind()
          .keypress((e) => {
            if (e.keyCode === 13) {
              transition(e.target.value.replace(/\s+/g, " ").trim());
              $("#text").val("");
            }
          })
        break;
      case "button":
        $("#textrow").hide();
        $("#buttons").show();
        Object.keys(state.transitions).forEach((name) => {
          $("#buttons").append(
            $(`<button>${name}</button>`)
              .attr({
                type: "button",
                id: name,
                value: name,
              })
              .click(() => transition(name))
          );
        });
        break;
    }
  };

  $("#output").html(`<div class="node" id="${state.id}">${getText(state.text)}</div>`);
  showInput();
});