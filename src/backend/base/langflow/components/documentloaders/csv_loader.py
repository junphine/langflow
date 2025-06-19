from pathlib import Path

from langflow.inputs import MessageInput
from langflow.io import BoolInput, FileInput, Output
from langflow.custom import Component
from langflow.io import MessageTextInput, Output
from langflow.schema import Data
from langflow.schema.image import Image
import csv
from io import StringIO


class CSVLoaderComponent(Component):
    name = "CSVLoader"
    display_name = "CSV Loader"
    description = "Load a CSV file to a list of Data objects"
    icon = "file-spreadsheet"

    inputs = [
        FileInput(
            name="path",
            display_name="Path",
            file_types=['csv','tsv','txt','md'],
            info=f"Supported file types: {', '.join(['csv','tsv','txt','md'])}",
        ),
        MessageInput(
            name="message",
            display_name="File Message",
            info="The Message with files object to convert to a Data object",
        ),
        BoolInput(
            name="silent_errors",
            display_name="Silent Errors",
            advanced=True,
            info="If true, errors will not raise an exception.",
        ),
    ]
    outputs = [
        Output(name="data_list", display_name="Data List", method="convert_csv_to_data"),
    ]

    def convert_csv_to_data(self) -> list[Data]:
        silent_errors = self.silent_errors
        if not self.path and not self.message.files:
            raise ValueError("Please, upload a file to use this component.")
        paths = []
        if self.path:
            paths.append(self.path)
        else:
            paths = self.message.files
        result = []
        for path in paths:
            try:
                if isinstance(path,Image):
                    continue
                resolved_path = self.resolve_path(path)
                extension = Path(resolved_path).suffix[1:].lower()

                if extension=='tsv':
                    csv_args={
                        'delimiter': '\t',
                        'quotechar': '"'
                    }
                elif extension=='csv':
                    csv_args={
                        'delimiter': ',',
                        'quotechar': '"'
                    }
                elif extension=='txt' or extension=='md':
                    csv_args={
                        'delimiter': '\t',
                        'quotechar': '"',
                        'lineterminator': '\n\n',
                        'fieldnames': ['text']
                    }
                else:
                    continue

                # Create a CSV reader object
                csv_reader = csv.DictReader(resolved_path,strict=False,**csv_args)

                # Convert each row to a Data object
                for row in csv_reader:
                    result.append(Data(data=row))

            except csv.Error as e:
                error_message = f"CSV parsing error: {str(e)}"
                self.status = error_message
                if not silent_errors:
                    raise ValueError(error_message)

            except Exception as e:
                error_message = f"An error occurred: {str(e)}"
                self.status = error_message
                return [Data(data={"error": error_message})]

        self.status = result
        return result

