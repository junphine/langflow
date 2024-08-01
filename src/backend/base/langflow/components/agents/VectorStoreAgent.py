from langchain.agents import AgentExecutor, create_vectorstore_agent
from langchain.agents.agent_toolkits.vectorstore.toolkit import VectorStoreToolkit
from langflow.base.agents.agent import LCAgentComponent
from langflow.inputs import HandleInput


class VectorStoreAgentComponent(LCAgentComponent):
    display_name = "VectorStoreAgent"
    description = "Construct an agent from a Vector Store."
    name = "VectorStoreAgent"

<<<<<<< HEAD
    def build_config(self):
        return {
            "llm": {"display_name": "LLM"},
            "vector_store_toolkit": {"display_name": "Vector Store Toolkit"},
        }
=======
    inputs = LCAgentComponent._base_inputs + [
        HandleInput(name="llm", display_name="Language Model", input_types=["LanguageModel"], required=True),
        HandleInput(name="vectorstore", display_name="Vector Store", input_types=["VectorStoreInfo"], required=True),
    ]
>>>>>>> 34bb9d91301c2292ca12d53ec297ef106a30dbf0

    def build_agent(self) -> AgentExecutor:
        toolkit = VectorStoreToolkit(vectorstore_info=self.vectorstore, llm=self.llm)
        return create_vectorstore_agent(llm=self.llm, toolkit=toolkit, **self.get_agent_kwargs())
