import json

from langchain import OpenAI, PromptTemplate
from langchain.agents.agent_toolkits import VectorStoreInfo
from langchain.agents.agent_toolkits.base import BaseToolkit
from langchain.base_language import BaseLanguageModel
from langchain.callbacks.manager import CallbackManagerForToolRun, AsyncCallbackManagerForToolRun
from langchain.chains import RetrievalQAWithSourcesChain
from langchain.tools import BaseTool
from langchain.tools.vectorstore.tool import VectorStoreQAWithSourcesTool, VectorStoreQATool
from langchain_community.tools.vectorstore.tool import BaseVectorStoreTool

from ohflow.interface.chains.custom import CombineChineseDocsChain
from typing import Dict, Optional, Type, Union, List
from pydantic import BaseModel, Field


template = """给定一个长文档的以下摘录部分和一个问题，使用参考(“SOURCES”)创建一个最终答案。
如果你不知道答案，就说你不知道。不要试图编造答案。
并且总是在你的答案中返回“SOURCES”部分。

Question: 哪个州/国家的法律管辖合同的解释?
=========
Content:本协议受英国法律管辖，双方就与本协议有关的任何争议(合同或非合同)接受英国法院的专属管辖权，但任何一方都可以向任何法院申请禁令或其他救济以保护其知识产权。
Source:28-pl
Content:未能或延迟行使本协议项下的任何权利或救济不构成对该等(或任何其他)权利或救济的放弃。本协议的任何条款(或部分条款)的无效、非法或不可执行不影响剩余条款(如有)和本协议的继续有效。除另有明确规定外，本协议中的任何内容均不得在双方之间建立任何形式的代理、合伙或合资企业。无第三方受益人。
Source:30-pl
Content:(b)如果谷歌真诚地认为分销商违反或导致谷歌违反任何反贿赂法律(定义见第8.5条)，或该等违反有合理可能发生，
Source:4-pl
=========
Final Answer:本协议受英国法律管辖。
SOURCES:28-pl

Question: 总统对迈克尔·杰克逊说了什么?
=========
Content：议长女士，副总统女士，第一夫人和第二先生。国会成员和内阁成员。最高法院的法官。我的美国同胞们。去年，COVID-19使我们分离。今年我们终于又在一起了。今晚，我们以民主党、共和党和无党派人士的身份相聚。但最重要的是作为美国人。我们对彼此负有责任，对美国人民负有责任，对宪法负有责任。以坚定的决心，自由将永远战胜暴政。六天前，俄罗斯的弗拉基米尔·普京试图动摇自由世界的基础，认为他可以让世界屈服于他的威胁方式。但他严重失算了。他以为他可以滚进乌克兰，世界就会翻个底朝天。相反，他遇到了一堵他从未想象过的力量之墙。他会见了乌克兰人民。从泽连斯基总统到每一个乌克兰人，他们的无畏、勇气和决心鼓舞着世界。成群的市民用身体挡住坦克。从学生到退休教师，每个人都成为保卫祖国的士兵。
Source:0我们不会停止。我们为COVID-19损失惨重。与他人相处的时间。最糟糕的是，很多人失去了生命。让我们利用这一刻重新开始。让我们停止将COVID-19视为党派分界线，看看它是什么:一种可怕的疾病。让我们停止视彼此为敌人，并开始正视彼此的真实面目:美国同胞。我们无法改变我们之间的分歧。但我们可以改变在COVID-19和我们必须共同面对的其他问题上前进的方式。在威尔伯特·莫拉警官和他的搭档杰森·里维拉警官的葬礼举行几天后，我最近访问了纽约市警察局。他们当时正在处理911报警电话，一名男子用一把偷来的枪开枪打死了他们。莫拉警官当时27岁。里维拉警官当时22岁。他们都是多米尼加裔美国人，在同一条街上长大，后来选择当警察巡逻。我与他们的家人交谈，告诉他们我们永远感激他们的牺牲，我们将继续他们的使命，恢复每个社区应得的信任和安全。
Source:2-pl
Content:4-pl
Content:自豪的乌克兰人民已经独立了30年，他们一再表明，他们不会容忍任何试图让他们的国家倒退的人。我要对所有美国人说，我会像我一直承诺的那样，对你们诚实。一个俄罗斯独裁者入侵外国，其代价遍及全球。我将采取强有力的行动，确保制裁的痛苦是针对俄罗斯经济的。我将使用我们所掌握的一切手段来保护美国的企业和消费者。今晚，我可以宣布，美国已经与其他30个国家合作，从世界各地的石油储备中释放了6000万桶石油。美国将领导这一努力，从我们自己的战略石油储备中释放3000万桶石油。如果有必要，我们随时准备与我们的盟友团结起来，采取更多行动。这些措施将有助于降低国内的天然气价格。我知道关于正在发生的事情的新闻看起来很令人担忧。但是我想让你知道，我们会没事的。
Source:5-pl
=========
Final Answer: 总统没有提到迈克尔·杰克逊。
SOURCES:

Question: {question}
=========
{summaries}
=========
Final Answer:"""
PROMPT = PromptTemplate(template=template, input_variables=["summaries", "question"])


