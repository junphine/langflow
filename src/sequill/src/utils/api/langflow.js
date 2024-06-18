const api_base_url = 'http://127.0.0.1:5678';


export default function  gptChat(story,node,variables) {
    const label = node.data.label;
    const texts = node.data.text;
    const params = 'token=52bc3a62-080c-4048-8c2f-20db1f595b55'
    const states = {};
    for(let id in variables){
      const v = variables[id]
      states[v.name] = v.value;
    }

    const characters = story.graph.characters;    
    
    return fetch(api_base_url+"/api/v2/chat?"+params, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({name:story.title, description:story.blurb, data:texts, label, states, characters}),  
    })
    .then(r=>r.json());

  };