import { useState, useEffect } from "react";
import { Container, Button, Code, Space, Textarea, Select } from "@mantine/core";
import { IconNorthStar, IconRun, IconPlus } from "@tabler/icons";
import hostMap from "../../../wujie-config/hostMap";

export default function Debug() {
  const api_base_url = hostMap('workflow-api');
  const [input, setInput] = useState("{ }");
  const [output, setOutput] = useState("");

  const [triggers, setTriggers] = useState([]);
  const [searchValue, onSearchChange] = useState('');

  //Load Triggers from API
  useEffect(() => {
    fetch(api_base_url+"/triggers/")
      .then((res) => res.json())
      .then((json) => {
        const names = json.map((x) => { return { value: x.shortcode , label: x.name }});
        setTriggers(names);
      });
  }, []);

  function initializeDatabase() {
    fetch(api_base_url+"/debug/initializeDatabase/")
      .then(function (response) {
        return response.text();
      })
      .then(function (data) {
        console.log(data); // this will be a string
        setOutput(data);
      });
  }

  function processOneJob() {
    fetch(api_base_url+"/jobs/process_next_job/")
      .then(function (response) {
        return response.text();
      })
      .then(function (data) {
        console.log(data); // this will be a string
        setOutput(data);
      });
  }

  function triggerNewJob() {
    fetch(api_base_url+"/triggers/"+searchValue, {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        body: input,
      })
      .then(function (response) {
        return response.text();
      })
      .then(function (data) {
        console.log(data); // this will be a string
        setOutput(data);
      });
  }

  return (
    <Container style={{ padding: 20 }}>
      <Button
        leftIcon={<IconNorthStar />}
        color="green"
        onClick={initializeDatabase}
      >
        Initialize database
      </Button>
      <Space h="md" />
      <Select label='Select Trigger' value={searchValue} onChange={onSearchChange} data={triggers} />
      <Textarea
         onChange={(event) => setInput(event.currentTarget.value)}
         name="data"
         label='Input Data'
         placeholder='Json Input 数据'
         autosize
         minRows={4}
         maxRows={12}
       />
       <br />
      <Button leftIcon={<IconPlus />} color="pink" onClick={triggerNewJob}>
        Create New Job
      </Button>
      <br />
      <br />
      <Button leftIcon={<IconRun />} onClick={processOneJob}>
        Process One Job
      </Button>
      <br />
      <Space h="md" />
      Output:
      <Code block minRows={3} >{output}</Code>
    </Container>
  );
}
