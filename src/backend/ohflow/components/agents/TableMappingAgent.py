from langchain.agents import AgentExecutor, AgentType
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain_community.agent_toolkits.sql.base import create_sql_agent
from langchain_community.utilities import SQLDatabase
from langflow.template import Output
from langflow.base.agents.agent import LCAgentComponent
from langflow.inputs import MessageTextInput, HandleInput, MultilineInput, FileInput, DropdownInput
from ohflow.interface.agents.create_sql_agent import create_dremio_sql_agent
from ohflow.interface.agents.create_table_mapping_agent import create_table_mapping_agent
from ohflow.interface.agents.custom import CustomReActSingleInputOutputParser
from ohflow.interface.toolkits.sqltookits import DremioSQLDatabaseToolkit
from langflow.schema.message import Message
from langflow.utils.constants import MESSAGE_SENDER_AI
from ohflow.interface.toolkits.table_meta_data_tookits import DremioMetaDataToolkit


class TableMappingAgentComponent(LCAgentComponent):
    display_name = "TableMappingAgent"
    description = "Construct an Table Mapping agent from an LLM and tools."
    name = "TableMappingAgent"

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
        DropdownInput(
            name="agent_type",
            display_name="Agent type",
            options=["table_mapping", "field_mapping", "table_and_fields_mapping", "zero-shot-react-description", "openai-functions"],
            value="table_and_fields_mapping",
            advanced=True,
        ),
        FileInput(
            name="std_tables_info_file",
            display_name="std tables info jsonl file",
            file_types=["json", "yaml", "jsonl"],
            required=False,
            info="包含标准库的表列表，必须包含表名和中文名，字段名，字段中文名",
        ),
    ]

    outputs = [
        Output(display_name="Agent", name="agent", method="build_agent"),
        Output(display_name="Response", name="response", method="message_response"),
        Output(display_name="MappingTargetTable", name="mappingTableOny", method="mapping_target_table"),
    ]

    def build_agent(self, agent_type: str = '') -> AgentExecutor:
        agent_description = self.agent_description # table mapping prompt
        agent_args = self.get_agent_kwargs()
        agent_args["max_iterations"] = agent_args["agent_executor_kwargs"]["max_iterations"]
        agent_args["agent_type"] = agent_type or self.agent_type

        if self.agent_type.endswith('mapping'):
            toolkit = DremioMetaDataToolkit(db=self.db, meta_data_file=self.std_tables_info_file)
        else:
            toolkit = DremioSQLDatabaseToolkit(db=self.db, llm=self.llm)

        del agent_args["agent_executor_kwargs"]["max_iterations"]
        output_parser = CustomReActSingleInputOutputParser()
        return create_table_mapping_agent(llm=self.llm,
                                toolkit=toolkit,
                                extra_tools=self.extra_tools or [],
                                prefix=self.prefix,
                                agent_description = agent_description,
                                output_parser=output_parser,
                                **agent_args)

    async def message_response(self) -> Message:
        """Run the agent and return the response."""
        agent = self.build_agent()
        if isinstance(agent, AgentExecutor):
            result = await self.run_agent(agent=agent)
        else:
            result = agent.invoke({"input": self.input_value})

        if isinstance(result, list):
            result = "\n".join([result_dict["text"] for result_dict in result])
        if isinstance(result, dict):
            result = result['output']

        message = Message(text=result, sender=MESSAGE_SENDER_AI)

        self.status = message
        return message

    async def mapping_target_table(self) -> Message:
        """Run the agent and return the response."""
        agent = self.build_agent(agent_type='table_mapping')
        if isinstance(agent, AgentExecutor):
            result = await self.run_agent(agent=agent)
        else:
            result = agent.invoke({"input": self.input_value})

        if isinstance(result, list):
            result = "\n".join([result_dict["text"] for result_dict in result])
        if isinstance(result, dict):
            result = result['output']

        message = Message(text=result, sender=MESSAGE_SENDER_AI)

        self.status = message
        return message


