"""SQL agent."""

from __future__ import annotations

from typing import (
    TYPE_CHECKING,
    Any,
    Dict,
    List,
    Literal,
    Optional,
    Sequence,
    Union,
    cast,
)

from langchain.agents.format_scratchpad import format_log_to_str
from langchain_core.messages import AIMessage, SystemMessage
from langchain_core.prompts import BasePromptTemplate, PromptTemplate
from langchain_core.prompts.chat import (
    ChatPromptTemplate,
    HumanMessagePromptTemplate,
    MessagesPlaceholder,
)

from langchain_community.agent_toolkits.sql.prompt import (
    SQL_FUNCTIONS_SUFFIX,
    SQL_PREFIX,
    SQL_SUFFIX,
)
from langchain_community.agent_toolkits.sql.toolkit import SQLDatabaseToolkit

from ohflow.interface.chains.table_mapping_chain import CustomTableMappingChain
from ohflow.interface.toolkits.ignite_database.tool import (
    InfoSQLDatabaseTool,
    ListSQLDatabaseTool,
)
from langchain_core.runnables import RunnablePassthrough
from ohflow.interface.toolkits.sqltookits import DremioSQLDatabaseToolkit
from ohflow.interface.toolkits.table_meta_data_tookits import DremioMetaDataToolkit

if TYPE_CHECKING:
    from langchain.agents.agent import AgentExecutor, BaseSingleActionAgent
    from langchain.agents.agent_types import AgentType
    from langchain_core.callbacks import BaseCallbackManager
    from langchain_core.language_models import BaseLanguageModel
    from langchain_core.tools import BaseTool

    from langchain_community.utilities.sql_database import SQLDatabase


