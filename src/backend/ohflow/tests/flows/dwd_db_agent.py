from langflow.load import run_flow_from_json
TWEAKS = {
    "DeepseekLLM-psNqL": {},
    "ChatInput-eJtsc": {},
    "TextInput-GmcDE": {},
    "Prompt-wztHN": {},
    "IgniteDatabase-CLhhm": {},
    "DremioSQLAgent-m6gQ1": {},
    "ChatOutput-TfiLo": {},
    "Prompt-4juhI": {},
    "TextOutput-ZDukc": {}
}

result = run_flow_from_json(flow="_DatabaseAgent.json",
                            input_value="出院结算费用中医保支付的费用总和",
                            fallback_to_env_vars=True, # False by default
                            tweaks=TWEAKS)

print(result)