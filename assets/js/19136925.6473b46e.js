"use strict";(self.webpackChunklangflow_docs=self.webpackChunklangflow_docs||[]).push([[9141],{9813:(o,e,n)=>{n.r(e),n.d(e,{assets:()=>r,contentTitle:()=>c,default:()=>m,frontMatter:()=>i,metadata:()=>l,toc:()=>a});var t=n(4848),s=n(8453);const i={title:"Contribute components",sidebar_position:4,slug:"/contributing-components"},c=void 0,l={id:"Contributing/contributing-components",title:"Contribute components",description:"New components are added as objects of the\xa0CustomComponent\xa0class.",source:"@site/docs/Contributing/contributing-components.md",sourceDirName:"Contributing",slug:"/contributing-components",permalink:"/contributing-components",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:4,frontMatter:{title:"Contribute components",sidebar_position:4,slug:"/contributing-components"},sidebar:"defaultSidebar",previous:{title:"Ask for help on the Discussions board",permalink:"/contributing-github-discussions"},next:{title:"Join the Langflow community",permalink:"/contributing-community"}},r={},a=[{value:"Contribute an example component to Langflow",id:"contribute-an-example-component-to-langflow",level:3}];function d(o){const e={a:"a",code:"code",h3:"h3",li:"li",ol:"ol",p:"p",strong:"strong",...(0,s.R)(),...o.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsxs)(e.p,{children:["New components are added as objects of the\xa0",(0,t.jsx)(e.a,{href:"https://github.com/langflow-ai/langflow/blob/dev/src/backend/base/langflow/custom/custom_component/custom_component.py",children:"CustomComponent"}),"\xa0class."]}),"\n",(0,t.jsxs)(e.p,{children:["Any dependencies are added to the\xa0",(0,t.jsx)(e.a,{href:"https://github.com/langflow-ai/langflow/blob/main/pyproject.toml#L148",children:"pyproject.toml"}),"\xa0file."]}),"\n",(0,t.jsx)(e.h3,{id:"contribute-an-example-component-to-langflow",children:"Contribute an example component to Langflow"}),"\n",(0,t.jsxs)(e.p,{children:["Anyone can contribute an example component. For example, if you created a new document loader called\xa0",(0,t.jsx)(e.strong,{children:"MyCustomDocumentLoader"}),", you can follow these steps to contribute it to Langflow."]}),"\n",(0,t.jsxs)(e.ol,{children:["\n",(0,t.jsxs)(e.li,{children:["Write your loader as an object of the\xa0",(0,t.jsx)(e.a,{href:"https://github.com/langflow-ai/langflow/blob/dev/src/backend/base/langflow/custom/custom_component/custom_component.py",children:"CustomComponent"}),"\xa0class. You'll create a new class,\xa0",(0,t.jsx)(e.code,{children:"MyCustomDocumentLoader"}),", that will inherit from\xa0",(0,t.jsx)(e.code,{children:"CustomComponent"}),"\xa0and override the base class's methods."]}),"\n",(0,t.jsxs)(e.li,{children:["Define optional attributes like\xa0",(0,t.jsx)(e.code,{children:"display_name"}),",\xa0",(0,t.jsx)(e.code,{children:"description"}),", and\xa0",(0,t.jsx)(e.code,{children:"documentation"}),"\xa0to provide information about your custom component."]}),"\n",(0,t.jsxs)(e.li,{children:["Implement the\xa0",(0,t.jsx)(e.code,{children:"build_config"}),"\xa0method to define the configuration options for your custom component."]}),"\n",(0,t.jsxs)(e.li,{children:["Implement the\xa0",(0,t.jsx)(e.code,{children:"build"}),"\xa0method to define the logic for taking input parameters specified in the\xa0",(0,t.jsx)(e.code,{children:"build_config"}),"\xa0method and returning the desired output."]}),"\n",(0,t.jsxs)(e.li,{children:["Add the code to the\xa0",(0,t.jsx)(e.a,{href:"https://github.com/langflow-ai/langflow/tree/dev/src/backend/base/langflow/components",children:"/components/documentloaders"}),"\xa0folder."]}),"\n",(0,t.jsxs)(e.li,{children:["Add the dependency to\xa0",(0,t.jsxs)(e.a,{href:"https://github.com/langflow-ai/langflow/blob/dev/src/backend/base/langflow/components/documentloaders/__init__.py",children:["/documentloaders/",(0,t.jsx)(e.strong,{children:"init"}),".py"]}),"\xa0as\xa0",(0,t.jsx)(e.code,{children:"from .MyCustomDocumentLoader import MyCustomDocumentLoader"}),"."]}),"\n",(0,t.jsxs)(e.li,{children:["Add any new dependencies to the\xa0",(0,t.jsx)(e.a,{href:"https://github.com/langflow-ai/langflow/blob/main/pyproject.toml#L148",children:"pyproject.toml"}),"\xa0file."]}),"\n",(0,t.jsxs)(e.li,{children:["Submit documentation for your component. For this example, you'd submit documentation to the\xa0",(0,t.jsx)(e.a,{href:"https://github.com/langflow-ai/langflow/blob/main/docs/docs/Components/components-loaders.md",children:"loaders page"}),"."]}),"\n",(0,t.jsx)(e.li,{children:"Submit your changes as a pull request. The Langflow team will have a look, suggest changes, and add your component to Langflow."}),"\n"]})]})}function m(o={}){const{wrapper:e}={...(0,s.R)(),...o.components};return e?(0,t.jsx)(e,{...o,children:(0,t.jsx)(d,{...o})}):d(o)}},8453:(o,e,n)=>{n.d(e,{R:()=>c,x:()=>l});var t=n(6540);const s={},i=t.createContext(s);function c(o){const e=t.useContext(i);return t.useMemo((function(){return"function"==typeof o?o(e):{...e,...o}}),[e,o])}function l(o){let e;return e=o.disableParentContext?"function"==typeof o.components?o.components(s):o.components||s:c(o.components),t.createElement(i.Provider,{value:e},o.children)}}}]);