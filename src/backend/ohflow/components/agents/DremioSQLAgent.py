from langchain.agents import AgentExecutor
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain_community.agent_toolkits.sql.base import create_sql_agent
from langchain_community.utilities import SQLDatabase
from langflow.template import Output
from langflow.base.agents.agent import LCAgentComponent
from langflow.inputs import MessageTextInput, HandleInput, MultilineInput
from ohflow.interface.agents.create_sql_agent import create_dremio_sql_agent
from ohflow.interface.agents.custom import CustomReActSingleInputOutputParser
from ohflow.interface.toolkits.sqltookits import DremioSQLDatabaseToolkit
from langflow.schema.message import Message
from langflow.utils.constants import MESSAGE_SENDER_AI


class DremioSQLAgentComponent(LCAgentComponent):
    display_name = "DremioSQLAgent"
    description = "Construct an SQL agent from an LLM and tools."
    name = "DremioSQLAgent"

    inputs = LCAgentComponent._base_inputs + [
        HandleInput(name="llm", display_name="Language Model", input_types=["LanguageModel"], required=True),
        HandleInput(name="db", display_name="SQLDatabase", input_types=["SQLDatabase"], required=True),
        HandleInput(
            name="extra_tools",
            display_name="Extra Tools",
            input_types=["Tool", "BaseTool"],
            is_list=True,
            advanced=True,
        ),
        MultilineInput(
            name="prefix",
            display_name="prefix",
            info="Prompt prefix string. Must contain variables top_k and dialect",
        ),
    ]

    outputs = [
        Output(display_name="Agent", name="agent", method="build_agent"),
        Output(display_name="Response", name="response", method="message_response"),
        Output(display_name="QuerySQL", name="querySQL", method="query_sql_response"),
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
                                prefix=self.prefix,
                                output_parser=output_parser,
                                **agent_args)

    async def message_response(self) -> Message:
        """Run the agent and return the response."""
        agent = self.build_agent()
        result: Message = await self.run_agent(agent=agent)
        print('DremioSQLAgent:message_response')
        print(type(result))
        if isinstance(result, list):
            output = "\n".join([result_dict["text"] for result_dict in result])
        elif isinstance(result, dict):
            output = result["text"]
        elif isinstance(result, str):
            output = result
        else: # is Message
            output = str(result.text)
        message = Message(text=output, sender=MESSAGE_SENDER_AI)
        has_sql = hasattr(self.db,'last_sql_query')
        if has_sql:
            message.sql = self.db.last_sql_query
        self.status = message
        return message

    def query_sql_response(self) -> Message:
        """Run the agent and return the response."""
        has_sql = hasattr(self.db,'last_sql_query')
        if has_sql:
            sql = self.db.last_sql_query
        else:
            sql = ""
        message = Message(text=sql, sender=MESSAGE_SENDER_AI)
        self.status = message
        return message
