from langchain.agents import AgentExecutor
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain_community.agent_toolkits.sql.base import create_sql_agent
from langchain_community.utilities import SQLDatabase

from langflow.base.agents.agent import LCAgentComponent
from langflow.inputs import MessageTextInput, HandleInput, PromptInput
from ohflow.interface.agents.create_sql_agent import create_dremio_sql_agent
from ohflow.interface.agents.custom import CustomReActSingleInputOutputParser
from ohflow.interface.toolkits.sqltookits import DremioSQLDatabaseToolkit


class DremioSQLAgentComponent(LCAgentComponent):
    display_name = "DremioSQLAgent"
    description = "Construct an SQL agent from an LLM and tools."
    name = "DremioSQLAgent"

    inputs = LCAgentComponent._base_inputs + [
        HandleInput(name="llm", display_name="Language Model", input_types=["LanguageModel"], required=True),
        MessageTextInput(name="agent_description", display_name="Agent description"),
        HandleInput(name="db", display_name="SQLDatabase", input_types=["SQLDatabase"], required=True),
        HandleInput(
            name="extra_tools",
            display_name="Extra Tools",
            input_types=["Tool", "BaseTool"],
            is_list=True,
            advanced=True,
        ),
        PromptInput(name="prompt", display_name="Template", value=None),
    ]

    def build_agent(self) -> AgentExecutor:
        agent_description = self.agent_description
        toolkit = DremioSQLDatabaseToolkit(db=self.db, llm=self.llm)
        agent_args = self.get_agent_kwargs()
        agent_args["max_iterations"] = agent_args["agent_executor_kwargs"]["max_iterations"]
        del agent_args["agent_executor_kwargs"]["max_iterations"]
        output_parser = CustomReActSingleInputOutputParser()
        return create_dremio_sql_agent(llm=self.llm,
                                toolkit=toolkit,
                                extra_tools=self.extra_tools or [],
                                prompt=self.prompt,
                                prefix=agent_description,
                                output_parser=output_parser,
                                **agent_args)