def create_table_mapping_agent(
        llm: BaseLanguageModel,
        source_toolkit: Optional[DremioMetaDataToolkit] = None,
        target_toolkit: Optional[DremioMetaDataToolkit] = None,
        agent_type: Optional[
            Union[AgentType, Literal["openai-tools", "tool-calling"]]
        ] = None,
        callback_manager: Optional[BaseCallbackManager] = None,
        prefix: Optional[str] = None,
        suffix: Optional[str] = None,
        format_instructions: Optional[str] = None,
        top_k: int = 3,
        max_iterations: Optional[int] = 15,
        max_execution_time: Optional[float] = None,
        early_stopping_method: str = "force",
        verbose: bool = False,
        agent_executor_kwargs: Optional[Dict[str, Any]] = None,
        extra_tools: Sequence[BaseTool] = (),
        *,
        prompt: Optional[BasePromptTemplate] = None,
        output_parser=None,
        **kwargs: Any,
) -> AgentExecutor:
    """Construct a SQL agent from an LLM and toolkit or database.

    Args:
        llm: Language model to use for the agent. If agent_type is "tool-calling" then
            llm is expected to support tool calling.
        toolkit: SQLDatabaseToolkit for the agent to use. Must provide exactly one of
            'toolkit' or 'db'. Specify 'toolkit' if you want to use a different model
            for the agent and the toolkit.
        agent_type: One of "tool-calling", "openai-tools", "openai-functions", or
            "zero-shot-react-description". Defaults to "zero-shot-react-description".
            "tool-calling" is recommended over the legacy "openai-tools" and
            "openai-functions" types.
        callback_manager: DEPRECATED. Pass "callbacks" key into 'agent_executor_kwargs'
            instead to pass constructor callbacks to AgentExecutor.
        prefix: Prompt prefix string. Must contain variables "top_k" and "dialect".
        suffix: Prompt suffix string. Default depends on agent type.
        format_instructions: Formatting instructions to pass to
            ZeroShotAgent.create_prompt() when 'agent_type' is
            "zero-shot-react-description". Otherwise ignored.        
        top_k: Number of rows to query for by default.
        max_iterations: Passed to AgentExecutor init.
        max_execution_time: Passed to AgentExecutor init.
        early_stopping_method: Passed to AgentExecutor init.
        verbose: AgentExecutor verbosity.
        agent_executor_kwargs: Arbitrary additional AgentExecutor args.
        extra_tools: Additional tools to give to agent on top of the ones that come with
            SQLDatabaseToolkit.
        db: SQLDatabase from which to create a SQLDatabaseToolkit. Toolkit is created
            using 'db' and 'llm'. Must provide exactly one of 'db' or 'toolkit'.
        prompt: Complete agent prompt. prompt and {prefix, suffix, format_instructions,
            input_variables} are mutually exclusive.
        **kwargs: Arbitrary additional Agent args.

    Returns:
        An AgentExecutor with the specified agent_type agent.

    Example:

        .. code-block:: python

        from langchain_openai import ChatOpenAI
        from langchain_community.agent_toolkits import create_sql_agent
        from langchain_community.utilities import SQLDatabase

        db = SQLDatabase.from_uri("sqlite:///Chinook.db")
        llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0)
        agent_executor = create_sql_agent(llm, db=db, agent_type="tool-calling", verbose=True)

    """  # noqa: E501
    from langchain.agents import (
        create_openai_functions_agent,
        create_openai_tools_agent,
        create_react_agent,
        create_tool_calling_agent,
    )
    from langchain.agents.agent import (
        AgentExecutor,
        RunnableAgent,
        RunnableMultiActionAgent,
    )
    if source_toolkit is None:
        raise ValueError(
            "Must provide exactly one of 'source_toolkit' or 'source_db'. Received neither."
        )
    if target_toolkit is None:
        raise ValueError(
            "Must provide exactly one of 'target_toolkit' or 'target_db'. Received neither."
        )
    toolkit = target_toolkit
    tools = toolkit.get_tools() + list(extra_tools)
    if prefix is None or not prefix:
        prefix = '\n从所给标准库的表中选出与业务表的字段可以映射的字段，只需返回字段中文名，允许多选，若无匹配字段，则回答无'

    if prompt is None:
        prefix = prefix.format(dialect=toolkit.dialect, top_k=top_k)
    else:
        if "top_k" in prompt.input_variables:
            prompt = prompt.partial(top_k=str(top_k))
        if "dialect" in prompt.input_variables:
            prompt = prompt.partial(dialect=toolkit.dialect)
        if any(key in prompt.input_variables for key in ["table_info", "table_names"]):
            db_context = toolkit.get_context()
            if "table_info" in prompt.input_variables:
                prompt = prompt.partial(table_info=db_context["table_info"])
                tools = [
                    tool for tool in tools if not isinstance(tool, InfoSQLDatabaseTool)
                ]
            if "table_names" in prompt.input_variables:
                prompt = prompt.partial(table_names=db_context["table_names"])
                tools = [
                    tool for tool in tools if not isinstance(tool, ListSQLDatabaseTool)
                ]

    if agent_type in ("table_mapping", "field_mapping"):
        if prompt is None:
            messages = [
                SystemMessage(content=cast(str, prefix)),
                HumanMessagePromptTemplate.from_template("{input}"),
                AIMessage(content=suffix or "我开始审慎的进行业务理解和映射。答案是"),
                MessagesPlaceholder(variable_name="agent_scratchpad"),
            ]
            prompt = ChatPromptTemplate.from_messages(messages)
        if agent_type == "table_mapping":
            runnable = create_openai_functions_agent(llm, tools, prompt)  # type: ignore
        else:
            runnable = create_openai_functions_agent(llm, tools, prompt)  # type: ignore
        agent = RunnableAgent(  # type: ignore[assignment]
            runnable=runnable,
            input_keys_arg=["input"],
            return_keys_arg=["output"],
            **kwargs,
        )
    elif agent_type in ("table_and_fields_mapping", ""):

        mappingChain = CustomTableMappingChain(llm=llm,
                                               source_toolkit=source_toolkit,
                                               target_toolkit=target_toolkit,
                                               table_prompt_prefix=prefix,
                                               field_prompt_prefix=suffix)  # type: ignore
        return mappingChain

    else:
        raise ValueError(
            f"Agent type {agent_type} not supported at the moment. Must be one of "
            "'tool-calling', 'openai-tools', 'openai-functions', or "
            "'zero-shot-react-description'."
        )

    return AgentExecutor(
        name="Dremio Table Mapping Agent Executor",
        agent=agent,
        tools=tools,
        callback_manager=callback_manager,
        verbose=verbose,
        max_iterations=max_iterations,
        max_execution_time=max_execution_time,
        early_stopping_method=early_stopping_method,
        **(agent_executor_kwargs or {}),
    )
