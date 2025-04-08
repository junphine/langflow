from langchain.agents import AgentExecutor, AgentType
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langchain_community.agent_toolkits.sql.base import create_sql_agent
from langchain_community.utilities import SQLDatabase
from langchain_core.prompts import PromptTemplate

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
        HandleInput(name="source_db", display_name="Source SQLDatabase", input_types=["SQLDatabase"], required=True),
        HandleInput(name="target_db", display_name="Target SQLDatabase", input_types=["SQLDatabase"], required=True),
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
            info="Prompt prefix string. Must contain variables top_k and dialect,Used for table mapping",
        ),
        MultilineInput(
            name="prompt",
            display_name="prompt",
            info="Prompt string. Must contain variables table_info and table_names",
        ),
        MultilineInput(
            name="suffix",
            display_name="suffix",
            info="Prompt suffix string. Used for field mapping",
        ),
        DropdownInput(
            name="agent_type",
            display_name="Agent type",
            options=["table_mapping", "field_mapping", "table_and_fields_mapping"],
            value="table_and_fields_mapping",
            advanced=True,
        ),
        FileInput(
            name="source_tables_info_file",
            display_name="source tables info file",
            file_types=["json", "csv", "tsv"],
            required=False,
            info="包含来源库的表列表，必须包含表名TABLE_NAME,COLUMN_NAME,COLUMN_COMMENT",
        ),
        FileInput(
            name="target_tables_info_file",
            display_name="target tables info file",
            file_types=["json", "csv", "tsv"],
            required=False,
            info="包含标准库的表列表，必须包含表名TABLE_NAME",
        ),
    ]

    outputs = [
        Output(display_name="Agent", name="agent", method="build_agent"),
        Output(display_name="Response", name="response", method="message_response"),
        Output(display_name="MappingTargetTable", name="mappingTableOny", method="mapping_target_table"),
    ]

    def build_agent(self, agent_type: str = '') -> AgentExecutor:

        agent_args = self.get_agent_kwargs()
        agent_args["max_iterations"] = agent_args["agent_executor_kwargs"]["max_iterations"]
        agent_args["agent_type"] = agent_type or self.agent_type

        source_toolkit = DremioMetaDataToolkit(db=self.source_db, meta_data_file=self.source_tables_info_file)

        target_toolkit = DremioMetaDataToolkit(db=self.target_db, meta_data_file=self.target_tables_info_file)

        del agent_args["agent_executor_kwargs"]["max_iterations"]
        prompt = None
        if self.prompt:
            prompt = PromptTemplate.from_template(self.prompt)
        output_parser = CustomReActSingleInputOutputParser()
        return create_table_mapping_agent(llm=self.llm,
                                source_toolkit=source_toolkit,
                                target_toolkit=target_toolkit,
                                extra_tools=self.extra_tools or [],
                                prefix=self.prefix,
                                prompt = prompt,
                                suffix = self.suffix,
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