def custom_prep_outputs(
        self,
        inputs: Dict[str, str],
        outputs: Dict[str, str],
        return_only_outputs: bool = False,
) -> Dict[str, str]:
    """Validate and prep outputs."""
    self._validate_outputs(outputs)
    if self.memory is not None:
        self.memory.save_context(inputs, outputs)
    if return_only_outputs:
        return outputs
    else:
        return {**inputs, **outputs}

class VectorStoreChineseSourceQATool(BaseVectorStoreTool, BaseTool):
    """Tool for the VectorDBQAWithSources chain."""

    @staticmethod
    def get_description(name: str, description: str) -> str:
        template: str = (
            "It is Chinese tool useful for when you need to answer questions about {name} and the properties "
            "used to construct the answer. "
            "Whenever you need answer chinese information about {description} "
            "you should ALWAYS use this. "
            " Input should be a fully formed question. "
        )
        return template.format(name=name, description=description)

    def _run(
            self,
            query: str,
            run_manager: Optional[CallbackManagerForToolRun] = None,
    ) -> str:
        """Use the tool."""

        chain = RetrievalQAWithSourcesChain.from_chain_type(
            self.llm, retriever=self.vectorstore.as_retriever(), chain_type_kwargs={'prompt':PROMPT}
        )
        if 'source' not in query and '来源' not in query:
            combine_doc_chain = CombineChineseDocsChain.initialize(
                self.llm, 'stuff'
            )
            chain.combine_documents_chain = combine_doc_chain

        RetrievalQAWithSourcesChain.prep_outputs = custom_prep_outputs

        return json.dumps(chain({chain.question_key: query}, return_only_outputs=True),encodings='utf-8',ensure_ascii=False)

    async def _arun(
            self,
            query: str,
            run_manager: Optional[AsyncCallbackManagerForToolRun] = None,
    ) -> str:
        """Use the tool asynchronously."""
        raise NotImplementedError("VectorStoreQAWithSourcesTool does not support async")


class VectorStoreHealthToolkit(BaseToolkit):
    """Toolkit for interacting with a vector store."""

    vectorstore_info: VectorStoreInfo = Field(exclude=True)
    llm: BaseLanguageModel = Field(default_factory=lambda: OpenAI(temperature=0))

    class Config:
        """Configuration for this pydantic object."""

        arbitrary_types_allowed = True

    def get_tools(self) -> List[BaseTool]:
        """Get the tools in the toolkit."""
        description = VectorStoreQATool.get_description(
            self.vectorstore_info.name, self.vectorstore_info.description
        )
        qa_tool = VectorStoreQATool(
            name=self.vectorstore_info.name,
            description=description,
            vectorstore=self.vectorstore_info.vectorstore,
            llm=self.llm,
        )
        description = VectorStoreChineseSourceQATool.get_description(
            self.vectorstore_info.name, self.vectorstore_info.description
        )
        qa_with_sources_tool = VectorStoreChineseSourceQATool(
            name=f"{self.vectorstore_info.name}_with_chinese",
            description=description,
            vectorstore=self.vectorstore_info.vectorstore,
            llm=self.llm,
        )
        # qa_with_sources_tool
        return [qa_tool,qa_with_sources_tool]